import '../../domain/entities/album.dart';
import 'album_participant_dto.dart';

class AlbumDto {
  final String id;
  final String? name;
  final String? description;
  final String? coverImageUrl;
  final String? creatorId;
  final String? creatorName;
  final int filesCount;
  final bool isFavorite;
  final String? createdAt;
  final String? updatedAt;
  final List<AlbumParticipantDto> participants;

  AlbumDto({
    required this.id,
    this.name,
    this.description,
    this.coverImageUrl,
    this.creatorId,
    this.creatorName,
    this.filesCount = 0,
    this.isFavorite = false,
    this.createdAt,
    this.updatedAt,
    this.participants = const [],
  });

  factory AlbumDto.fromJson(Map<String, dynamic> json) {
    return AlbumDto(
      id: json['id'].toString(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      creatorId: json['creatorId']?.toString(),
      creatorName: json['creatorName'] as String?,
      filesCount: json['filesCount'] as int? ?? 0,
      isFavorite: json['isFavorite'] as bool? ?? false,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      participants: (json['participants'] as List<dynamic>?)
              ?.map((p) => AlbumParticipantDto.fromJson(p))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'coverImageUrl': coverImageUrl,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'filesCount': filesCount,
      'isFavorite': isFavorite,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Album toEntity() {
    final created = DateTime.tryParse(createdAt ?? '');
    String timeAgo = '';
    if (created != null) {
      final diff = DateTime.now().difference(created);
      if (diff.inDays > 365) {
        timeAgo = '${diff.inDays ~/ 365}y ago';
      } else if (diff.inDays > 30) {
        timeAgo = '${diff.inDays ~/ 30}mo ago';
      } else if (diff.inDays > 0) {
        timeAgo = '${diff.inDays}d ago';
      } else if (diff.inHours > 0) {
        timeAgo = '${diff.inHours}h ago';
      } else {
        timeAgo = 'Just now';
      }
    }

    final acceptedParticipants =
        participants.where((p) => p.status == 'ACCEPTED').toList();
    final avatars = acceptedParticipants
        .where((p) => p.userAvatarUrl != null && p.userAvatarUrl!.isNotEmpty)
        .map((p) => p.userAvatarUrl!)
        .take(3)
        .toList();
    final additionalCount =
        (acceptedParticipants.length - avatars.length).clamp(0, 999);

    return Album(
      id: id,
      name: name ?? 'Untitled',
      coverImageUrl: coverImageUrl ?? '',
      filesCount: filesCount,
      timeAgo: timeAgo,
      participantAvatars: avatars,
      additionalParticipants: additionalCount,
      isFavorite: isFavorite,
    );
  }
}
