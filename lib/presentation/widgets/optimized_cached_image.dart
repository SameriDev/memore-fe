import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';

/// Optimized cached image widget with consistent loading states and memory management
/// Specifically designed for story images and other photo content in Memore app
class OptimizedCachedImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool showLoadingProgress;
  final bool showErrorDetails;
  final Widget? placeholder;
  final Widget? errorWidget;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final int? maxWidthDiskCache;
  final Duration? fadeInDuration;
  final Duration? fadeOutDuration;

  const OptimizedCachedImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.showLoadingProgress = true,
    this.showErrorDetails = false,
    this.placeholder,
    this.errorWidget,
    this.memCacheWidth = 800,
    this.memCacheHeight,
    this.maxWidthDiskCache = 1200,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.fadeOutDuration = const Duration(milliseconds: 100),
  });

  /// Factory constructor for story images with optimized settings
  factory OptimizedCachedImage.story({
    required String imageUrl,
    BoxFit fit = BoxFit.contain,
  }) {
    return OptimizedCachedImage(
      imageUrl: imageUrl,
      fit: fit,
      memCacheWidth: 800,
      maxWidthDiskCache: 1200,
      showLoadingProgress: true,
      borderRadius: null,
      fadeInDuration: const Duration(milliseconds: 300),
    );
  }

  /// Factory constructor for profile avatars
  factory OptimizedCachedImage.avatar({
    required String imageUrl,
    required double size,
  }) {
    return OptimizedCachedImage(
      imageUrl: imageUrl,
      width: size,
      height: size,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(size / 2),
      memCacheWidth: size.toInt() * 2,
      memCacheHeight: size.toInt() * 2,
      maxWidthDiskCache: size.toInt() * 3,
      showLoadingProgress: false,
    );
  }

  /// Factory constructor for timeline/feed images
  factory OptimizedCachedImage.timeline({
    required String imageUrl,
    double? width,
    double? height,
    BorderRadius? borderRadius,
  }) {
    return OptimizedCachedImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      borderRadius: borderRadius,
      memCacheWidth: 600,
      maxWidthDiskCache: 800,
      showLoadingProgress: true,
    );
  }

  /// Preload nhiều ảnh cùng lúc với safety checks
  static void preloadBatch(BuildContext context, List<String> imageUrls) {
    if (!context.mounted) return;

    for (String url in imageUrls) {
      if (url.isNotEmpty && context.mounted) {
        try {
          // Only preload network URLs, skip local files
          if (!_isStaticLocalFile(url)) {
            precacheImage(CachedNetworkImageProvider(url), context);
          }
        } catch (e) {
          // Handle preload errors gracefully
          debugPrint('Failed to preload image: $url, Error: $e');
        }
      }
    }
  }

  /// Static helper to check if URL is local file
  static bool _isStaticLocalFile(String url) {
    return url.startsWith('file://') ||
           url.startsWith('/') ||
           (url.contains('/data/user/') || url.contains('/storage/'));
  }

  /// Check if the image URL is a local file path
  bool _isLocalFile(String url) {
    return url.startsWith('file://') ||
           url.startsWith('/') ||
           (url.contains('/data/user/') || url.contains('/storage/'));
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    // Handle local files vs network URLs differently
    if (_isLocalFile(imageUrl)) {
      // Local file - use Image.file
      String filePath = imageUrl;
      if (filePath.startsWith('file://')) {
        filePath = filePath.substring(7); // Remove 'file://' prefix
      }

      imageWidget = Image.file(
        File(filePath),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(context, error),
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          if (frame == null) return _buildPlaceholder(context);
          return AnimatedSwitcher(
            duration: fadeInDuration ?? const Duration(milliseconds: 300),
            child: child,
          );
        },
      );
    } else {
      // Network URL - use CachedNetworkImage
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 300),
        fadeOutDuration: fadeOutDuration ?? const Duration(milliseconds: 100),
        memCacheWidth: memCacheWidth,
        memCacheHeight: memCacheHeight,
        maxWidthDiskCache: maxWidthDiskCache,
        placeholder: (context, url) => _buildPlaceholder(context),
        errorWidget: (context, url, error) => _buildErrorWidget(context, error),
      );
    }

    if (borderRadius != null) {
      imageWidget = ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildPlaceholder(BuildContext context) {
    if (placeholder != null) {
      return placeholder!;
    }

    return Container(
      width: width,
      height: height,
      color: Colors.grey[900],
      child: showLoadingProgress
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Center(
              child: Icon(
                Icons.image_outlined,
                color: Colors.white.withOpacity(0.5),
                size: 32,
              ),
            ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, dynamic error) {
    if (errorWidget != null) {
      return errorWidget!;
    }

    return Container(
      width: width,
      height: height,
      color: Colors.grey[800],
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.white.withOpacity(0.6),
          size: 32,
        ),
      ),
    );
  }
}

/// Extension method to preload images using OptimizedCachedImage settings
extension ImagePreloading on OptimizedCachedImage {
  /// Preload ảnh này trước để chuyển màn mượt hơn
  void preload(BuildContext context) {
    // Only preload network URLs, skip local files
    if (!_isLocalFile(imageUrl)) {
      precacheImage(CachedNetworkImageProvider(imageUrl), context);
    }
  }
}
