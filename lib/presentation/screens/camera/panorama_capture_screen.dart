import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:dchs_motion_sensors/dchs_motion_sensors.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/data_sources/remote/panorama_service.dart';
import 'panorama_preview_screen.dart';

class PanoramaCaptureScreen extends StatefulWidget {
  const PanoramaCaptureScreen({super.key});

  @override
  State<PanoramaCaptureScreen> createState() => _PanoramaCaptureScreenState();
}

class _PanoramaCaptureScreenState extends State<PanoramaCaptureScreen> {
  static const int _minPhotosToStitch = 3;
  static const int _maxPhotosToStitch = 20;
  static const double _autoCaptureAngleStep = 0.18;
  static const Duration _autoCaptureMinInterval = Duration(milliseconds: 700);

  CameraController? _cameraController;
  bool _isCameraReady = false;
  final List<String> _capturedPaths = [];
  bool _isCapturing = false;
  bool _isStitching = false;
  bool _isAutoCaptureEnabled = false;
  double _lastAutoCaptureGyroY = 0;
  DateTime _lastAutoCaptureAt = DateTime.fromMillisecondsSinceEpoch(0);

  // Gyroscope
  double _gyroX = 0;
  double _gyroY = 0;
  StreamSubscription? _gyroSubscription;
  String _directionHint = 'Xoay ngang Ä‘á»ƒ chá»¥p';

  @override
  void initState() {
    super.initState();
    _initCamera();
    _initGyroscope();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    final backCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      backCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    if (mounted) setState(() => _isCameraReady = true);
  }

  void _initGyroscope() {
    motionSensors.gyroscopeUpdateInterval = 100000; // 100ms
    _gyroSubscription = motionSensors.gyroscope.listen((event) {
      if (mounted) {
        setState(() {
          // Accumulate rotation for direction hint
          _gyroX += event.x * 0.1;
          _gyroY += event.y * 0.1;

          // Update direction hint based on accumulated rotation
          if (_gyroX.abs() > 0.5) {
            _directionHint = _gyroX > 0 ? 'NghiÃªng lÃªn' : 'NghiÃªng xuá»‘ng';
          } else {
            _directionHint = 'Xoay ngang Ä‘á»ƒ chá»¥p';
          }
        });
        _maybeAutoCapture();
      }
    });
  }

  Future<void> _capturePhoto({bool showLimitMessage = true}) async {
    if (_isCapturing || _cameraController == null || !_cameraController!.value.isInitialized) return;
    if (_capturedPaths.length >= _maxPhotosToStitch) {
      if (_isAutoCaptureEnabled) {
        setState(() => _isAutoCaptureEnabled = false);
      }
      if (showLimitMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Da dat gioi han toi da 20 anh cho panorama')),
        );
      }
      return;
    }

