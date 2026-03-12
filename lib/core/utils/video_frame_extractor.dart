import 'dart:io';

import 'package:ffmpeg_kit_flutter_min/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_min/return_code.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class VideoFrameExtractor {
  /// Tach frames tu video file, tra ve list duong dan anh JPEG.
  /// Throws [VideoFrameExtractionException] neu that bai hoac < 3 frames.
  static Future<List<String>> extractFrames({
    required String videoPath,
    int maxFrames = 12,
  }) async {
    final outputDir = await _createOutputDir();

    // Lay duration cua video de tinh fps filter
    final duration = await _getVideoDuration(videoPath);
    if (duration <= 0) {
      throw VideoFrameExtractionException('Không thể đọc video. Hãy thử quay lại.');
    }

    // Tinh fps de lay deu maxFrames tu video
    // VD: video 10s, maxFrames=12 → fps=1.2
    final fps = maxFrames / duration;

    final outputPattern = '$outputDir/frame_%03d.jpg';
    final command =
        '-i "$videoPath" -vf "fps=$fps" -frames:v $maxFrames -q:v 2 "$outputPattern"';

    debugPrint('FFmpeg command: $command');

    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();

    if (!ReturnCode.isSuccess(returnCode)) {
      final logs = await session.getLogsAsString();
      debugPrint('FFmpeg error: $logs');
      throw VideoFrameExtractionException(
        'Không thể tách ảnh từ video. Hãy thử quay lại.',
      );
    }

    // Collect output frame paths
    final frames = <String>[];
    for (var i = 1; i <= maxFrames; i++) {
      final framePath =
          '$outputDir/frame_${i.toString().padLeft(3, '0')}.jpg';
      if (File(framePath).existsSync()) {
        frames.add(framePath);
      }
    }

    if (frames.length < 3) {
      // Cleanup
      await _cleanupDir(outputDir);
      throw VideoFrameExtractionException(
        'Video quá ngắn, chỉ tách được ${frames.length} ảnh. Cần ít nhất 3 ảnh. Hãy quay video dài hơn.',
      );
    }

    debugPrint('Extracted ${frames.length} frames from video');
    return frames;
  }

  /// Lay duration (giay) cua video
  static Future<double> _getVideoDuration(String videoPath) async {
    final session = await FFprobeKit.getMediaInformation(videoPath);
    final info = session.getMediaInformation();
    if (info == null) return 0;

    final durationStr = info.getDuration();
    if (durationStr == null) return 0;

    return double.tryParse(durationStr) ?? 0;
  }

  static Future<String> _createOutputDir() async {
    final appDir = await getTemporaryDirectory();
    final outputDir = Directory(
      '${appDir.path}/memore_panorama_frames_${DateTime.now().millisecondsSinceEpoch}',
    );
    await outputDir.create(recursive: true);
    return outputDir.path;
  }

  /// Xoa thu muc frame tam
  static Future<void> cleanupFrames(List<String> framePaths) async {
    if (framePaths.isEmpty) return;
    // All frames are in the same directory
    final dir = File(framePaths.first).parent.path;
    await _cleanupDir(dir);
  }

  static Future<void> _cleanupDir(String dirPath) async {
    try {
      final dir = Directory(dirPath);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (e) {
      debugPrint('Cleanup error: $e');
    }
  }
}

class VideoFrameExtractionException implements Exception {
  final String message;
  VideoFrameExtractionException(this.message);

  @override
  String toString() => message;
}
