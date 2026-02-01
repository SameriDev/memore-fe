import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import '../../../data/local/photo_storage_manager.dart';
import '../../../data/local/user_manager.dart';

class PhotoPreviewScreen extends StatefulWidget {
  final String imagePath;

  const PhotoPreviewScreen({
    super.key,
    required this.imagePath,
  });

  @override
  State<PhotoPreviewScreen> createState() => _PhotoPreviewScreenState();
}

class _PhotoPreviewScreenState extends State<PhotoPreviewScreen> {
  final TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;
  double _rotation = 0.0;
  double _scale = 1.0;
  bool _isEditing = false;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void _rotateImage() {
    setState(() {
      _rotation += 90.0;
      if (_rotation >= 360) _rotation = 0.0;
    });
  }

  void _resetImage() {
    setState(() {
      _rotation = 0.0;
      _scale = 1.0;
    });
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _savePhoto() async {
    setState(() => _isLoading = true);

    try {
      // Prepare photo data
      final caption = _captionController.text.trim();

      // Save photo using PhotoStorageManager
      final photoId = await PhotoStorageManager.instance.savePhoto(
        imagePath: widget.imagePath,
        caption: caption.isNotEmpty ? caption : 'Ảnh chụp từ camera',
        metadata: {
          'location': 'Hà Nội, Việt Nam', // Mock location for demo
          'tags': ['camera', 'memore'],
          'rotation': _rotation,
          'scale': _scale,
        },
      );

      // Update user photo count
      await UserManager.instance.incrementPhotoCount();

      if (photoId != null) {
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Ảnh đã được lưu thành công!',
                style: GoogleFonts.inika(),
              ),
              backgroundColor: const Color(0xFF4CAF50),
            ),
          );

          // Navigate back to main screen
          Navigator.of(context).pop(); // Close preview
          Navigator.of(context).pop(); // Close camera
        }
      } else {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Lỗi khi lưu ảnh. Vui lòng thử lại.',
                style: GoogleFonts.inika(),
              ),
              backgroundColor: const Color(0xFFD32F2F),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Có lỗi xảy ra khi lưu ảnh.',
              style: GoogleFonts.inika(),
            ),
            backgroundColor: const Color(0xFFD32F2F),
          ),
        );
      }
      debugPrint('Error saving photo: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildEditButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPressed,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(12),
          ),
          icon: Icon(icon, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inika(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with close button
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Xem trước',
                    style: GoogleFonts.inika(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _toggleEditMode,
                    icon: Icon(
                      _isEditing ? Icons.check : Icons.edit,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Photo preview with editing controls
            Expanded(
              child: Column(
                children: [
                  // Edit controls
                  if (_isEditing)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildEditButton(
                            icon: Icons.rotate_right,
                            label: 'Xoay',
                            onPressed: _rotateImage,
                          ),
                          _buildEditButton(
                            icon: Icons.restart_alt,
                            label: 'Đặt lại',
                            onPressed: _resetImage,
                          ),
                          _buildEditButton(
                            icon: Icons.check,
                            label: 'Xong',
                            onPressed: _toggleEditMode,
                          ),
                        ],
                      ),
                    ),

                  // Photo container
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Transform.rotate(
                          angle: _rotation * 3.14159 / 180,
                          child: Transform.scale(
                            scale: _scale,
                            child: Image.file(
                              File(widget.imagePath),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[800],
                                  child: const Center(
                                    child: Icon(
                                      Icons.error,
                                      color: Colors.white,
                                      size: 48,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Caption input
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _captionController,
                style: GoogleFonts.inika(
                  color: Colors.white,
                  fontSize: 16,
                ),
                maxLines: 3,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: 'Thêm mô tả cho ảnh của bạn...',
                  hintStyle: GoogleFonts.inika(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Action buttons
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Retake button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Chụp lại',
                        style: GoogleFonts.inika(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Save button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _savePhoto,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B4513),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Lưu ảnh',
                              style: GoogleFonts.inika(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}