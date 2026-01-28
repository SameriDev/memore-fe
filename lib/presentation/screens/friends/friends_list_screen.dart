import 'package:flutter/material.dart';
import '../../../data/mock/mock_friends_data.dart';
import '../../../domain/entities/friend.dart';
import '../../widgets/friend_list_item.dart';

class FriendsListScreen extends StatefulWidget {
  const FriendsListScreen({super.key});

  @override
  State<FriendsListScreen> createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
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
              // Header
              const Text(
                'Friends list',
                style: TextStyle(
                  fontFamily: 'Inika',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                ),
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
                        debugPrint('Friend tapped: ${friend.name}');
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
