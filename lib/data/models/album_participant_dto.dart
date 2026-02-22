class AlbumParticipantDto {
  final String id;
  final String albumId;
  final String userId;
  final String? userName;
  final String? userAvatarUrl;
  final String status;
  final String? joinedAt;

  AlbumParticipantDto({
    required this.id,
    required this.albumId,
    required this.userId,
    this.userName,
    this.userAvatarUrl,
    required this.status,
    this.joinedAt,
  });

  factory AlbumParticipantDto.fromJson(Map<String, dynamic> json) {
    return AlbumParticipantDto(
      id: json['id'].toString(),
      albumId: json['albumId'].toString(),
      userId: json['userId'].toString(),
      userName: json['userName'] as String?,
      userAvatarUrl: json['userAvatarUrl'] as String?,
      status: json['status'] as String? ?? 'PENDING',
      joinedAt: json['joinedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'albumId': albumId,
      'userId': userId,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'status': status,
      'joinedAt': joinedAt,
    };
  }
}
