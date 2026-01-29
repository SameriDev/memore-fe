import 'package:flutter/material.dart';
import '../recent_photos_viewer_screen.dart';

class PhotoViewer extends StatelessWidget {
  final PageController pageController;
  final List<PhotoItem> photos;
  final ValueChanged<int> onPageChanged;

  const PhotoViewer({
    super.key,
    required this.pageController,
    required this.photos,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      onPageChanged: onPageChanged,
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                photos[index].imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                      color: Colors.white,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 500,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image_outlined,
                          size: 64,
                          color: Colors.white38,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Failed to load image',
                          style: TextStyle(
                            fontFamily: 'Inika',
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
