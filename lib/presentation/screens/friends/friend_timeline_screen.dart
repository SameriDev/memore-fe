import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memore/core/utils/show_app_popup.dart';
import '../../widgets/app_popup.dart';
import '../../../data/data_sources/remote/photo_service.dart';
import '../../../data/data_sources/remote/user_service.dart';
import '../../../data/models/photo_dto.dart';
import '../../../data/models/user_dto.dart';
import '../../../domain/entities/friend.dart';
import '../../../domain/entities/timeline_photo.dart';
import 'widgets/timeline_header.dart';
import 'widgets/timeline_photo_card.dart';
import 'widgets/timeline_background_decoration.dart';

class FriendTimelineScreen extends StatefulWidget {
  final Friend friend;

  const FriendTimelineScreen({super.key, required this.friend});

  @override
  State<FriendTimelineScreen> createState() => _FriendTimelineScreenState();
}

class _FriendTimelineScreenState extends State<FriendTimelineScreen> {
  List<TimelinePhoto> timelinePhotos = [];
  bool isLoading = true;
  UserDto? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final user = await UserService.instance.getUserById(widget.friend.id);
      setState(() => _userProfile = user);
    } catch (e) {
      debugPrint('Load user profile error: $e');
    }
  }

  Future<void> _loadPhotos() async {
    try {
      final photoDtos =
          await PhotoService.instance.getUserPhotos(widget.friend.id);
      final photos = <TimelinePhoto>[];

      for (final dto in photoDtos) {
        final imageUrl = await _getImageUrl(dto);
        if (imageUrl == null) continue;

        photos.add(TimelinePhoto(
          id: dto.id,
          imageUrls: [imageUrl],
          time: _formatTime(dto.createdAt),
          season: dto.season ?? 'Unknown',
          description: dto.caption ?? '',
        ));
      }

      setState(() {
        timelinePhotos = photos;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Load timeline photos error: $e');
      setState(() => isLoading = false);
    }
  }

  Future<String?> _getImageUrl(PhotoDto dto) async {
    if (dto.s3Key != null) {
      return PhotoService.instance.getPresignedUrl(dto.s3Key!);
    }
    return null;
  }

  String _formatTime(String? createdAt) {
    if (createdAt == null) return '';
    try {
      final dt = DateTime.parse(createdAt);
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }

  void _onMenuTap() {
    showAppPopup(
      context: context,
      builder: (ctx) => AppPopup(
        size: AppPopupSize.small,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.block),
              title: Text('Chặn người dùng', style: GoogleFonts.inika()),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: Text('Báo cáo', style: GoogleFonts.inika()),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Icon(Icons.chevron_left, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          const TimelineBackgroundDecoration(),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : timelinePhotos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TimelineHeader(
                            name: _userProfile?.name ?? widget.friend.name,
                            avatarUrl: _userProfile?.avatarUrl ?? widget.friend.avatarUrl,
                            isOnline: _userProfile?.isOnline ?? widget.friend.isOnline,
                            onMenuTap: _onMenuTap,
                            username: _userProfile?.username,
                            friendsCount: _userProfile?.friendsCount,
                            imagesCount: _userProfile?.imagesCount,
                          ),
                          const SizedBox(height: 60),
                          const Icon(Icons.photo_library_outlined,
                              size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text(
                            'No photos yet',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          TimelineHeader(
                            name: _userProfile?.name ?? widget.friend.name,
                            avatarUrl: _userProfile?.avatarUrl ?? widget.friend.avatarUrl,
                            isOnline: _userProfile?.isOnline ?? widget.friend.isOnline,
                            onMenuTap: _onMenuTap,
                            username: _userProfile?.username,
                            friendsCount: _userProfile?.friendsCount,
                            imagesCount: _userProfile?.imagesCount,
                          ),
                          const SizedBox(height: 20),
                          ...timelinePhotos.asMap().entries.map((entry) {
                            return TimelinePhotoCard(
                              photo: entry.value,
                              index: entry.key,
                            );
                          }),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
          Positioned(
            right: 29,
            top: -500,
            height: 2000,
            child: Container(width: 2, color: const Color(0xFF464646)),
          ),
        ],
      ),
    );
  }
}
