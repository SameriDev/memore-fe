import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../../data/local/user_manager.dart';
import '../../../data/local/photo_storage_manager.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/data_sources/remote/photo_service.dart';
import 'widgets/camera_viewfinder.dart';
import 'widgets/camera_controls.dart';
import 'models/camera_state.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isFlashOn = false;
  bool _isFrontCamera = false;

  // New state variables for inline preview
  CameraMode _currentMode = CameraMode.capture;
  String? _capturedImagePath;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadCameraSettings();
    _initializeCamera();
  }

  Future<void> _loadCameraSettings() async {
    try {
      final flashMode = UserManager.instance.getSetting<bool>('camera.flashOn', defaultValue: false);
      final frontCamera = UserManager.instance.getSetting<bool>('camera.frontCamera', defaultValue: false);

      setState(() {
        _isFlashOn = flashMode ?? false;
        _isFrontCamera = frontCamera ?? false;
      });
    } catch (e) {
      debugPrint('Error loading camera settings: $e');
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        await _setupCamera(_isFrontCamera ? 1 : 0);
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<void> _setupCamera(int cameraIndex) async {
    if (_cameras == null || _cameras!.isEmpty) return;

    final camera = _cameras![cameraIndex];
    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error setting up camera: $e');
    }
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      setState(() {
        _isFlashOn = !_isFlashOn;
      });

      await _cameraController!.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );

      // Save flash setting
      await UserManager.instance.updateSettings('camera.flashOn', _isFlashOn);
    } catch (e) {
      debugPrint('Error toggling flash: $e');
    }
  }

  Future<void> _flipCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;

    try {
      // Dispose camera controller cũ
      if (_cameraController != null) {
        await _cameraController!.dispose();
        _cameraController = null;
      }

      // Đợi một chút để camera session được giải phóng hoàn toàn
      await Future.delayed(const Duration(milliseconds: 100));

      // Toggle camera
      setState(() {
        _isFrontCamera = !_isFrontCamera;
      });

      // Setup camera mới
      await _setupCamera(_isFrontCamera ? 1 : 0);

      // Save camera preference
      await UserManager.instance.updateSettings('camera.frontCamera', _isFrontCamera);
    } catch (e) {
      debugPrint('Error flipping camera: $e');
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      setState(() => _isProcessing = true);

      final image = await _cameraController!.takePicture();

      setState(() {
        _currentMode = CameraMode.preview;
        _capturedImagePath = image.path;
        _isProcessing = false;
      });
    } catch (e) {
      debugPrint('Error capturing photo: $e');

      if (mounted) {
        setState(() => _isProcessing = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lỗi khi chụp ảnh. Vui lòng thử lại.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _confirmPhoto() async {
    if (_capturedImagePath == null) return;

    try {
      setState(() => _isProcessing = true);

      // Save photo without caption
      final photoId = await PhotoStorageManager.instance.savePhoto(
        imagePath: _capturedImagePath!,
        caption: 'Ảnh chụp từ camera',
        metadata: {
          'location': 'Hà Nội, Việt Nam',
          'tags': ['camera', 'memore'],
        },
      );

      if (photoId != null) {
        // Update user photo count
        await UserManager.instance.incrementPhotoCount();

        // Fire-and-forget upload to server
        final userId = StorageService.instance.userId;
        if (userId != null) {
          final storagePath = PhotoStorageManager.instance.getPhotoPath(photoId);
          if (storagePath != null) {
            PhotoService.instance
                .uploadPhoto(
                  localFilePath: storagePath,
                  userId: userId,
                  caption: 'Ảnh chụp từ camera',
                )
                .then((remotePhoto) {
              if (remotePhoto != null) {
                PhotoStorageManager.instance
                    .updateRemoteId(photoId, remotePhoto.id);
                debugPrint('Photo uploaded to server: ${remotePhoto.id}');
              }
            }).catchError((e) {
              debugPrint('Background upload failed: $e');
            });
          }
        }

        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ảnh đã được lưu thành công!'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate back to main screen
          Navigator.of(context).pop();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Lỗi khi lưu ảnh. Vui lòng thử lại.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error confirming photo: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Có lỗi xảy ra khi lưu ảnh.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _cancelPreview() {
    setState(() {
      _currentMode = CameraMode.capture;
      _capturedImagePath = null;
    });
  }


  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F2F0),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            SingleChildScrollView(
              physics: isKeyboardVisible ? const ClampingScrollPhysics() : const NeverScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 60),

                      // Camera viewfinder
                      CameraViewfinder(
                        controller: _cameraController,
                        capturedImagePath: _capturedImagePath,
                      ),

                      const Spacer(),

                      // Camera controls
                      Padding(
                        padding: EdgeInsets.only(bottom: isKeyboardVisible ? keyboardHeight + 16 : 0),
                        child: CameraControls(
                          isFlashOn: _isFlashOn,
                          onFlashToggle: _toggleFlash,
                          onCapture: _currentMode == CameraMode.capture
                            ? _capturePhoto
                            : _confirmPhoto,
                          onFlipCamera: _currentMode == CameraMode.capture
                            ? _flipCamera
                            : _cancelPreview,
                          mode: _currentMode,
                          isProcessing: _isProcessing,
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Close button
            Positioned(
              top: 20,
              left: 20,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.black, size: 24),
                ),
              ),
            ),

            // Loading overlay
            if (_isProcessing)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
