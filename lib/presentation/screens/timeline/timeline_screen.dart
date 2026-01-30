import 'package:flutter/material.dart';
import 'models/timeline_models.dart';
import 'config/timeline_config.dart';
import 'widgets/timeline_item.dart';

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
