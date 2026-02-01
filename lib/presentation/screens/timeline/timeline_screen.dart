import 'package:flutter/material.dart';
import 'models/timeline_models.dart';
import 'config/timeline_config.dart';
import 'widgets/timeline_item.dart';
import 'widgets/album_carousel_viewer.dart';
import '../../../data/local/photo_storage_manager.dart';
import 'dart:io';

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

  List<TimelineItemData> _timelineItems = [];
  bool _isLoading = true;

  // Mock data với thời gian quá khứ
  final List<TimelineItemData> _mockTimelineItems = [
    TimelineItemData(
      alignment: TimelineAlignment.left,
      images: [
        'https://picsum.photos/seed/summer1/400/300',
        'https://picsum.photos/seed/summer2/400/300',
        'https://picsum.photos/seed/summer3/400/300',
      ],
      title: 'Summer',
      subtitle: 'Em đéo yêu anh',
      time: '03:38 3-6',
      day: '15',
      month: 'Jun',
      displayDate: 'Jun 2023',
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
      displayDate: 'Jun 2023',
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
      displayDate: 'Jun 2023',
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
      displayDate: 'Dec 2023',
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
      displayDate: 'Mar 2023',
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
      displayDate: 'Sep 2023',
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
      displayDate: 'Jul 2023',
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
      displayDate: 'Oct 2023',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadTimelineData();
  }

  Future<void> _loadTimelineData() async {
    setState(() => _isLoading = true);

    try {
      // Lấy photos thật từ PhotoStorageManager
      final realPhotos = PhotoStorageManager.instance.getUserPhotos();

      List<TimelineItemData> realTimelineItems = [];

      // Nhóm photos theo ngày
      Map<String, List<Map<String, dynamic>>> photosByDate = {};

      for (final photo in realPhotos) {
        final timestamp = photo['timestamp'] as int;
        final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

        if (!photosByDate.containsKey(dateKey)) {
          photosByDate[dateKey] = [];
        }
        photosByDate[dateKey]!.add(photo);
      }

      // Tạo TimelineItem cho mỗi ngày
      int alignmentIndex = 0;
      for (final dateKey in photosByDate.keys) {
        final photosOfDay = photosByDate[dateKey]!;
        final firstPhoto = photosOfDay.first;
        final timestamp = firstPhoto['timestamp'] as int;
        final date = DateTime.fromMillisecondsSinceEpoch(timestamp);

        // Tạo danh sách đường dẫn ảnh cho ngày này
        final imagePaths = photosOfDay.map((photo) => 'file://${photo['storagePath']}').toList();

        // Tạo title dựa trên số lượng ảnh
        String title;
        if (photosOfDay.length == 1) {
          title = photosOfDay.first['caption']?.toString().isNotEmpty == true
            ? photosOfDay.first['caption']
            : 'Ảnh chụp';
        } else {
          title = 'Kỷ niệm ${photosOfDay.length} ảnh';
        }

        realTimelineItems.add(TimelineItemData(
          alignment: alignmentIndex % 2 == 0 ? TimelineAlignment.left : TimelineAlignment.right,
          images: imagePaths,
          title: title,
          subtitle: 'Ảnh từ camera của bạn',
          time: '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} ${date.day}-${date.month}',
          day: date.day.toString(),
          month: _getMonthName(date.month),
          displayDate: '${_getMonthName(date.month)} ${date.year}',
        ));

        alignmentIndex++;
      }

      // Kết hợp real photos và mock data, sắp xếp theo thời gian (mới nhất trước)
      final allItems = [...realTimelineItems, ..._mockTimelineItems];
      allItems.sort((a, b) {
        final aDate = _parseTimelineDate(a);
        final bDate = _parseTimelineDate(b);
        return bDate.compareTo(aDate); // Mới nhất trước
      });

      setState(() {
        _timelineItems = allItems;
        _isLoading = false;
        if (_timelineItems.isNotEmpty) {
          _currentDay = _timelineItems.first.day;
          _currentMonth = _timelineItems.first.month;
          _currentDate = _timelineItems.first.displayDate;
        }
      });
    } catch (e) {
      setState(() {
        _timelineItems = _mockTimelineItems;
        _isLoading = false;
      });
    }
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  DateTime _parseTimelineDate(TimelineItemData item) {
    // Parse từ displayDate format "Mon YYYY"
    final parts = item.displayDate.split(' ');
    final year = int.parse(parts[1]);
    final month = _getMonthNumber(parts[0]);
    final day = int.parse(item.day);
    return DateTime(year, month, day);
  }

  int _getMonthNumber(String monthName) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months.indexOf(monthName) + 1;
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

  void _showAlbumCarousel(List<String> images, int initialIndex) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        pageBuilder: (context, animation, secondaryAnimation) {
          return AlbumCarouselViewer(
            images: images,
            initialIndex: initialIndex,
            onClose: () {
              Navigator.of(context).pop();
            },
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F2F0),
      body: Stack(
        children: [
          // Decorative Ellipse - Top Right
          Positioned(
            top: -300,
            right: -300,
            child: Container(
              width: 800,
              height: 800,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFCBA03).withOpacity(0.20),
                    const Color(0xFFFCBA03).withOpacity(0.02),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),
          // Decorative Ellipse - Bottom Left
          Positioned(
            bottom: -200,
            left: -300,
            child: Container(
              width: 800,
              height: 800,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFCBA03).withOpacity(0.20),
                    const Color(0xFFFCBA03).withOpacity(0.02),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),
          // Main Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final config = ResponsiveConfig.fromWidth(constraints.maxWidth);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(config),
                    const SizedBox(height: 16),
                    _buildDateIndicator(config),
                    Expanded(child: _buildTimelineList(config)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ResponsiveConfig config) {
    return Padding(
      padding: EdgeInsets.all(config.headerPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Timeline',
                style: TextStyle(
                  fontSize: config.headerTitleSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Inika',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Hãy xem lại thời gian của bạn',
                style: TextStyle(
                  fontSize: config.headerSubtitleSize,
                  color: Colors.black54,
                  fontFamily: 'Inika',
                ),
              ),
            ],
          ),
          Container(
            width: config.headerIconSize,
            height: config.headerIconSize,
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2C),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_month_outlined,
              color: Colors.white,
              size: config.headerIconSize * 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateIndicator(ResponsiveConfig config) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: config.headerPadding),
      height: 50,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _currentDay,
                style: TextStyle(
                  fontSize: config.dateIndicatorDaySize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Inika',
                  height: 1.0,
                ),
              ),
              Text(
                _currentMonth,
                style: TextStyle(
                  fontSize: config.dateIndicatorMonthSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.6),
                  fontFamily: 'Inika',
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(child: Container(height: 1, color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildTimelineList(ResponsiveConfig config) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B4513)),
        ),
      );
    }

    if (_timelineItems.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timeline,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Chưa có ảnh nào trong timeline',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontFamily: 'Inika',
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: EdgeInsets.only(bottom: 100, top: config.itemTopPadding),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: config.contentPadding),
        child: Column(
          children: _timelineItems.map((item) {
            return Column(
              children: [
                TimelineItem(
                  alignment: item.alignment,
                  images: item.images,
                  title: item.title,
                  subtitle: item.subtitle,
                  time: item.time,
                  day: item.day,
                  month: item.month,
                  config: config,
                  onAlbumTap: item.images.isNotEmpty
                      ? () => _showAlbumCarousel(item.images, 0)
                      : null,
                ),
                SizedBox(height: config.itemSpacing),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
