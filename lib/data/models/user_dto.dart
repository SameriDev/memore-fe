class UserDto {
  final String id;
  final String name;
  final String username;
  final String email;
  final String? avatarUrl;
  final String? birthday;
  final String? badgeLevel;
  final int? streakCount;
  final int? friendsCount;
  final int? imagesCount;
  final String? createdAt;
  final String? updatedAt;
  final String? lastActive;
  final bool? isOnline;

  UserDto({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.birthday,
    this.badgeLevel,
    this.streakCount,
    this.friendsCount,
    this.imagesCount,
    this.createdAt,
    this.updatedAt,
    this.lastActive,
    this.isOnline,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'].toString(),
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      birthday: json['birthday']?.toString(),
      badgeLevel: json['badgeLevel'] as String?,
      streakCount: json['streakCount'] as int?,
      friendsCount: json['friendsCount'] as int?,
      imagesCount: json['imagesCount'] as int?,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      lastActive: json['lastActive']?.toString(),
      isOnline: json['isOnline'] as bool?,
    );
  }

  Map<String, dynamic> toStorageMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'avatarUrl': avatarUrl ?? '',
      'bio': '',
      'friendsCount': friendsCount ?? 0,
      'photosCount': imagesCount ?? 0,
      'joinedDate': createdAt ?? DateTime.now().toIso8601String(),
      'isOnline': isOnline ?? true,
      'lastActiveTime': lastActive ?? DateTime.now().toIso8601String(),
    };
  }
}
