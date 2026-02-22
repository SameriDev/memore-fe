import '../../domain/entities/friend.dart';

class FriendshipDto {
  final String id;
  final String? userId;
  final String? userName;
  final String? friendId;
  final String? friendName;
  final String? status;
  final String? createdAt;

  FriendshipDto({
    required this.id,
    this.userId,
    this.userName,
    this.friendId,
    this.friendName,
    this.status,
    this.createdAt,
  });

  factory FriendshipDto.fromJson(Map<String, dynamic> json) {
    return FriendshipDto(
      id: json['id'].toString(),
      userId: json['userId']?.toString(),
      userName: json['userName'] as String?,
      friendId: json['friendId']?.toString(),
      friendName: json['friendName'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'friendId': friendId,
      'friendName': friendName,
      'status': status,
      'createdAt': createdAt,
    };
  }

  Friend toEntity(String currentUserId) {
    final isCurrentUser = userId == currentUserId;
    final otherId = isCurrentUser ? friendId : userId;
    final otherName = isCurrentUser ? friendName : userName;

    return Friend(
      id: otherId ?? id,
      name: otherName ?? 'Unknown',
      avatarUrl: 'https://i.pravatar.cc/150?u=$otherId',
      isOnline: false,
      lastActiveTime: createdAt ?? '',
    );
  }
}
