class TimelineItemData {
  final TimelineAlignment alignment;
  final List<String> images;
  String title;
  String subtitle;
  final String time;
  final String day;
  final String month;
  final String displayDate;
  final List<String> photoIds;

  TimelineItemData({
    required this.alignment,
    required this.images,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.day,
    required this.month,
    required this.displayDate,
    this.photoIds = const [],
  });
}

enum TimelineAlignment { left, right }
