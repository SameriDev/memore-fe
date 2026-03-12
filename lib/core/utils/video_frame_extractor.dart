import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoFrameExtractor {
  /// Tach frames tu video file, tra ve list duong dan anh JPEG.
  /// Throws [VideoFrameExtractionException] neu that bai hoac < 3 frames.
  static Future<List<String>> extractFrames({
    required String videoPath,
    int maxFrames = 12,
  }) async {
    final outputDir = await _createOutputDir();

    try {
      // Sử dụng video_thumbnail để tạo nhiều thumbnail ở các thời điểm khác nhau
      final frames = <String>[];

      for (var i = 0; i < maxFrames; i++) {
        // Tính thời điểm để tách frame (phân bố đều trong video)
        // Ví dụ: video 10s, maxFrames=12 → timeMs = [0, 833, 1667, 2500, ...]
        final timeMs = (i * 10000 ~/ maxFrames); // Ước tính mỗi frame cách 833ms

        try {
          final thumbnailPath = await VideoThumbnail.thumbnailFile(
            video: videoPath,
            thumbnailPath: '$outputDir/frame_${i.toString().padLeft(3, '0')}.jpg',
            imageFormat: ImageFormat.JPEG,
            timeMs: timeMs,
            quality: 90,
          );

          if (thumbnailPath != null && File(thumbnailPath).existsSync()) {
            frames.add(thumbnailPath);
          }
        } catch (e) {
          debugPrint('Error extracting frame $i: $e');
          // Tiếp tục với frame tiếp theo
        }
      }

      if (frames.length < 3) {
        // Cleanup
        await _cleanupDir(outputDir);
        throw VideoFrameExtractionException(
          'Video quá ngắn hoặc không hợp lệ, chỉ tách được ${frames.length} ảnh. Cần ít nhất 3 ảnh. Hãy quay video dài hơn.',
        );
      }

      debugPrint('Extracted ${frames.length} frames from video');
      return frames;

    } catch (e) {
      // Cleanup on error
      await _cleanupDir(outputDir);
      if (e is VideoFrameExtractionException) {
        rethrow;
      }
      throw VideoFrameExtractionException(
        'Không thể tách ảnh từ video. Hãy thử quay lại. Lỗi: $e',
      );
    }
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
