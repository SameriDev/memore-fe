import 'package:flutter/material.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/data_sources/remote/friendship_service.dart';
import '../../../domain/entities/friend.dart';
import 'friend_timeline_screen.dart';
import '../../widgets/friend_list_item.dart';
import '../../widgets/decorated_background.dart';

class FriendListDetailScreen extends StatefulWidget {
  const FriendListDetailScreen({super.key});

  @override
  State<FriendListDetailScreen> createState() => _FriendListDetailScreenState();
}

class _FriendListDetailScreenState extends State<FriendListDetailScreen> {
  List<Friend> friends = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    final userId = StorageService.instance.userId;
    if (userId == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final dtos = await FriendshipService.instance.getUserFriends(userId);
      final loaded = dtos.map((dto) => dto.toEntity(userId)).toList();
      setState(() {
        friends = loaded;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        friends = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBackground(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Friends list',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Friends List
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : friends.isEmpty
                        ? const Center(
                            child: Text(
                              'No friends yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.only(bottom: 120),
                            itemCount: friends.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final friend = friends[index];
                              return FriendListItem(
                                friend: friend,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FriendTimelineScreen(friend: friend),
                                    ),
                                  );
                                },
                                onMessageTap: () {
                                  debugPrint(
                                      'Message tapped for: ${friend.name}');
                                },
                                onMoreTap: () {
                                  debugPrint(
                                      'More tapped for: ${friend.name}');
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
