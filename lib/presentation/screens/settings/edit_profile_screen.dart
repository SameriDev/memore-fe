import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/user_model.dart';

/// Edit Profile Screen
/// Allows users to edit their profile information
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  UserModel? _currentUser;
  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadUserData();
    _setupListeners();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
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
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  void _setupListeners() {
    _nameController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  void _loadUserData() {
    // TODO: Load actual user data from provider
    _currentUser = MockUsers.currentUser;
    _nameController.text = _currentUser?.displayName ?? '';
    _phoneController.text = _currentUser?.phoneNumber ?? '';
  }

  void _onFieldChanged() {
    final nameChanged = _nameController.text != (_currentUser?.displayName ?? '');
    final phoneChanged = _phoneController.text != _currentUser?.phoneNumber;

    setState(() {
      _hasChanges = nameChanged || phoneChanged;
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // TODO: Implement actual profile update
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
      context.pop();
    }
  }

  void _showDiscardChangesDialog() {
    if (!_hasChanges) {
      context.pop();
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          'Discard Changes?',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'You have unsaved changes. Are you sure you want to leave?',
          style: TextStyle(
            color: Color(0xFF666666),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Stay',
              style: TextStyle(
                color: Color(0xFF666666),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              this.context.pop();
            },
            child: const Text(
              'Discard',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildAvatarBottomSheet(),
    );
  }

  Widget _buildAvatarBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF666666),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSizes.spacingLg),

          const Text(
            'Change Profile Picture',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: AppSizes.spacingLg),

          // Options
          ListTile(
            leading: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
              size: 24,
            ),
            title: const Text(
              'Take Photo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _takePhoto();
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.photo_library_outlined,
              color: Colors.white,
              size: 24,
            ),
            title: const Text(
              'Choose from Gallery',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _chooseFromGallery();
            },
          ),
          if (_currentUser?.profilePicture != null)
            ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: Color(0xFFEF4444),
                size: 24,
              ),
              title: const Text(
                'Remove Photo',
                style: TextStyle(
                  color: Color(0xFFEF4444),
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _removePhoto();
              },
            ),

          const SizedBox(height: AppSizes.spacingMd),
        ],
      ),
    );
  }

  void _takePhoto() {
    // TODO: Implement camera capture
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Camera feature coming soon'),
        backgroundColor: Color(0xFF2A2A2A),
      ),
    );
  }

  void _chooseFromGallery() {
    // TODO: Implement gallery picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gallery feature coming soon'),
        backgroundColor: Color(0xFF2A2A2A),
      ),
    );
  }

  void _removePhoto() {
    // TODO: Implement photo removal
    setState(() {
      _hasChanges = true;
    });
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.trim().length > 50) {
      return 'Name must be less than 50 characters';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    // Basic phone validation
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
            size: 24,
          ),
          onPressed: _showDiscardChangesDialog,
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _hasChanges && !_isLoading ? _saveProfile : null,
            child: Text(
              'Save',
              style: TextStyle(
                color: _hasChanges
                    ? const Color(0xFFFFD700)
                    : const Color(0xFF666666),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar section
                  AnimatedBuilder(
                    animation: _slideAnimation,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(0, -_slideAnimation.value),
                      child: child,
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: _showAvatarOptions,
                        child: Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: _getAvatarColor(),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: _getAvatarColor().withValues(alpha: 0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  _nameController.text.isNotEmpty
                                      ? _nameController.text.substring(0, 1).toUpperCase()
                                      : 'U',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFD700),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSizes.spacingXl),

                  // Form fields
                  AnimatedBuilder(
                    animation: _slideAnimation,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(0, _slideAnimation.value * 0.5),
                      child: child,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name field
                        const Text(
                          'Display Name',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSizes.spacingSm),
                        TextFormField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF2A2A2A),
                            hintText: 'Enter your name',
                            hintStyle: const TextStyle(
                              color: Color(0xFF666666),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFFFD700),
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFEF4444),
                                width: 2,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFEF4444),
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          validator: _validateName,
                          textCapitalization: TextCapitalization.words,
                        ),

                        const SizedBox(height: AppSizes.spacingLg),

                        // Phone field
                        const Text(
                          'Phone Number',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSizes.spacingSm),
                        TextFormField(
                          controller: _phoneController,
                          focusNode: _phoneFocusNode,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF2A2A2A),
                            hintText: 'Enter your phone number',
                            hintStyle: const TextStyle(
                              color: Color(0xFF666666),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFFFD700),
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFEF4444),
                                width: 2,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFEF4444),
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          validator: _validatePhone,
                          keyboardType: TextInputType.phone,
                        ),

                        const SizedBox(height: AppSizes.spacingXl),

                        // Info note
                        Container(
                          padding: const EdgeInsets.all(AppSizes.paddingMd),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF2A2A2A),
                            ),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Color(0xFF666666),
                                size: 20,
                              ),
                              SizedBox(width: AppSizes.spacingSm),
                              Expanded(
                                child: Text(
                                  'Your phone number is used for authentication and friend connections. Changing it may require re-verification.',
                                  style: TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: 12,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getAvatarColor() {
    final colors = [
      const Color(0xFFFFD700), // Yellow
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFFEF4444), // Red
      const Color(0xFF10B981), // Green
      const Color(0xFFF59E0B), // Orange
    ];
    final index = (_currentUser?.id.hashCode ?? 0) % colors.length;
    return colors[index];
  }
}
