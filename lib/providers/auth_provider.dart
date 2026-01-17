import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user_model.dart';

/// Authentication state representing current auth status
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final UserModel? user;
  final String? error;
  final bool hasCompletedOnboarding;

  const AuthState({
    required this.isAuthenticated,
    required this.isLoading,
    this.user,
    this.error,
    required this.hasCompletedOnboarding,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    UserModel? user,
    String? error,
    bool? hasCompletedOnboarding,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error ?? this.error,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }

  /// Initial state
  static const AuthState initial = AuthState(
    isAuthenticated: false,
    isLoading: false,
    hasCompletedOnboarding: false,
  );

  /// Loading state
  AuthState toLoading() => copyWith(isLoading: true, error: null);

  /// Success state
  AuthState toSuccess({UserModel? user}) => copyWith(
        isAuthenticated: true,
        isLoading: false,
        user: user,
        error: null,
      );

  /// Error state
  AuthState toError(String error) => copyWith(
        isLoading: false,
        error: error,
      );

  /// Unauthenticated state
  AuthState toUnauthenticated() => copyWith(
        isAuthenticated: false,
        isLoading: false,
        user: null,
        error: null,
      );
}

/// Phone verification state for OTP flow
class PhoneVerificationState {
  final String? phoneNumber;
  final bool isCodeSent;
  final bool isVerifying;
  final bool isVerified;
  final String? error;
  final int? resendCount;
  final DateTime? lastResendTime;

  const PhoneVerificationState({
    this.phoneNumber,
    required this.isCodeSent,
    required this.isVerifying,
    required this.isVerified,
    this.error,
    this.resendCount = 0,
    this.lastResendTime,
  });

  PhoneVerificationState copyWith({
    String? phoneNumber,
    bool? isCodeSent,
    bool? isVerifying,
    bool? isVerified,
    String? error,
    int? resendCount,
    DateTime? lastResendTime,
  }) {
    return PhoneVerificationState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isCodeSent: isCodeSent ?? this.isCodeSent,
      isVerifying: isVerifying ?? this.isVerifying,
      isVerified: isVerified ?? this.isVerified,
      error: error,
      resendCount: resendCount ?? this.resendCount,
      lastResendTime: lastResendTime ?? this.lastResendTime,
    );
  }

  static const PhoneVerificationState initial = PhoneVerificationState(
    isCodeSent: false,
    isVerifying: false,
    isVerified: false,
  );

  /// Can resend code (60 seconds cooldown)
  bool get canResendCode {
    if (lastResendTime == null) return true;
    final timeSinceLastResend = DateTime.now().difference(lastResendTime!);
    return timeSinceLastResend.inSeconds >= 60;
  }

  /// Time remaining until can resend
  int get resendCooldownSeconds {
    if (lastResendTime == null) return 0;
    final timeSinceLastResend = DateTime.now().difference(lastResendTime!);
    final remaining = 60 - timeSinceLastResend.inSeconds;
    return remaining > 0 ? remaining : 0;
  }
}

