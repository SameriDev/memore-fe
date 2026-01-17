/// App route constants for navigation using GoRouter
/// Defines all named routes and their paths in the application
class AppRoutes {
  AppRoutes._();

  // Root Routes
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String home = '/home';

  // Onboarding Routes
  static const String onboarding = '/onboarding';
  static const String widgetDemo = '/onboarding/widget-demo';

  // Authentication Routes
  static const String auth = '/auth';
  static const String phoneInput = '/auth/phone-input';
  static const String verification = '/auth/verification';
  static const String passwordSetup = '/auth/password-setup';
  static const String signIn = '/auth/sign-in';

  // Main App Routes
  static const String camera = '/camera';
  static const String photoPreview = '/camera/photo-preview';
  static const String friendSelect = '/camera/friend-select';

  // Messages Routes
  static const String messages = '/messages';
  static const String chat = '/messages/chat';

  // Friends Routes
  static const String friends = '/friends';
  static const String addFriend = '/friends/add';
  static const String friendProfile = '/friends/profile';
  static const String friendRequests = '/friends/requests';

  // Photo & Feed Routes
  static const String photoFeed = '/photos';
  static const String photoView = '/photos/view';
  static const String timeTravel = '/photos/time-travel';

  // Settings Routes
  static const String settings = '/settings';
  static const String profile = '/settings/profile';
  static const String editProfile = '/settings/profile/edit';
  static const String notifications = '/settings/notifications';
  static const String privacy = '/settings/privacy';
  static const String blockedUsers = '/settings/privacy/blocked';
  static const String storage = '/settings/storage';
  static const String about = '/settings/about';

  // Route Parameter Keys
  static const String paramUserId = 'userId';
  static const String paramFriendId = 'friendId';
  static const String paramPhotoId = 'photoId';
  static const String paramPhoneNumber = 'phoneNumber';
  static const String paramChatId = 'chatId';

  // Route Query Parameter Keys
  static const String queryReturnTo = 'returnTo';
  static const String queryFromCamera = 'fromCamera';
  static const String queryPhotoPath = 'photoPath';

  // Route Names for easier navigation
  static const Map<String, String> routeNames = {
    splash: 'Splash',
    welcome: 'Welcome',
    onboarding: 'Onboarding',
    widgetDemo: 'Widget Demo',
    phoneInput: 'Phone Input',
    verification: 'Verification',
    passwordSetup: 'Password Setup',
    signIn: 'Sign In',
    home: 'Home',
    camera: 'Camera',
    photoPreview: 'Photo Preview',
    friendSelect: 'Friend Select',
    messages: 'Messages',
    chat: 'Chat',
    friends: 'Friends',
    addFriend: 'Add Friend',
    friendProfile: 'Friend Profile',
    friendRequests: 'Friend Requests',
    photoFeed: 'Photo Feed',
    photoView: 'Photo View',
    timeTravel: 'Time Travel',
    settings: 'Settings',
    profile: 'Profile',
    editProfile: 'Edit Profile',
    notifications: 'Notifications',
    privacy: 'Privacy',
    blockedUsers: 'Blocked Users',
    storage: 'Storage',
    about: 'About',
  };

  // Helper method to get route name
  static String getRouteName(String route) {
    return routeNames[route] ?? 'Unknown';
  }

  // Helper methods for route building
  static String buildFriendProfileRoute(String friendId) {
    return '$friendProfile?$paramFriendId=$friendId';
  }

  static String buildPhotoViewRoute(String photoId) {
    return '$photoView?$paramPhotoId=$photoId';
  }

  static String buildVerificationRoute(String phoneNumber) {
    return '$verification?$paramPhoneNumber=$phoneNumber';
  }

  static String buildPhotoPreviewRoute(String photoPath) {
    return '$photoPreview?$queryPhotoPath=$photoPath';
  }

  // Route groups for easier organization
  static const List<String> authRoutes = [
    auth,
    phoneInput,
    verification,
    passwordSetup,
    signIn,
  ];

  static const List<String> onboardingRoutes = [onboarding, widgetDemo];

  static const List<String> mainAppRoutes = [
    home,
    camera,
    messages,
    friends,
    photoFeed,
    settings,
  ];

  static const List<String> settingsRoutes = [
    settings,
    profile,
    editProfile,
    notifications,
    privacy,
    blockedUsers,
    storage,
    about,
  ];

  // Helper method to check if route requires authentication
  static bool requiresAuth(String route) {
    return !authRoutes.contains(route) &&
        !onboardingRoutes.contains(route) &&
        route != splash &&
        route != welcome;
  }

  // Helper method to check if route is onboarding
  static bool isOnboardingRoute(String route) {
    return onboardingRoutes.contains(route) || route == welcome;
  }

  // Helper method to check if route is authentication
  static bool isAuthRoute(String route) {
    return authRoutes.contains(route);
  }

  // Helper method to check if route is main app
  static bool isMainAppRoute(String route) {
    return mainAppRoutes.contains(route) ||
        route.startsWith('/camera') ||
        route.startsWith('/friends') ||
        route.startsWith('/photos') ||
        route.startsWith('/settings');
  }
}
