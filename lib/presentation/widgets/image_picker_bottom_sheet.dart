import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  const ImagePickerBottomSheet({super.key});

  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => const ImagePickerBottomSheet(),
    );
  }

  Future<String?> _pickImageFromCamera() async {
    final picker = ImagePicker();

    // Check camera permission
    final cameraStatus = await Permission.camera.request();
    if (!cameraStatus.isGranted) {
      return null;
    }

    try {
      final image = await picker.pickImage(source: ImageSource.camera);
      return image?.path;
    } catch (e) {
      debugPrint('Camera picker error: $e');
      return null;
    }
  }

  Future<String?> _pickImageFromGallery() async {
    final picker = ImagePicker();

    // Check photo permission
    PermissionStatus photoStatus;
    if (Platform.isAndroid) {
      photoStatus = await Permission.storage.request();
    } else {
      photoStatus = await Permission.photos.request();
    }

    if (!photoStatus.isGranted) {
      return null;
    }

    try {
      final image = await picker.pickImage(source: ImageSource.gallery);
      return image?.path;
    } catch (e) {
      debugPrint('Gallery picker error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle indicator
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          // Title
          const Text(
            'Chọn ảnh đại diện',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),
          // Camera option
          _ImagePickerOption(
            icon: Icons.camera_alt,
            title: 'Chụp ảnh',
            subtitle: 'Sử dụng camera để chụp ảnh mới',
            onTap: () async {
              final imagePath = await _pickImageFromCamera();
              if (context.mounted) {
                Navigator.of(context).pop(imagePath);
              }
            },
          ),
          const SizedBox(height: 16),
          // Gallery option
          _ImagePickerOption(
            icon: Icons.photo_library,
            title: 'Thư viện ảnh',
            subtitle: 'Chọn ảnh từ thư viện',
            onTap: () async {
              final imagePath = await _pickImageFromGallery();
              if (context.mounted) {
                Navigator.of(context).pop(imagePath);
              }
            },
          ),
          const SizedBox(height: 20),
          // Cancel button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Hủy',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          // Safe area padding for bottom
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

class _ImagePickerOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ImagePickerOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF2D2D2D),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}