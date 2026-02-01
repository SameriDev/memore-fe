import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../data/mock/mock_albums_data.dart';
import '../../../data/mock/mock_user_profile.dart';
import '../../../data/local/photo_storage_manager.dart';
import '../../../data/local/user_manager.dart';
import '../../../domain/entities/album.dart';
import '../../../domain/entities/story.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../widgets/story_section.dart';
import '../../widgets/album_header.dart';
import '../../widgets/filter_section.dart';
import '../../widgets/album_card.dart';
import '../../widgets/decorated_background.dart';
import '../recent_photos_viewer/recent_photos_viewer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Story> stories;
  late List<Album> albums;
  List<Map<String, dynamic>> localPhotos = [];
  List<String> activeFilters = ['Shared', 'Recent'];
  bool isLoadingPhotos = false;

  @override
  void initState() {
    super.initState();
    stories = MockAlbumsData.getMockStories();
    albums = MockAlbumsData.getMockAlbums();
    _loadLocalPhotos();
  }

  Future<void> _loadLocalPhotos() async {
    setState(() => isLoadingPhotos = true);

    try {
      final photos = PhotoStorageManager.instance.getUserPhotos();

      // Transform photos to expected format for HomeScreen
      final transformedPhotos = photos.map((photo) {
        final timestamp = photo['timestamp'] as int;
        final date = DateTime.fromMillisecondsSinceEpoch(timestamp);

        return {
          'id': photo['id'],
          'filePath': photo['storagePath'],
          'caption': photo['caption'] ?? '',
          'timestamp': timestamp,
          'dateString': '${date.day}/${date.month}/${date.year}',
          'isLiked': photo['isLiked'] ?? false,
          'source': 'camera',
        };
      }).toList();

      setState(() {
        localPhotos = transformedPhotos;
      });

      // Update user stats
      final user = UserManager.instance.getCurrentUser();
      if (user != null) {
        await UserManager.instance.updateProfile({
          'photosCount': photos.length,
        });
      }
    } catch (e) {
      debugPrint('Error loading local photos: $e');
    } finally {
      setState(() => isLoadingPhotos = false);
    }
  }

  void _refreshPhotos() {
    _loadLocalPhotos();
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

  void _openRecentPhotos(Story story) {
    // Lấy user ID từ story (giả sử story có userId)
    final userId = story.userId;

    // Lấy danh sách ảnh gần đây của user này
    final photos = MockUserProfile.getRecentPhotos(userId);

    // Navigate đến recent photos viewer
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecentPhotosViewerScreen(
          userId: userId,
          initialIndex: 0, // Bắt đầu từ ảnh đầu tiên
          photos: photos,
          userName: story.userName,
          userAvatar: story.userAvatar,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBackground(
      backgroundColor: const Color(0xFFF5F1EB),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            StorySection(
              stories: stories,
              onAddStory: () {
                debugPrint('Add story tapped');
              },
              onStoryTap: (story) {
                _openRecentPhotos(story);
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
    );
  }
}
