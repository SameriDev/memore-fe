import 'package:flutter/material.dart';
import '../../../data/mock/mock_friends_data.dart';
import '../../../domain/entities/friend.dart';
import 'friend_list_detail_screen.dart';
import 'friend_timeline_screen.dart';
import 'add_friend_screen.dart';
import 'widgets/search_friends_bar.dart';
import 'widgets/social_integration_section.dart';
import 'widgets/friend_grid_item.dart';
import 'widgets/share_link_section.dart';
import '../../widgets/decorated_background.dart';
import '../../routes/custom_route_transitions.dart';

class FriendsListScreen extends StatefulWidget {
  const FriendsListScreen({super.key});

  @override
  State<FriendsListScreen> createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  late List<Friend> friends;
  late List<Friend> displayedFriends;
  List<Friend> filteredFriends = [];
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    friends = MockFriendsData.getMockFriends();
    displayedFriends = friends.take(6).toList();
    filteredFriends = friends;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        isSearching = false;
        filteredFriends = friends;
        displayedFriends = friends.take(6).toList();
      } else {
        isSearching = true;
        filteredFriends = friends.where((friend) {
          return friend.name.toLowerCase().contains(query);
        }).toList();
        displayedFriends = filteredFriends.take(12).toList(); // Show more when searching
      }
    });
  }

  void _onSearchTap() {
    // Focus on search field
    FocusScope.of(context).requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToDetailList() {
    context.pushSlideRight(const FriendListDetailScreen());
  }

  void _navigateToAddFriend() {
    context.pushSlideBottom(const AddFriendScreen());
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBackground(
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: 120,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header "Friends"
              const Text(
                'Friends',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              // 2. Search Bar
              SearchFriendsBar(
                controller: _searchController,
                onSearchTap: _onSearchTap,
                onAddFriendTap: _navigateToAddFriend,
              ),
              const SizedBox(height: 20),

              // 3. Social Integration Section
              SocialIntegrationSection(
                onMessengerTap: () => debugPrint('Messenger tapped'),
                onInstagramTap: () => debugPrint('Instagram tapped'),
                onFacebookTap: () => debugPrint('Facebook tapped'),
                onLinkTap: () => debugPrint('Link tapped'),
              ),
              const SizedBox(height: 24),

              // 4. Friend List Header
              Row(
                children: [
                  Transform.translate(
                    offset: const Offset(0, -7),
                    child: const Icon(Icons.people, size: 26),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Friend list',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${friends.length} Friends',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF797878),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _navigateToDetailList,
                    child: const Text(
                      'View all >',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 5. Friend Grid (3 columns x 2 rows)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 0, // Reduced to bring rows closer
                  childAspectRatio:
                      0.90, // Increased to make items shorter vertically
                ),
                itemCount: displayedFriends.length,
                itemBuilder: (context, index) {
                  final friend = displayedFriends[index];
                  return FriendGridItem(
                    friend: friend,
                    onTap: () {
                      context.pushFade(FriendTimelineScreen(friend: friend));
                    },
                  );
                },
              ),
              const SizedBox(height: 24),

              // 6. Share Link Section
              ShareLinkSection(
                memoreLink: 'Memorefm000000.com',
                onCopyTap: () {
                  debugPrint('Copy link tapped');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
