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
