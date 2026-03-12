import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:dchs_motion_sensors/dchs_motion_sensors.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/video_frame_extractor.dart';
import '../../../data/data_sources/remote/panorama_service.dart';
import 'panorama_preview_screen.dart';

class PanoramaCaptureScreen extends StatefulWidget {
  const PanoramaCaptureScreen({super.key});

  @override
  State<PanoramaCaptureScreen> createState() => _PanoramaCaptureScreenState();
}

class _PanoramaCaptureScreenState extends State<PanoramaCaptureScreen>
    with SingleTickerProviderStateMixin {
  static const Duration _minRecordDuration = Duration(seconds: 3);
  static const Duration _maxRecordDuration = Duration(seconds: 30);

  CameraController? _cameraController;
  bool _isCameraReady = false;

  // Recording state
  bool _isRecording = false;
  Duration _recordingDuration = Duration.zero;
  Timer? _recordingTimer;
  String? _videoPath;

  // Processing state
  bool _isProcessing = false;
  String _processingStatus = '';

  // Gyroscope
  double _gyroX = 0;
  double _gyroY = 0;
  StreamSubscription? _gyroSubscription;
  String _directionHint = 'Quay video quét ngang';

  // Pulse animation for record button
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
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
          _gyroX += event.x * 0.1;
          _gyroY += event.y * 0.1;

          if (_gyroX.abs() > 0.5) {
            _directionHint = _gyroX > 0 ? 'Nghiêng lên' : 'Nghiêng xuống';
          } else {
            _directionHint =
                _isRecording ? 'Quét ngang đều...' : 'Quay video quét ngang';
          }
        });
      }
    });
  }

  Future<void> _startRecording() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _isRecording ||
        _isProcessing) {
      return;
    }

    try {
      await _cameraController!.startVideoRecording();
      setState(() {
        _isRecording = true;
        _recordingDuration = Duration.zero;
      });

      _pulseController.repeat(reverse: true);

      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _recordingDuration += const Duration(seconds: 1);
        });

        // Auto-stop at max duration
        if (_recordingDuration >= _maxRecordDuration) {
          _stopRecording();
        }
      });
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording || _cameraController == null) return;

    _recordingTimer?.cancel();
    _recordingTimer = null;
    _pulseController.stop();
    _pulseController.reset();

    final duration = _recordingDuration;

    try {
      final xFile = await _cameraController!.stopVideoRecording();
      setState(() => _isRecording = false);

      if (duration < _minRecordDuration) {
        // Discard video
        try {
          await File(xFile.path).delete();
        } catch (_) {}
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Quay ít nhất 3 giây để tạo panorama'),
            ),
          );
        }
        return;
      }

      _videoPath = xFile.path;
      await _processAndUpload();
    } catch (e) {
      setState(() => _isRecording = false);
      debugPrint('Error stopping recording: $e');
    }
  }

  Future<void> _processAndUpload() async {
    if (_videoPath == null) return;

    List<String> frames = [];
    setState(() {
      _isProcessing = true;
      _processingStatus = 'Đang tách ảnh từ video...';
    });

    try {
      frames = await VideoFrameExtractor.extractFrames(
        videoPath: _videoPath!,
      );

      setState(() => _processingStatus = 'Đang ghép panorama...');

      final result = await PanoramaService.instance.stitchPanorama(
        imagePaths: frames,
      );

      if (!mounted) return;

      setState(() => _isProcessing = false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => PanoramaPreviewScreen(photoDto: result),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isProcessing = false);

      String message;
      if (e is PanoramaStitchFailure) {
        message = e.displayMessage;
      } else if (e is VideoFrameExtractionException) {
        message = e.message;
      } else {
        message = e.toString().replaceFirst('Exception: ', '');
      }

      _showErrorDialog(message);
    } finally {
      // Cleanup video + frames
      _cleanup(frames);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Không thể tạo panorama'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Quay lại video'),
          ),
        ],
      ),
    );
  }

  Future<void> _cleanup(List<String> frames) async {
    // Cleanup frames
    if (frames.isNotEmpty) {
      await VideoFrameExtractor.cleanupFrames(frames);
    }
    // Cleanup video
    if (_videoPath != null) {
      try {
        await File(_videoPath!).delete();
      } catch (_) {}
      _videoPath = null;
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _pulseController.dispose();
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
            Positioned.fill(child: CameraPreview(_cameraController!))
          else
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),

          // Processing overlay
          if (_isProcessing)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha:0.7),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: Colors.white),
                      const SizedBox(height: 16),
                      Text(
                        _processingStatus,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Quá trình này có thể mất vài giây',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Top bar: close + direction hint + timer
          Positioned(
            top: topPadding + 12,
            left: 16,
            right: 16,
            child: Row(
              children: [
                // Close button
                GestureDetector(
                  onTap: _isRecording || _isProcessing
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha:0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: _isRecording || _isProcessing
                          ? Colors.white30
                          : Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Direction hint
                Expanded(
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 190),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha:0.5),
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
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Recording timer
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _isRecording
                        ? Colors.red.withValues(alpha:0.7)
                        : Colors.black.withValues(alpha:0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isRecording)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Text(
                        '${_formatDuration(_recordingDuration)} / ${_formatDuration(_maxRecordDuration)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Gyroscope guide circle in center
          if (_isCameraReady && !_isProcessing)
            Center(child: _buildGyroGuide()),

          // Bottom controls
          if (!_isProcessing)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                  top: 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha:0.8),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Record button
                    GestureDetector(
                      onTap: _isCameraReady
                          ? (_isRecording
                              ? _stopRecording
                              : _startRecording)
                          : null,
                      child: AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          final scale =
                              _isRecording ? _pulseAnimation.value : 1.0;
                          return Transform.scale(
                            scale: scale,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color:
                                      _isRecording ? Colors.red : Colors.white,
                                  shape: _isRecording
                                      ? BoxShape.rectangle
                                      : BoxShape.circle,
                                  borderRadius: _isRecording
                                      ? BorderRadius.circular(8)
                                      : null,
                                ),
                                child: _isRecording
                                    ? const Icon(
                                        Icons.stop,
                                        color: Colors.white,
                                        size: 32,
                                      )
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _isRecording
                          ? 'Nhấn để dừng quay'
                          : 'Nhấn để bắt đầu quay',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
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
    if (_directionHint.contains('lên')) {
      return const Icon(Icons.arrow_upward, color: Colors.white, size: 16);
    } else if (_directionHint.contains('xuống')) {
      return const Icon(Icons.arrow_downward, color: Colors.white, size: 16);
    }
    return const Icon(Icons.swap_horiz, color: Colors.white, size: 16);
  }

  Widget _buildGyroGuide() {
    return CustomPaint(
      size: const Size(120, 120),
      painter: _GyroGuidePainter(rotationX: _gyroX, rotationY: _gyroY),
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
    return oldDelegate.rotationX != rotationX ||
        oldDelegate.rotationY != rotationY;
  }
}
