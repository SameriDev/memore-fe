import 'package:flutter/material.dart';
import 'optimized_cached_image.dart';

/// 3-photo preview grid:
/// ┌───────────┬───────┐
/// │           │ img2  │
/// │   img1    ├───────┤
/// │  (large)  │ img3  │
/// │           │       │
/// └───────────┴───────┘
class AlbumPreviewGrid extends StatelessWidget {
  final List<String> imageUrls;
  final double borderRadius;

  const AlbumPreviewGrid({
    super.key,
    required this.imageUrls,
    this.borderRadius = 12,
  }) : assert(imageUrls.length == 3);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Row(
        children: [
          // Left: large image (img1)
          Expanded(
            flex: 3,
            child: _buildImage(imageUrls[0]),
          ),
          const SizedBox(width: 2),
          // Right: two stacked images
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(child: _buildImage(imageUrls[1])),
                const SizedBox(height: 2),
                Expanded(child: _buildImage(imageUrls[2])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String url) {
    if (url.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Icon(Icons.image, color: Colors.grey),
      );
    }
    return OptimizedCachedImage.timeline(
      imageUrl: url,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
