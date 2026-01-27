class Album {
  final String id;
  final String name;
  final String coverImageUrl;
  final int filesCount;
  final String timeAgo;
  final List<String> participantAvatars;
  final int additionalParticipants;
  final bool isFavorite;

  Album({
    required this.id,
    required this.name,
    required this.coverImageUrl,
    required this.filesCount,
    required this.timeAgo,
    required this.participantAvatars,
    this.additionalParticipants = 0,
    this.isFavorite = false,
  });
}
