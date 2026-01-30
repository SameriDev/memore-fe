import 'package:flutter/material.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: const Color(0xFFE8DDD0)),
          Positioned(
            left: -100,
            bottom: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFD6A5).withOpacity(0.6),
                    const Color(0xFFFFD6A5).withOpacity(0.0),
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            right: -80,
            bottom: 100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFC857).withOpacity(0.4),
                    const Color(0xFFFFC857).withOpacity(0.0),
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Timeline',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Inika',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Hãy xem lại thời gian của bạn',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontFamily: 'Inika',
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C2C2C),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  height: 1,
                  color: Colors.black,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 100, top: 40),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 24,
                          top: 0,
                          bottom: 0,
                          child: Container(width: 2, color: Colors.transparent),
                        ),
                        Positioned(
                          right: 24,
                          top: 0,
                          bottom: 0,
                          child: Container(width: 2, color: Colors.transparent),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              _TimelineItem(
                                alignment: TimelineAlignment.left,
                                imageUrl:
                                    'https://picsum.photos/seed/summer1/400/300',
                                title: 'Summer',
                                subtitle: 'Em đẹp yêu anh',
                                time: '03:38 3-6',
                                day: '15',
                              ),
                              const SizedBox(height: 50),
                              _TimelineItem(
                                alignment: TimelineAlignment.right,
                                imageUrl:
                                    'https://picsum.photos/seed/animal1/400/300',
                                title: 'Animal',
                                subtitle: 'Kỷ niệm cùng bạn bè',
                                time: '10:22 15-6',
                                day: '22',
                              ),
                              const SizedBox(height: 50),
                              _TimelineItem(
                                alignment: TimelineAlignment.left,
                                imageUrl:
                                    'https://picsum.photos/seed/summer2/400/300',
                                title: 'Summer',
                                subtitle: 'Chuyến đi biển',
                                time: '16:45 28-6',
                                day: '28',
                              ),
                              const SizedBox(height: 50),
                              _TimelineItem(
                                alignment: TimelineAlignment.right,
                                imageUrl:
                                    'https://picsum.photos/seed/winter1/400/300',
                                title: 'Winter',
                                subtitle: 'Ngày đông lạnh giá',
                                time: '09:15 5-12',
                                day: '5',
                              ),
                              const SizedBox(height: 50),
                              _TimelineItem(
                                alignment: TimelineAlignment.left,
                                imageUrl:
                                    'https://picsum.photos/seed/spring1/400/300',
                                title: 'Spring',
                                subtitle: 'Hoa nở rộ khắp nơi',
                                time: '14:30 20-3',
                                day: '20',
                              ),
                              const SizedBox(height: 50),
                              _TimelineItem(
                                alignment: TimelineAlignment.right,
                                imageUrl:
                                    'https://picsum.photos/seed/autumn1/400/300',
                                title: 'Autumn',
                                subtitle: 'Lá vàng rơi đầy đường',
                                time: '11:20 15-9',
                                day: '15',
                              ),
                              const SizedBox(height: 50),
                              _TimelineItem(
                                alignment: TimelineAlignment.left,
                                imageUrl:
                                    'https://picsum.photos/seed/beach1/400/300',
                                title: 'Beach',
                                subtitle: 'Sóng biển xanh mát',
                                time: '17:00 8-7',
                                day: '8',
                              ),
                              const SizedBox(height: 50),
                              _TimelineItem(
                                alignment: TimelineAlignment.right,
                                imageUrl:
                                    'https://picsum.photos/seed/mountain1/400/300',
                                title: 'Mountain',
                                subtitle: 'Đỉnh núi hùng vĩ',
                                time: '06:45 12-10',
                                day: '12',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum TimelineAlignment { left, right }

class _TimelineItem extends StatelessWidget {
  final TimelineAlignment alignment;
  final String imageUrl;
  final String title;
  final String subtitle;
  final String time;
  final String day;

  const _TimelineItem({
    required this.alignment,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    final isLeft = alignment == TimelineAlignment.left;

    return Container(
      margin: EdgeInsets.only(left: isLeft ? 0 : 50, right: isLeft ? 50 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLeft) ...[
            SizedBox(
              width: 50,
              height: 180,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(top: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8DDD0),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      day,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Inika',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 50),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 40),
            Expanded(
              flex: 4,
              child: SizedBox(
                height: 180,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '"$subtitle"',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ] else ...[
            Expanded(
              flex: 4,
              child: SizedBox(
                height: 180,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '"$subtitle"',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 40),
            Expanded(
              flex: 6,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 50),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 50,
              height: 180,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(top: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8DDD0),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      day,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Inika',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
