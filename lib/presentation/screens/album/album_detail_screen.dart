import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memore/core/utils/snackbar_helper.dart';
import 'package:memore/core/utils/show_app_popup.dart';
import '../../../presentation/widgets/app_popup.dart';
import '../../../data/data_sources/remote/album_service.dart';
import '../../../data/data_sources/remote/photo_service.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/models/album_dto.dart';
import '../../../data/models/album_participant_dto.dart';
import '../../../data/models/photo_dto.dart';
import '../../widgets/decorated_background.dart';
import 'select_photos_screen.dart';

class AlbumDetailScreen extends StatefulWidget {
  final String albumId;

  const AlbumDetailScreen({super.key, required this.albumId});

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  AlbumDto? _album;
  List<PhotoDto> _photos = [];
  bool _isLoading = true;

  String? get _currentUserId => StorageService.instance.userId;

  bool get _isCreator => _album?.creatorId == _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final results = await Future.wait([
      AlbumService.instance.getAlbumById(widget.albumId),
      PhotoService.instance.getAlbumPhotos(widget.albumId),
    ]);
    setState(() {
      _album = results[0] as AlbumDto?;
      _photos = (results[1] as List<PhotoDto>?) ?? [];
      _isLoading = false;
    });
  }

  Future<void> _leaveAlbum() async {
    if (_currentUserId == null) return;
    final success = await AlbumService.instance.leaveAlbum(
      albumId: widget.albumId,
      userId: _currentUserId!,
    );
    if (success && mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _deleteAlbum() async {
    // Show confirmation
    final confirm = await showAppPopup<bool>(
      context: context,
      builder: (ctx) => AppPopup(
        size: AppPopupSize.small,
        title: 'Xóa album',
        content: Text(
          'Bạn có chắc muốn xóa album này?',
          style: GoogleFonts.inika(color: const Color(0xFF3E2723)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Hủy', style: GoogleFonts.inika(color: const Color(0xFF8B4513))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Xóa', style: GoogleFonts.inika(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    final success = await AlbumService.instance.deleteAlbum(widget.albumId);
    if (!success && mounted) {
      SnackBarHelper.showError(context, 'Xóa album thất bại');
      return;
    }
    if (mounted) Navigator.pop(context, true);
  }

  Future<void> _openSelectPhotos() async {
    final existingIds = _photos.map((p) => p.id).toSet();
    final result = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) => SelectPhotosScreen(
          albumId: widget.albumId,
          existingPhotoIds: existingIds,
        ),
      ),
    );
    if (result != null && result > 0) {
      _loadData();
    }
  }

  void _showMembersSheet() {
    final participants = _album?.participants ?? [];
    showAppPopup(
      context: context,
      builder: (ctx) => AppPopup(
        size: AppPopupSize.medium,
        title: 'Thành viên (${participants.where((p) => p.status == 'ACCEPTED').length})',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...participants
                .where((p) => p.status == 'ACCEPTED')
                .map((p) => _buildMemberTile(p)),
            if (participants.any((p) => p.status == 'PENDING')) ...[
              const SizedBox(height: 12),
              Text(
                'Đang chờ',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500),
              ),
              ...participants
                  .where((p) => p.status == 'PENDING')
                  .map((p) => _buildMemberTile(p, isPending: true)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMemberTile(AlbumParticipantDto p, {bool isPending = false}) {
    final isOwner = p.userId == _album?.creatorId;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundImage: p.userAvatarUrl != null && p.userAvatarUrl!.isNotEmpty
            ? NetworkImage(p.userAvatarUrl!)
            : null,
        child: p.userAvatarUrl == null || p.userAvatarUrl!.isEmpty
            ? Text(p.userName?.isNotEmpty == true ? p.userName![0] : '?')
            : null,
      ),
      title: Text(p.userName ?? 'Unknown'),
      subtitle: isOwner
          ? const Text('Creator', style: TextStyle(color: Colors.brown))
          : isPending
              ? const Text('Đang chờ', style: TextStyle(color: Colors.orange))
              : null,
      trailing: _isCreator && !isOwner && !isPending
          ? IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: () async {
                final confirm = await showAppPopup<bool>(
                  context: context,
                  builder: (ctx) => AppPopup(
                    size: AppPopupSize.small,
                    title: 'Xóa thành viên',
                    content: Text(
                      'Bạn có chắc muốn xóa ${p.userName ?? 'thành viên này'} khỏi album?',
                      style: GoogleFonts.inika(color: const Color(0xFF3E2723)),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text('Hủy', style: GoogleFonts.inika(color: const Color(0xFF8B4513))),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text('Xóa', style: GoogleFonts.inika(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                if (confirm != true) return;
                await AlbumService.instance.kickMember(
                  albumId: widget.albumId,
                  userId: p.userId,
                  requesterId: _currentUserId!,
                );
                if (mounted) Navigator.pop(context);
                _loadData();
              },
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: _album != null
          ? FloatingActionButton(
              onPressed: _openSelectPhotos,
              backgroundColor: Colors.brown,
              child: const Icon(Icons.add_photo_alternate, color: Colors.white),
            )
          : null,
      body: DecoratedBackground(
      child: SafeArea(
        bottom: false,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.brown))
            : _album == null
                ? const Center(child: Text('Album không tồn tại'))
                : Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 30),
                        child: Row(
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
                                child: const Icon(Icons.arrow_back,
                                    color: Colors.black, size: 20),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _album!.name ?? 'Untitled',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Members button
                            GestureDetector(
                              onTap: _showMembersSheet,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.people,
                                        size: 18, color: Colors.brown),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${_album!.participants.where((p) => p.status == 'ACCEPTED').length}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Menu
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert),
                              onSelected: (value) {
                                if (value == 'leave') _leaveAlbum();
                                if (value == 'delete') _deleteAlbum();
                              },
                              itemBuilder: (ctx) => [
                                if (!_isCreator)
                                  const PopupMenuItem(
                                    value: 'leave',
                                    child: Text('Rời album'),
                                  ),
                                if (_isCreator)
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Xóa album',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Description
                      if (_album!.description != null &&
                          _album!.description!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            _album!.description!,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600]),
                          ),
                        ),
                      // Participant avatars row
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: Row(
                          children: [
                            ..._album!.participants
                                .where((p) => p.status == 'ACCEPTED')
                                .take(5)
                                .map((p) => Padding(
                                      padding:
                                          const EdgeInsets.only(right: 4),
                                      child: CircleAvatar(
                                        radius: 14,
                                        backgroundImage: p.userAvatarUrl !=
                                                    null &&
                                                p.userAvatarUrl!.isNotEmpty
                                            ? NetworkImage(
                                                p.userAvatarUrl!)
                                            : null,
                                        child: p.userAvatarUrl == null ||
                                                p.userAvatarUrl!.isEmpty
                                            ? Text(
                                                p.userName?.isNotEmpty ==
                                                        true
                                                    ? p.userName![0]
                                                    : '?',
                                                style: const TextStyle(
                                                    fontSize: 10))
                                            : null,
                                      ),
                                    )),
                            Text(
                              '${_album!.filesCount} ảnh',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Photo grid
                      Expanded(
                        child: _photos.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.photo_library_outlined,
                                        size: 64, color: Colors.grey[400]),
                                    const SizedBox(height: 12),
                                    Text('Chưa có ảnh nào',
                                        style: TextStyle(
                                            color: Colors.grey[600])),
                                  ],
                                ),
                              )
                            : GridView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                ),
                                itemCount: _photos.length,
                                itemBuilder: (context, index) {
                                  final photo = _photos[index];
                                  final url = photo.filePath ?? '';
                                  return ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(8),
                                    child: Image.network(
                                      url,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          Container(
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.image,
                                            color: Colors.grey),
                                      ),
                                    ),
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
