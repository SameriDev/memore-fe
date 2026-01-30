import 'package:flutter/material.dart';
import '../../../../domain/entities/timeline_photo.dart';

class TimelinePhotoCard extends StatelessWidget {
  final TimelinePhoto photo;
  final int index;

  const TimelinePhotoCard({
    super.key,
    required this.photo,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Time info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time
                  Text(
                    photo.time,
                    style: const TextStyle(
                      fontFamily: 'Inika',
                      fontSize: 14,
                      color: Color(0xFF797878),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Season
                  Text(
                    photo.season,
                    style: const TextStyle(
                      fontFamily: 'Inika',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Description
                  Text(
                    photo.description,
                    style: const TextStyle(
                      fontFamily: 'Inika',
                      fontSize: 12,
                      color: Color(0xFF797878),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Right side - Stacked Photos
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 300,
              child: Stack(
                children: [
                  // Render các ảnh từ sau ra trước để tạo stacked effect
                  // Background images first, foreground image last
                  ...List.generate(
                    photo.imageUrls.length > 4 ? 4 : photo.imageUrls.length,
                    (stackIndex) {
                      // stackIndex = 0 → background (xa nhất)
                      // stackIndex = last → foreground (gần nhất)
                      final reverseIndex =
                          photo.imageUrls.length - 1 - stackIndex;
                      if (reverseIndex < 0 ||
                          reverseIndex >= photo.imageUrls.length) {
                        return const SizedBox.shrink();
                      }

                      // Offset cho mỗi layer - ảnh foreground offset nhiều hơn
                      // Background images ở góc trên-trái (offset = 0)
                      // Foreground images ở góc dưới-phải (offset lớn)
                      final layersCount = photo.imageUrls.length > 4
                          ? 4
                          : photo.imageUrls.length;
                      final offsetPerLayer = 10.0;
                      final leftOffset = stackIndex * offsetPerLayer;
                      final topOffset = stackIndex * offsetPerLayer;

                      // Opacity - background images hơi mờ
                      final opacity = stackIndex == layersCount - 1
                          ? 1.0
                          : 0.85;

                      return Positioned(
                        left: leftOffset,
                        top: topOffset,
                        child: Opacity(
                          opacity: opacity,
                          child: Container(
                            width: 180, // Fixed width cho tất cả layers
                            height: 270, // Fixed height cho tất cả layers
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(2, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                photo.imageUrls[reverseIndex],
                                width: 180,
                                height: 270,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(
                                        Icons.image,
                                        size: 60,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Timeline dot marker
          SizedBox(
            width: 20,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 8), // Ở đầu lớp ảnh
                child: Container(
                  width: 16, // Tăng size từ 12 lên 16
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF464646),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
