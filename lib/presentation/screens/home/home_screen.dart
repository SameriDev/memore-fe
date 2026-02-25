import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../data/local/photo_storage_manager.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/local/user_manager.dart';
import '../../../data/data_sources/remote/photo_service.dart';
import '../../../data/data_sources/remote/album_service.dart';
import '../../../data/data_sources/remote/story_service.dart';
import '../../../data/models/photo_dto.dart';
import '../../../domain/entities/album.dart';
import '../../../domain/entities/story.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../widgets/story_section.dart';
import '../../widgets/album_header.dart';
import '../../widgets/filter_section.dart';
import '../../widgets/album_card.dart';
import '../../widgets/decorated_background.dart';
import '../album/create_album_screen.dart';
import '../album/album_detail_screen.dart';
import '../album/album_invites_screen.dart';
import '../story/story_viewer_screen.dart';
import '../story/create_story_screen.dart';
import '../../../data/models/story_dto.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Story> stories = [];
  List<StoryDto> _allStoryDtos = [];
  List<Album> albums = [];
  List<Map<String, dynamic>> localPhotos = [];
  List<PhotoDto> remotePhotos = [];
  bool isRemoteSource = false;
  List<String> activeFilters = ['Shared', 'Recent'];
  bool isLoadingPhotos = false;
  int _pendingInviteCount = 0;

  @override
  void initState() {
    super.initState();
    _loadStoriesAndAlbums();
    _loadLocalPhotos();
    _loadPendingInvites();
  }

  Future<void> _loadStoriesAndAlbums() async {
    final userId = StorageService.instance.userId;
    if (userId == null) return;

    try {
      final results = await Future.wait([
        StoryService.instance.getFriendsStories(userId),
        AlbumService.instance.getUserAlbums(userId),
      ]);

      final storyDtos = results[0] as List<StoryDto>;
      final albumDtos = results[1] as List;

      // Group stories by user - show one avatar per user
      final Map<String, List<StoryDto>> grouped = {};
      for (final dto in storyDtos) {
        final uid = dto.userId ?? '';
        grouped.putIfAbsent(uid, () => []);
        grouped[uid]!.add(dto);
      }

      final addStory = Story(
        id: 'add',
        userId: userId,
        userAvatar: '',
        userName: 'Add',
        isAddButton: true,
      );

      final groupedStories = grouped.entries.map((entry) {
        final first = entry.value.first;
        return first.toEntity();
      }).toList();

      setState(() {
        _allStoryDtos = storyDtos;
        stories = [addStory, ...groupedStories];
        albums = albumDtos.map((dto) => (dto as dynamic).toEntity() as Album).toList();
      });
    } catch (e) {
      debugPrint('Load stories/albums error: $e');
      setState(() {
        stories = [];
        albums = [];
      });
    }
  }

  Future<void> _loadLocalPhotos() async {
    setState(() => isLoadingPhotos = true);

    try {
      // Remote-first: try fetching from server
      final userId = StorageService.instance.userId;
      if (userId != null) {
        try {
          final remote = await PhotoService.instance.getUserPhotos(userId);
          if (remote.isNotEmpty) {
            setState(() {
              remotePhotos = remote;
              isRemoteSource = true;
            });

            await UserManager.instance.updateProfile({
              'photosCount': remote.length,
            });

            setState(() => isLoadingPhotos = false);
            return;
          }
        } catch (e) {
          debugPrint('Remote photos fetch failed, falling back to local: $e');
        }
      }

      // Fallback: load from local storage
      final photos = PhotoStorageManager.instance.getUserPhotos();

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
        isRemoteSource = false;
      });

      final user = UserManager.instance.getCurrentUser();
      if (user != null) {
        await UserManager.instance.updateProfile({
          'photosCount': photos.length,
        });
      }
    } catch (e) {
      debugPrint('Error loading photos: $e');
    } finally {
      setState(() => isLoadingPhotos = false);
    }
  }

  Future<void> _loadPendingInvites() async {
    final userId = StorageService.instance.userId;
    if (userId == null) return;
    final invites = await AlbumService.instance.getPendingInvites(userId);
    if (mounted) {
      setState(() => _pendingInviteCount = invites.length);
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

  void _openStoryViewer(Story story) {
    // Get all stories for this user
    final userStories = _allStoryDtos
        .where((dto) => dto.userId == story.userId)
        .map((dto) => dto.toEntity())
        .toList();

    if (userStories.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryViewerScreen(
          stories: userStories,
          initialIndex: 0,
        ),
      ),
    );
  }

  Future<void> _openCreateStory() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateStoryScreen()),
    );
    if (result == true) _loadStoriesAndAlbums();
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
              onAddStory: _openCreateStory,
              onStoryTap: (story) {
                _openStoryViewer(story);
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
              onAddTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateAlbumScreen(),
                  ),
                );
                if (result == true) _loadStoriesAndAlbums();
              },
              pendingInviteCount: _pendingInviteCount,
              onInvitesTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AlbumInvitesScreen(),
                  ),
                );
                _loadStoriesAndAlbums();
                _loadPendingInvites();
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
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AlbumDetailScreen(albumId: album.id),
                        ),
                      );
                      if (result == true) _loadStoriesAndAlbums();
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
