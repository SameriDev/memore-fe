import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../../data/local/user_manager.dart';
import 'photo_preview_screen.dart';
import 'widgets/camera_viewfinder.dart';
import 'widgets/camera_controls.dart';
import 'widgets/message_input.dart';
import '../../routes/custom_route_transitions.dart';

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
  final TextEditingController _messageController = TextEditingController();

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
      final image = await _cameraController!.takePicture();

      // Navigate to photo preview screen with smooth transition
      if (mounted) {
        context.pushSlideBottom(PhotoPreviewScreen(
          imagePath: image.path,
        ));
      }
    } catch (e) {
      debugPrint('Error capturing photo: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lỗi khi chụp ảnh. Vui lòng thử lại.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  @override
  void dispose() {
    _cameraController?.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F2F0),
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                const SizedBox(height: 60),

                // Camera viewfinder
                CameraViewfinder(
                  controller: _cameraController,
                ),

                const SizedBox(height: 16),

                // Message input
                MessageInput(controller: _messageController),

                const Spacer(),

                // Camera controls
                CameraControls(
                  isFlashOn: _isFlashOn,
                  onFlashToggle: _toggleFlash,
                  onCapture: _capturePhoto,
                  onFlipCamera: _flipCamera,
                ),

                const SizedBox(height: 24),
              ],
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
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.black, size: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
