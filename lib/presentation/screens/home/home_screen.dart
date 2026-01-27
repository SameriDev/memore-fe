import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../data/mock/mock_albums_data.dart';
import '../../../domain/entities/album.dart';
import '../../../domain/entities/story.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../widgets/story_section.dart';
import '../../widgets/album_header.dart';
import '../../widgets/filter_section.dart';
import '../../widgets/album_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Story> stories;
  late List<Album> albums;
  List<String> activeFilters = ['Shared', 'Recent'];

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
                StorySection(
                  stories: stories,
                  onAddStory: () {
                    debugPrint('Add story tapped');
                  },
                  onStoryTap: (story) {
                    debugPrint('Story tapped: ${story.userName}');
                  },
                  onMoreTap: () {
                    debugPrint('More stories tapped');
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
                  child: MasonryGridView.count(
                    padding: const EdgeInsets.only(
                      left: AppDimensions.horizontalPadding,
                      right: AppDimensions.horizontalPadding,
                      bottom: 140,
                    ),
                    crossAxisCount: 2,
                    mainAxisSpacing: AppDimensions.gridSpacing,
                    crossAxisSpacing: AppDimensions.gridSpacing,
                    itemCount: albums.length,
                    itemBuilder: (context, index) {
                      final album = albums[index];
                      final aspectRatios = [
                        0.9,
                        1.1,
                        1.0,
                        1.2,
                        0.95,
                        1.05,
                        0.85,
                        1.15,
                      ];
                      final aspectRatio =
                          aspectRatios[index % aspectRatios.length];

                      return AlbumCard(
                        album: album,
                        aspectRatio: aspectRatio,
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
        ],
      ),
    );
  }
}
