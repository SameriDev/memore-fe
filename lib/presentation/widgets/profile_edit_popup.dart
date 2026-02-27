import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/user_profile.dart';
import '../../data/local/user_manager.dart';
import '../widgets/app_popup.dart';
import 'image_picker_bottom_sheet.dart';

class ProfileEditPopup extends StatefulWidget {
  final UserProfile user;
  final VoidCallback? onProfileUpdated;

  const ProfileEditPopup({
    super.key,
    required this.user,
    this.onProfileUpdated,
  });

  @override
  State<ProfileEditPopup> createState() => _ProfileEditPopupState();
}

class _ProfileEditPopupState extends State<ProfileEditPopup> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  DateTime? _selectedBirthday;
  String? _selectedImagePath;
  bool _isSaving = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _selectedBirthday = widget.user.birthday;

    // Add listeners to detect changes
    _nameController.addListener(_checkForChanges);
    _emailController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    final hasNameChange = _nameController.text != widget.user.name;
    final hasEmailChange = _emailController.text != widget.user.email;
    final hasBirthdayChange = _selectedBirthday != widget.user.birthday;
    final hasImageChange = _selectedImagePath != null;

    final newHasChanges = hasNameChange || hasEmailChange || hasBirthdayChange || hasImageChange;

    if (newHasChanges != _hasChanges) {
      setState(() => _hasChanges = newHasChanges);
    }
  }

  Future<void> _pickProfileImage() async {
    final imagePath = await ImagePickerBottomSheet.show(context);
    if (imagePath != null) {
      setState(() {
        _selectedImagePath = imagePath;
      });
      _checkForChanges();
    }
  }

  Future<void> _selectBirthday() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Chọn ngày sinh',
      cancelText: 'Hủy',
      confirmText: 'Chọn',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() => _selectedBirthday = selectedDate);
      _checkForChanges();
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate() || !_hasChanges) return;

    setState(() => _isSaving = true);

    try {
      final updates = <String, dynamic>{};

      // Update name if changed
      if (_nameController.text.trim() != widget.user.name) {
        updates['name'] = _nameController.text.trim();
      }

      // Update email if changed
      if (_emailController.text.trim() != widget.user.email) {
        updates['email'] = _emailController.text.trim();
      }

      // Update birthday if changed
      if (_selectedBirthday != widget.user.birthday) {
        updates['birthday'] = _selectedBirthday?.toIso8601String();
      }

      // Update profile image if selected
      bool imageUpdateSuccess = true;
      if (_selectedImagePath != null) {
        imageUpdateSuccess = await UserManager.instance.updateAvatar(_selectedImagePath!);
        if (!imageUpdateSuccess) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Lỗi khi cập nhật ảnh đại diện')),
            );
          }
        }
      }

      // Update other profile fields
      bool profileUpdateSuccess = true;
      if (updates.isNotEmpty) {
        profileUpdateSuccess = await UserManager.instance.updateProfile(updates);
        if (!profileUpdateSuccess) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Lỗi khi cập nhật thông tin cá nhân')),
            );
          }
        }
      }

      if (mounted) {
        if ((imageUpdateSuccess && profileUpdateSuccess) || updates.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cập nhật thông tin thành công')),
          );
          widget.onProfileUpdated?.call();
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Có lỗi xảy ra khi cập nhật thông tin')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập tên';
    }
    if (value.trim().length < 2) {
      return 'Tên phải có ít nhất 2 ký tự';
    }
    if (value.trim().length > 50) {
      return 'Tên không được quá 50 ký tự';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập email';
    }
    if (!UserManager.instance.isValidEmail(value.trim())) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AppPopup(
      size: AppPopupSize.medium,
      title: 'Chỉnh sửa thông tin',
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile Image Section
            GestureDetector(
              onTap: _pickProfileImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _selectedImagePath != null
                        ? FileImage(File(_selectedImagePath!))
                        : (widget.user.avatarUrl.isNotEmpty
                            ? NetworkImage(widget.user.avatarUrl)
                            : null),
                    child: widget.user.avatarUrl.isEmpty && _selectedImagePath == null
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2D2D2D),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Tên',
                labelStyle: GoogleFonts.inika(color: AppColors.textSecondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
              validator: _validateName,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            // Email Field
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: GoogleFonts.inika(color: AppColors.textSecondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
              validator: _validateEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16),
            // Birthday Field
            GestureDetector(
              onTap: _selectBirthday,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.cake,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedBirthday != null
                            ? DateFormat('dd/MM/yyyy').format(_selectedBirthday!)
                            : 'Chọn ngày sinh',
                        style: GoogleFonts.inika(
                          color: _selectedBirthday != null
                              ? AppColors.text
                              : AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.calendar_month,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Hủy',
            style: GoogleFonts.inika(color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: (_hasChanges && !_isSaving) ? _saveChanges : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  'Lưu',
                  style: GoogleFonts.inika(),
                ),
        ),
      ],
    );
  }
}