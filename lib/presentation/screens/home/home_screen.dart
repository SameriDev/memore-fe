import 'package:flutter/material.dart';
import '../../../data/mock/mock_albums_data.dart';
import '../../../domain/entities/album.dart';
import '../../../domain/entities/story.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../widgets/story_section.dart';
import '../../widgets/album_header.dart';
import '../../widgets/filter_section.dart';
import '../../widgets/album_card.dart';
import '../../widgets/bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Story> stories;
  late List<Album> albums;
  List<String> activeFilters = ['Shared', 'Recent'];
  int currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    stories = MockAlbumsData.getMockStories();
    albums = MockAlbumsData.getMockAlbums();
  }

  void _handleRemoveFilter(String filter) {
    setState(() {
      activeFilters.remove(filter);
    });
  }

  void _handleAlbumFavorite(Album album) {
    setState(() {
      final index = albums.indexWhere((a) => a.id == album.id);
      if (index != -1) {
        albums[index] = Album(
          id: album.id,
          name: album.name,
          coverImageUrl: album.coverImageUrl,
          filesCount: album.filesCount,
          timeAgo: album.timeAgo,
          participantAvatars: album.participantAvatars,
          additionalParticipants: album.additionalParticipants,
          isFavorite: !album.isFavorite,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const SizedBox(height: 8),
                StorySection(
                  stories: stories,
                  onAddStory: () {
                    debugPrint('Add story tapped');
                  },
                  onStoryTap: (story) {
                    debugPrint('Story tapped: ${story.userName}');
                  },
                ),
                const SizedBox(height: 8),
                AlbumHeader(
                  onSearchTap: () {
                    debugPrint('Search tapped');
                  },
                  onAddTap: () {
                    debugPrint('Add album tapped');
                  },
                ),
                FilterSection(
                  activeFilters: activeFilters,
                  onFilterTap: () {
                    debugPrint('Filter tapped');
                  },
                  onRemoveFilter: _handleRemoveFilter,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(
                      left: AppDimensions.horizontalPadding,
                      right: AppDimensions.horizontalPadding,
                      bottom: 140,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: AppDimensions.gridSpacing,
                          mainAxisSpacing: AppDimensions.gridSpacing,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: albums.length,
                    itemBuilder: (context, index) {
                      final album = albums[index];
                      return AlbumCard(
                        album: album,
                        onTap: () {
                          debugPrint('Album tapped: ${album.name}');
                        },
                        onFavoriteTap: () {
                          _handleAlbumFavorite(album);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomNavigation(
              currentIndex: currentNavIndex,
              onTap: (index) {
                setState(() {
                  currentNavIndex = index;
                });
                debugPrint('Nav tapped: $index');
              },
            ),
          ),
        ],
      ),
    );
  }
}
