import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_routes.dart';
import '../../../providers/auth_provider.dart';

/// Name Setup Screen matching Locket design
/// Final step in authentication flow - set first and last name
class NameSetupScreen extends ConsumerStatefulWidget {
  final String email;
  final String password;

  const NameSetupScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  ConsumerState<NameSetupScreen> createState() => _NameSetupScreenState();
}

class _NameSetupScreenState extends ConsumerState<NameSetupScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  bool _isValidNames = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _firstNameController.addListener(_validateNames);
    _lastNameController.addListener(_validateNames);
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    super.dispose();
  }

  void _validateNames() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    setState(() {
      _isValidNames = firstName.isNotEmpty && lastName.isNotEmpty;
    });
  }

  void _completeRegistration() async {
    if (!_isValidNames || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Create account with auth provider
      final success = await ref.read(authProvider.notifier).signUp(
        phoneNumber: widget.email, // Using email as identifier
        password: widget.password,
        displayName: '${_firstNameController.text} ${_lastNameController.text}',
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (success) {
          // Navigate to main app
          context.go(AppRoutes.home);
        } else {
          // Show error
          _showErrorDialog('Failed to create account. Please try again.');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('An error occurred. Please try again.');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'Error',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Color(0xFFB3B3B3)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: Color(0xFFFFD700)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLg),
          child: Column(
            children: [
              // Back button
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 2),

              // Main content
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeOut,
                  )),
                  child: Column(
                    children: [
                      // Title
                      const Text(
                        "What's your name?",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),

                      const SizedBox(height: AppSizes.spacing3xl),

                      // First name input field
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _firstNameFocusNode.hasFocus
                                ? const Color(0xFFFFD700)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: TextField(
                          controller: _firstNameController,
                          focusNode: _firstNameFocusNode,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) => _lastNameFocusNode.requestFocus(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Virgil',
                            hintStyle: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(20),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSizes.spacingMd),

                      // Last name input field
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _lastNameFocusNode.hasFocus
                                ? const Color(0xFFFFD700)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: TextField(
                          controller: _lastNameController,
                          focusNode: _lastNameFocusNode,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _completeRegistration(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Howell',
                            hintStyle: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: AppSizes.buttonHeightSm,
                child: ElevatedButton(
                  onPressed: _isValidNames && !_isLoading ? _completeRegistration : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isValidNames
                        ? const Color(0xFFFFD700)
                        : const Color(0xFF404040),
                    foregroundColor: _isValidNames ? Colors.black : const Color(0xFF666666),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: _isValidNames ? Colors.black : const Color(0xFF666666),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              size: 20,
                              color: _isValidNames ? Colors.black : const Color(0xFF666666),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: AppSizes.spacingXl),
            ],
          ),
        ),
      ),
    );
  }
}