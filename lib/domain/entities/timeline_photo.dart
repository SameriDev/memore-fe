class TimelinePhoto {
  final String id;
  final List<String> imageUrls; // Danh sách ảnh để tạo stacked effect
  final String time;
  final String season;
  final String description;

  const TimelinePhoto({
    required this.id,
    required this.imageUrls,
    required this.time,
    required this.season,
    required this.description,
  });
}
