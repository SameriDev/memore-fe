import 'package:flutter/material.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final ScrollController _scrollController = ScrollController();
  String _currentDate = 'Jun 2024';
  String _currentDay = '15';
  String _currentMonth = 'Jun';

  final List<TimelineItemData> _timelineItems = [
    TimelineItemData(
      alignment: TimelineAlignment.left,
      images: [
        'https://picsum.photos/seed/summer1/400/300',
        'https://picsum.photos/seed/summer2/400/300',
        'https://picsum.photos/seed/summer3/400/300',
      ],
      title: 'Summer',
      subtitle: 'Em đẹp yêu anh',
      time: '03:38 3-6',
      day: '15',
      month: 'Jun',
      displayDate: 'Jun 2024',
    ),
    TimelineItemData(
      alignment: TimelineAlignment.right,
      images: [
        'https://picsum.photos/seed/animal1/400/300',
        'https://picsum.photos/seed/animal2/400/300',
      ],
      title: 'Animal',
      subtitle: 'Kỷ niệm cùng bạn bè',
      time: '10:22 15-6',
      day: '22',
      month: 'Jun',
      displayDate: 'Jun 2024',
    ),
    TimelineItemData(
      alignment: TimelineAlignment.left,
      images: [
        'https://picsum.photos/seed/beach1/400/300',
        'https://picsum.photos/seed/beach2/400/300',
        'https://picsum.photos/seed/beach3/400/300',
        'https://picsum.photos/seed/beach4/400/300',
      ],
      title: 'Beach',
      subtitle: 'Chuyến đi biển',
      time: '16:45 28-6',
      day: '28',
      month: 'Jun',
      displayDate: 'Jun 2024',
    ),
    TimelineItemData(
      alignment: TimelineAlignment.right,
      images: [
        'https://picsum.photos/seed/winter1/400/300',
        'https://picsum.photos/seed/winter2/400/300',
        'https://picsum.photos/seed/winter3/400/300',
      ],
      title: 'Winter',
      subtitle: 'Ngày đông lạnh giá',
      time: '09:15 5-12',
      day: '5',
      month: 'Dec',
      displayDate: 'Dec 2024',
    ),
    TimelineItemData(
      alignment: TimelineAlignment.left,
      images: [
        'https://picsum.photos/seed/spring1/400/300',
        'https://picsum.photos/seed/spring2/400/300',
      ],
      title: 'Spring',
      subtitle: 'Hoa nở rộ khắp nơi',
      time: '14:30 20-3',
      day: '20',
      month: 'Mar',
      displayDate: 'Mar 2025',
    ),
    TimelineItemData(
      alignment: TimelineAlignment.right,
      images: [
        'https://picsum.photos/seed/autumn1/400/300',
        'https://picsum.photos/seed/autumn2/400/300',
        'https://picsum.photos/seed/autumn3/400/300',
        'https://picsum.photos/seed/autumn4/400/300',
        'https://picsum.photos/seed/autumn5/400/300',
      ],
      title: 'Autumn',
      subtitle: 'Lá vàng rơi đầy đường',
      time: '11:20 15-9',
      day: '15',
      month: 'Sep',
      displayDate: 'Sep 2025',
    ),
    TimelineItemData(
      alignment: TimelineAlignment.left,
      images: [
        'https://picsum.photos/seed/party1/400/300',
        'https://picsum.photos/seed/party2/400/300',
        'https://picsum.photos/seed/party3/400/300',
      ],
      title: 'Party',
      subtitle: 'Tiệc tùng vui vẻ',
      time: '17:00 8-7',
      day: '8',
      month: 'Jul',
      displayDate: 'Jul 2025',
    ),
    TimelineItemData(
      alignment: TimelineAlignment.right,
      images: [
        'https://picsum.photos/seed/mountain1/400/300',
        'https://picsum.photos/seed/mountain2/400/300',
      ],
      title: 'Mountain',
      subtitle: 'Đỉnh núi hùng vĩ',
      time: '06:45 12-10',
      day: '12',
      month: 'Oct',
      displayDate: 'Oct 2025',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final scrollOffset = _scrollController.offset;
    final itemHeight = 230.0;
    final index = (scrollOffset / itemHeight).round();

    if (index >= 0 && index < _timelineItems.length) {
      final item = _timelineItems[index];
      if (item.day != _currentDay || item.month != _currentMonth) {
        setState(() {
          _currentDay = item.day;
          _currentMonth = item.month;
          _currentDate = item.displayDate;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.white),
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
                  height: 50,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentDay,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Inika',
                              height: 1.0,
                            ),
                          ),
                          Text(
                            _currentMonth,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.6),
                              fontFamily: 'Inika',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(height: 1, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
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
                            children: _timelineItems.map((item) {
                              return Column(
                                children: [
                                  _TimelineItem(
                                    alignment: item.alignment,
                                    images: item.images,
                                    title: item.title,
                                    subtitle: item.subtitle,
                                    time: item.time,
                                    day: item.day,
                                    month: item.month,
                                  ),
                                  const SizedBox(height: 50),
                                ],
                              );
                            }).toList(),
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

class TimelineItemData {
  final TimelineAlignment alignment;
  final List<String> images;
  final String title;
  final String subtitle;
  final String time;
  final String day;
  final String month;
  final String displayDate;

  TimelineItemData({
    required this.alignment,
    required this.images,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.day,
    required this.month,
    required this.displayDate,
  });
}

enum TimelineAlignment { left, right }

class _TimelineItem extends StatelessWidget {
  final TimelineAlignment alignment;
  final List<String> images;
  final String title;
  final String subtitle;
  final String time;
  final String day;
  final String month;

  const _TimelineItem({
    required this.alignment,
    required this.images,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.day,
    required this.month,
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
              width: 70,
              height: 180,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 70,
                  height: 70,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFF8C42).withOpacity(0.5),
                        const Color(0xFFFFB380).withOpacity(0.35),
                        const Color(0xFFFFB380).withOpacity(0.2),
                        const Color(0xFFFFB380).withOpacity(0.1),
                        const Color(0xFFFFB380).withOpacity(0.0),
                      ],
                      stops: const [0.0, 0.2, 0.4, 0.7, 1.0],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          day,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Inika',
                          ),
                        ),
                        Text(
                          month,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: 'Inika',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(flex: 6, child: _buildImageCluster()),
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
            Expanded(flex: 6, child: _buildImageCluster()),
            SizedBox(
              width: 70,
              height: 180,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 70,
                  height: 70,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFF8C42).withOpacity(0.5),
                        const Color(0xFFFFB380).withOpacity(0.35),
                        const Color(0xFFFFB380).withOpacity(0.2),
                        const Color(0xFFFFB380).withOpacity(0.1),
                        const Color(0xFFFFB380).withOpacity(0.0),
                      ],
                      stops: const [0.0, 0.2, 0.4, 0.7, 1.0],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          day,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Inika',
                          ),
                        ),
                        Text(
                          month,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: 'Inika',
                          ),
                        ),
                      ],
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

  Widget _buildImageCluster() {
    if (images.isEmpty) {
      return Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[300],
        ),
      );
    }

    if (images.length == 1) {
      return Container(
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
            images[0],
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
      );
    }

    if (images.length == 2) {
      return Container(
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
          child: Row(
            children: [
              Expanded(
                child: Image.network(
                  images[0],
                  fit: BoxFit.cover,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 30),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: Image.network(
                  images[1],
                  fit: BoxFit.cover,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 30),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (images.length == 3) {
      return Container(
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
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Image.network(
                  images[0],
                  fit: BoxFit.cover,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 30),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        images[1],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image_not_supported, size: 20),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 2),
                    Expanded(
                      child: Image.network(
                        images[2],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image_not_supported, size: 20),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
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
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Image.network(
                      images[0],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.image_not_supported, size: 20),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 2),
                  Expanded(
                    child: Image.network(
                      images[1],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.image_not_supported, size: 20),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Image.network(
                      images[2],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.image_not_supported, size: 20),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 2),
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          images[3],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 20,
                                ),
                              ),
                            );
                          },
                        ),
                        if (images.length > 4)
                          Container(
                            color: Colors.black.withOpacity(0.5),
                            child: Center(
                              child: Text(
                                '+${images.length - 4}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