/// Authentication provider using Riverpod for state management
/// Handles login, logout, registration, and phone verification with placeholder data
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.initial) {
    _checkInitialAuthState();
  }

  /// Check if user is already authenticated (placeholder implementation)
  Future<void> _checkInitialAuthState() async {
    state = state.toLoading();

    // Simulate checking stored auth state
    await Future.delayed(const Duration(milliseconds: 500));

    // For placeholder implementation, check if we have a mock user stored
    // In real app, this would check secure storage/keychain
    final hasStoredAuth = false; // Placeholder: always start unauthenticated

    if (hasStoredAuth) {
      state = state.toSuccess(user: MockUsers.currentUser);
    } else {
      state = state.toUnauthenticated();
    }
  }

  /// Send verification code to phone number
  Future<bool> sendVerificationCode(String phoneNumber) async {
    try {
      // Simulate API call to send verification code
      await Future.delayed(const Duration(milliseconds: 1500));

      // For placeholder: always succeed
      // In real app: make API call to send SMS/call
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Verify phone number with code
  Future<bool> verifyPhoneCode(String phoneNumber, String code) async {
    try {
      // Simulate API call to verify code
      await Future.delayed(const Duration(milliseconds: 1000));

      // For placeholder: accept any 6-digit code
      if (code.length == 6 && RegExp(r'^\d+$').hasMatch(code)) {
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Sign up with phone number and password
  Future<bool> signUp({
    required String phoneNumber,
    required String password,
    String? displayName,
  }) async {
    state = state.toLoading();

    try {
      // Simulate API call for user registration
      await Future.delayed(const Duration(milliseconds: 2000));

      // Create mock user with provided data
      final newUser = MockUsers.currentUser.copyWith(
        phoneNumber: phoneNumber,
        displayName: displayName,
        createdAt: DateTime.now(),
        lastSeenAt: DateTime.now(),
      );

      // For placeholder: always succeed
      state = state.toSuccess(user: newUser);
      return true;
    } catch (e) {
      state = state.toError('Failed to create account. Please try again.');
      return false;
    }
  }

  /// Sign in with phone number and password
  Future<bool> signIn({
    required String phoneNumber,
    required String password,
  }) async {
    state = state.toLoading();

    try {
      // Simulate API call for authentication
      await Future.delayed(const Duration(milliseconds: 1500));

      // For placeholder: always succeed with mock user
      final user = MockUsers.currentUser.copyWith(
        phoneNumber: phoneNumber,
        lastSeenAt: DateTime.now(),
      );

      state = state.toSuccess(user: user);
      return true;
    } catch (e) {
      state = state.toError('Invalid credentials. Please try again.');
      return false;
    }
  }

  /// Sign out user
  Future<void> signOut() async {
    state = state.toLoading();

    try {
      // Simulate API call to invalidate session
      await Future.delayed(const Duration(milliseconds: 500));

      // Clear stored auth data
      // In real app: clear secure storage, revoke tokens, etc.

      state = state.toUnauthenticated();
    } catch (e) {
      state = state.toError('Failed to sign out. Please try again.');
    }
  }

  /// Complete onboarding flow
  void completeOnboarding() {
    state = state.copyWith(hasCompletedOnboarding: true);
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? displayName,
    String? profilePicture,
  }) async {
    if (state.user == null) return false;

    state = state.toLoading();

    try {
      // Simulate API call to update profile
      await Future.delayed(const Duration(milliseconds: 1000));

      final updatedUser = state.user!.copyWith(
        displayName: displayName ?? state.user!.displayName,
        profilePicture: profilePicture ?? state.user!.profilePicture,
      );

      state = state.toSuccess(user: updatedUser);
      return true;
    } catch (e) {
      state = state.toError('Failed to update profile. Please try again.');
      return false;
    }
  }

  /// Delete account
  Future<bool> deleteAccount() async {
    state = state.toLoading();

    try {
      // Simulate API call to delete account
      await Future.delayed(const Duration(milliseconds: 2000));

      // For placeholder: always succeed
      state = state.toUnauthenticated();
      return true;
    } catch (e) {
      state = state.toError('Failed to delete account. Please try again.');
      return false;
    }
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Reset authentication state
  void reset() {
    state = AuthState.initial;
  }
}

/// Phone verification provider
class PhoneVerificationNotifier extends StateNotifier<PhoneVerificationState> {
  PhoneVerificationNotifier() : super(PhoneVerificationState.initial);

  /// Send verification code
  Future<bool> sendCode(String phoneNumber) async {
    state = state.copyWith(
      phoneNumber: phoneNumber,
      isCodeSent: false,
      error: null,
    );

    try {
      // Simulate sending code
      await Future.delayed(const Duration(milliseconds: 1500));

      // For placeholder: always succeed
      state = state.copyWith(
        isCodeSent: true,
        lastResendTime: DateTime.now(),
      );

      return true;
    } catch (e) {
      state = state.copyWith(error: 'Failed to send verification code');
      return false;
    }
  }

  /// Resend verification code
  Future<bool> resendCode() async {
    if (!state.canResendCode) return false;

    try {
      // Simulate resending code
      await Future.delayed(const Duration(milliseconds: 1000));

      state = state.copyWith(
        lastResendTime: DateTime.now(),
        resendCount: (state.resendCount ?? 0) + 1,
        error: null,
      );

      return true;
    } catch (e) {
      state = state.copyWith(error: 'Failed to resend code');
      return false;
    }
  }

  /// Verify code
  Future<bool> verifyCode(String code) async {
    state = state.copyWith(isVerifying: true, error: null);

    try {
      // Simulate code verification
      await Future.delayed(const Duration(milliseconds: 1000));

      // For placeholder: accept any 6-digit code
      final isValid = code.length == 6 && RegExp(r'^\d+$').hasMatch(code);

      if (isValid) {
        state = state.copyWith(
          isVerifying: false,
          isVerified: true,
        );
        return true;
      } else {
        state = state.copyWith(
          isVerifying: false,
          error: 'Invalid verification code',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isVerifying: false,
        error: 'Verification failed',
      );
      return false;
    }
  }

  /// Clear verification state
  void clear() {
    state = PhoneVerificationState.initial;
  }
}

/// Provider instances
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

final phoneVerificationProvider =
    StateNotifierProvider<PhoneVerificationNotifier, PhoneVerificationState>(
  (ref) => PhoneVerificationNotifier(),
);

/// Convenient getters for auth state
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user;
});

final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).error;
});

final hasCompletedOnboardingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).hasCompletedOnboarding;
});

/// Auth guard provider for routing
final authGuardProvider = Provider<AuthGuard>((ref) {
  return AuthGuard(ref);
});

/// Auth guard for protecting routes
class AuthGuard {
  final Ref _ref;

  AuthGuard(this._ref);

  bool get isAuthenticated => _ref.read(isAuthenticatedProvider);
  bool get hasCompletedOnboarding => _ref.read(hasCompletedOnboardingProvider);
  UserModel? get currentUser => _ref.read(currentUserProvider);

  /// Check if user can access a protected route
  bool canAccess(String route) {
    // Public routes that don't require authentication
    const publicRoutes = [
      '/',
      '/welcome',
      '/onboarding',
      '/onboarding/widget-demo',
      '/auth',
      '/auth/phone-input',
      '/auth/verification',
      '/auth/password-setup',
      '/auth/sign-in',
    ];

    if (publicRoutes.contains(route)) {
      return true;
    }

    // All other routes require authentication
    if (!isAuthenticated) {
      return false;
    }

    // Check if onboarding is completed for main app routes
    const onboardingRequiredRoutes = [
      '/home',
      '/camera',
      '/friends',
      '/photos',
      '/settings',
    ];

    if (onboardingRequiredRoutes.any((r) => route.startsWith(r))) {
      return hasCompletedOnboarding;
    }

    return true;
  }

  /// Get redirect route for unauthorized access
  String getRedirectRoute(String attemptedRoute) {
    if (!isAuthenticated) {
      return '/auth/phone-input';
    }

    if (!hasCompletedOnboarding) {
      return '/onboarding';
    }

    return '/';
  }
}