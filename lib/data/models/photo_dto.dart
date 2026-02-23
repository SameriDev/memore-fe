class PhotoDto {
  final String id;
  final String? ownerId;
  final String? ownerName;
  final String? albumId;
  final String? albumName;
  final String? filePath;
  final String? thumbnailPath;
  final String? s3Key;
  final String? s3ThumbnailKey;
  final String? caption;
  final String? note;
  final String? location;
  final List<String>? tags;
  final String? quality;
  final String? source;
  final int? fileSize;
  final String? season;
  final int likeCount;
  final int commentCount;
  final bool isShared;
  final String? createdAt;
  final String? updatedAt;

  PhotoDto({
    required this.id,
    this.ownerId,
    this.ownerName,
    this.albumId,
    this.albumName,
    this.filePath,
    this.thumbnailPath,
    this.s3Key,
    this.s3ThumbnailKey,
    this.caption,
    this.note,
    this.location,
    this.tags,
    this.quality,
    this.source,
    this.fileSize,
    this.season,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isShared = false,
    this.createdAt,
    this.updatedAt,
  });

  factory PhotoDto.fromJson(Map<String, dynamic> json) {
    return PhotoDto(
      id: json['id'].toString(),
      ownerId: json['ownerId']?.toString(),
      ownerName: json['ownerName'] as String?,
      albumId: json['albumId']?.toString(),
      albumName: json['albumName'] as String?,
      filePath: json['filePath'] as String?,
      thumbnailPath: json['thumbnailPath'] as String?,
      s3Key: json['s3Key'] as String?,
      s3ThumbnailKey: json['s3ThumbnailKey'] as String?,
      caption: json['caption'] as String?,
      note: json['note'] as String?,
      location: json['location'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      quality: json['quality'] as String?,
      source: json['source'] as String?,
      fileSize: json['fileSize'] as int?,
      season: json['season'] as String?,
      likeCount: json['likeCount'] as int? ?? 0,
      commentCount: json['commentCount'] as int? ?? 0,
      isShared: json['isShared'] as bool? ?? false,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'albumId': albumId,
      'albumName': albumName,
      'filePath': filePath,
      'thumbnailPath': thumbnailPath,
      's3Key': s3Key,
      's3ThumbnailKey': s3ThumbnailKey,
      'caption': caption,
      'note': note,
      'location': location,
      'tags': tags,
      'quality': quality,
      'source': source,
      'fileSize': fileSize,
      'season': season,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'isShared': isShared,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
