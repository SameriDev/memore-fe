import 'package:flutter/material.dart';
import '../../../data/data_sources/remote/album_service.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/models/album_dto.dart';
import '../../widgets/decorated_background.dart';

class AlbumInvitesScreen extends StatefulWidget {
  const AlbumInvitesScreen({super.key});

  @override
  State<AlbumInvitesScreen> createState() => _AlbumInvitesScreenState();
}

class _AlbumInvitesScreenState extends State<AlbumInvitesScreen> {
  List<AlbumDto> _invites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInvites();
  }

  Future<void> _loadInvites() async {
    final userId = StorageService.instance.userId;
    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }
    final invites = await AlbumService.instance.getPendingInvites(userId);
    setState(() {
      _invites = invites;
      _isLoading = false;
    });
  }

  Future<void> _acceptInvite(AlbumDto album) async {
    final userId = StorageService.instance.userId;
    if (userId == null) return;
    final result = await AlbumService.instance.acceptInvite(
      albumId: album.id,
      userId: userId,
    );
    if (result != null && mounted) {
      setState(() => _invites.removeWhere((a) => a.id == album.id));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã tham gia album "${album.name}"')),
      );
    }
  }

  Future<void> _declineInvite(AlbumDto album) async {
    final userId = StorageService.instance.userId;
    if (userId == null) return;
    final success = await AlbumService.instance.declineInvite(
      albumId: album.id,
      userId: userId,
    );
    if (success && mounted) {
      setState(() => _invites.removeWhere((a) => a.id == album.id));
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
                      child: const Icon(Icons.arrow_back,
                          color: Colors.black, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Lời mời Album',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child:
                            CircularProgressIndicator(color: Colors.brown))
                    : _invites.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.photo_album_outlined,
                                    size: 64, color: Colors.grey[400]),
                                const SizedBox(height: 12),
                                Text(
                                  'Không có lời mời nào',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.only(bottom: 120),
                            itemCount: _invites.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final album = _invites[index];
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    // Album thumbnail
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        width: 56,
                                        height: 56,
                                        color: Colors.grey[200],
                                        child: album.coverImageUrl != null &&
                                                album.coverImageUrl!
                                                    .isNotEmpty
                                            ? Image.network(
                                                album.coverImageUrl!,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) =>
                                                    const Icon(
                                                        Icons.photo_album,
                                                        color: Colors.grey),
                                              )
                                            : const Icon(Icons.photo_album,
                                                color: Colors.grey),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            album.name ?? 'Untitled',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Từ ${album.creatorName ?? 'Unknown'}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    OutlinedButton(
                                      onPressed: () =>
                                          _declineInvite(album),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.grey,
                                        side: const BorderSide(
                                            color: Colors.grey),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                      ),
                                      child: const Text('Từ chối'),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () =>
                                          _acceptInvite(album),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.brown,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                      ),
                                      child: const Text('Tham gia'),
                                    ),
                                  ],
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
