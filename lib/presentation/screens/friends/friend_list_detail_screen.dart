import 'package:flutter/material.dart';
import '../../../data/mock/mock_friends_data.dart';
import '../../../domain/entities/friend.dart';
import 'friend_timeline_screen.dart';
import '../../widgets/friend_list_item.dart';

class FriendListDetailScreen extends StatefulWidget {
  const FriendListDetailScreen({super.key});

  @override
  State<FriendListDetailScreen> createState() => _FriendListDetailScreenState();
}

class _FriendListDetailScreenState extends State<FriendListDetailScreen> {
  late List<Friend> friends;

  @override
  void initState() {
    super.initState();
    friends = MockFriendsData.getMockFriends();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F2F0),
      body: SafeArea(
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
                child: ListView.separated(
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
                        debugPrint('Message tapped for: ${friend.name}');
                      },
                      onMoreTap: () {
                        debugPrint('More tapped for: ${friend.name}');
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