    setState(() => _isCapturing = true);
    try {
      final file = await _cameraController!.takePicture();
      setState(() {
        _capturedPaths.add(file.path);
        _lastAutoCaptureGyroY = _gyroY;
        _lastAutoCaptureAt = DateTime.now();
      });
    } catch (e) {
      debugPrint('Error capturing photo: $e');
    } finally {
      setState(() => _isCapturing = false);
    }
  }

  void _toggleAutoCapture() {
    if (!_isCameraReady || _isStitching) return;

    setState(() {
      _isAutoCaptureEnabled = !_isAutoCaptureEnabled;
      _lastAutoCaptureGyroY = _gyroY;
      _lastAutoCaptureAt = DateTime.now();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isAutoCaptureEnabled
              ? 'Da bat tu chup. Xoay ngang deu de chup lien tuc'
              : 'Da tat tu chup',
        ),
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  Future<void> _maybeAutoCapture() async {
    if (!_isAutoCaptureEnabled || _isStitching || _isCapturing) return;
    if (_capturedPaths.length >= _maxPhotosToStitch) {
      if (mounted) setState(() => _isAutoCaptureEnabled = false);
      return;
    }

    final now = DateTime.now();
    if (now.difference(_lastAutoCaptureAt) < _autoCaptureMinInterval) return;

    final delta = (_gyroY - _lastAutoCaptureGyroY).abs();
    if (delta < _autoCaptureAngleStep) return;

    await _capturePhoto(showLimitMessage: false);
  }

  void _removeLastPhoto() {
    if (_capturedPaths.isEmpty) return;
    final removed = _capturedPaths.removeLast();
    // Delete the file
    try {
      File(removed).deleteSync();
    } catch (_) {}
    setState(() {});
  }

  Future<void> _finishCapture() async {
    if (_capturedPaths.length < _minPhotosToStitch) return;

    setState(() {
      _isStitching = true;
      _isAutoCaptureEnabled = false;
    });
    try {
      final result = await PanoramaService.instance.stitchPanorama(
        imagePaths: _capturedPaths,
      );

      if (!mounted) return;
      setState(() => _isStitching = false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => PanoramaPreviewScreen(photoDto: result),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isStitching = false);
      String message;
      if (e is PanoramaStitchFailure) {
        message = e.displayMessage;
      } else {
        message = e.toString().replaceFirst('Exception: ', '');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  void dispose() {
    _gyroSubscription?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview
          if (_isCameraReady)
            Positioned.fill(
              child: CameraPreview(_cameraController!),
            )
          else
            const Center(child: CircularProgressIndicator(color: Colors.white)),

          // Stitching overlay
          if (_isStitching)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.7),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        'Äang ghÃ©p áº£nh panorama...',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'QuÃ¡ trÃ¬nh nÃ y cÃ³ thá»ƒ máº¥t vÃ i giÃ¢y',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Top bar: close button + direction hint + counter
          Positioned(
            top: topPadding + 12,
            left: 16,
            right: 16,
            child: Row(
              children: [
                // Close button
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 24),
                  ),
                ),
                const SizedBox(width: 8),
                // Direction hint
                Expanded(
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 170),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildDirectionIcon(),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              _directionHint,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Photo counter
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${_capturedPaths.length}/$_maxPhotosToStitch anh',
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          // Gyroscope guide circle in center
          if (_isCameraReady && !_isStitching)
            Center(
              child: _buildGyroGuide(),
            ),

          // Bottom controls
          if (!_isStitching)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                  top: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: GestureDetector(
                          onTap: _toggleAutoCapture,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: _isAutoCaptureEnabled
                                  ? AppColors.primary.withValues(alpha: 0.9)
                                  : Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _isAutoCaptureEnabled ? Icons.motion_photos_on : Icons.motion_photos_off,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _isAutoCaptureEnabled ? 'Tu chup: BAT' : 'Tu chup: TAT',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Thumbnail strip
                    if (_capturedPaths.isNotEmpty)
                      SizedBox(
                        height: 56,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _capturedPaths.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(_capturedPaths[index]),
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Capture button + undo + finish
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Undo button
                        GestureDetector(
                          onTap: _capturedPaths.isNotEmpty ? _removeLastPhoto : null,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: _capturedPaths.isNotEmpty ? 0.2 : 0.05),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.undo,
                              color: _capturedPaths.isNotEmpty ? Colors.white : Colors.white30,
                              size: 24,
                            ),
                          ),
                        ),

                        // Capture button
                        GestureDetector(
                          onTap: (_isCapturing || _capturedPaths.length >= _maxPhotosToStitch) ? null : _capturePhoto,
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: (_isCapturing || _capturedPaths.length >= _maxPhotosToStitch)
                                    ? Colors.grey
                                    : Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),

                        // Finish button
                        GestureDetector(
                          onTap: _capturedPaths.length >= _minPhotosToStitch ? _finishCapture : null,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: _capturedPaths.length >= _minPhotosToStitch
                                  ? AppColors.primary
                                  : Colors.white.withValues(alpha: 0.05),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              color: _capturedPaths.length >= _minPhotosToStitch ? Colors.white : Colors.white30,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (_capturedPaths.length >= _minPhotosToStitch && _capturedPaths.length < _maxPhotosToStitch)
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          _isAutoCaptureEnabled
                              ? 'Tu chup dang bat, nhan ✓ bat cu luc nao de hoan tat'
                              : 'Nháº¥n âœ“ Ä‘á»ƒ hoÃ n táº¥t',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      )
                    else if (_capturedPaths.length >= _maxPhotosToStitch)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Da dat toi da 20 anh, nhan ✓ de hoan tat',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Can it nhat $_minPhotosToStitch anh (da chup ${_capturedPaths.length})',
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDirectionIcon() {
    if (_directionHint.contains('lÃªn')) {
      return const Icon(Icons.arrow_upward, color: Colors.white, size: 16);
    } else if (_directionHint.contains('xuá»‘ng')) {
      return const Icon(Icons.arrow_downward, color: Colors.white, size: 16);
    }
    return const Icon(Icons.swap_horiz, color: Colors.white, size: 16);
  }

  Widget _buildGyroGuide() {
    return CustomPaint(
      size: const Size(120, 120),
      painter: _GyroGuidePainter(
        rotationX: _gyroX,
        rotationY: _gyroY,
      ),
    );
  }
}

class _GyroGuidePainter extends CustomPainter {
  final double rotationX;
  final double rotationY;

  _GyroGuidePainter({required this.rotationX, required this.rotationY});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer circle
    final outerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, outerPaint);

    // Direction arrow based on gyro
    final angle = math.atan2(rotationY, rotationX);
    final arrowLength = radius * 0.6;
    final arrowEnd = Offset(
      center.dx + math.cos(angle) * arrowLength,
      center.dy + math.sin(angle) * arrowLength,
    );

    final arrowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, arrowEnd, arrowPaint);

    // Center dot
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _GyroGuidePainter oldDelegate) {
    return oldDelegate.rotationX != rotationX || oldDelegate.rotationY != rotationY;
  }
}
