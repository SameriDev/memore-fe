import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'widgets/camera_viewfinder.dart';
import 'widgets/camera_controls.dart';
import 'widgets/message_input.dart';

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
  String? _capturedImagePath;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
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
    } catch (e) {
      debugPrint('Error toggling flash: $e');
    }
  }

  Future<void> _flipCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;

    setState(() {
      _isFrontCamera = !_isFrontCamera;
    });

    await _cameraController?.dispose();
    await _setupCamera(_isFrontCamera ? 1 : 0);
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final image = await _cameraController!.takePicture();
      setState(() {
        _capturedImagePath = image.path;
      });
    } catch (e) {
      debugPrint('Error capturing photo: $e');
    }
  }

  void _submitPhoto() {
    // TODO: Implement photo submission logic
    // This will upload the photo with message to backend
    final message = _messageController.text;
    debugPrint('Submitting photo with message: $message');
    debugPrint('Photo path: $_capturedImagePath');

    // Navigate back after submission
    Navigator.of(context).pop();
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
                Expanded(
                  child: Center(
                    child: CameraViewfinder(
                      controller: _cameraController,
                      capturedImagePath: _capturedImagePath,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Message input
                MessageInput(controller: _messageController),

                const SizedBox(height: 24),

                // Camera controls
                CameraControls(
                  isFlashOn: _isFlashOn,
                  onFlashToggle: _toggleFlash,
                  onCapture: _capturedImagePath == null
                      ? _capturePhoto
                      : _submitPhoto,
                  onFlipCamera: _flipCamera,
                ),

                const SizedBox(height: 40),
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
