import 'package:flutter/material.dart';
import '../../../data/data_sources/remote/photo_service.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/models/photo_dto.dart';

class SelectPhotosScreen extends StatefulWidget {
  final String albumId;
  final Set<String> existingPhotoIds;

  const SelectPhotosScreen({
    super.key,
    required this.albumId,
    required this.existingPhotoIds,
  });

  @override
  State<SelectPhotosScreen> createState() => _SelectPhotosScreenState();
}

class _SelectPhotosScreenState extends State<SelectPhotosScreen> {
  List<PhotoDto> _photos = [];
  final Set<String> _selectedIds = {};
  bool _isLoading = true;
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    final userId = StorageService.instance.userId;
    if (userId == null) return;
    final photos = await PhotoService.instance.getUserPhotos(userId);
    setState(() {
      _photos = photos
          .where((p) => !widget.existingPhotoIds.contains(p.id))
          .toList();
      _isLoading = false;
    });
  }

  Future<void> _addSelectedPhotos() async {
    if (_selectedIds.isEmpty) return;
    setState(() => _isAdding = true);

    int successCount = 0;
    for (final photoId in _selectedIds) {
      final ok = await PhotoService.instance.addPhotoToAlbum(
        photoId,
        widget.albumId,
      );
      if (ok) successCount++;
    }

    if (mounted) {
      Navigator.pop(context, successCount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chọn ảnh từ Timeline'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          if (_selectedIds.isNotEmpty)
            TextButton(
              onPressed: _isAdding ? null : _addSelectedPhotos,
              child: _isAdding
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      'Thêm (${_selectedIds.length})',
                      style: const TextStyle(
                        color: Colors.brown,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.brown))
          : _photos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.photo_library_outlined,
                          size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 12),
                      Text(
                        'Không có ảnh nào để thêm',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: _photos.length,
                  itemBuilder: (context, index) {
                    final photo = _photos[index];
                    final isSelected = _selectedIds.contains(photo.id);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedIds.remove(photo.id);
                          } else {
                            _selectedIds.add(photo.id);
                          }
                        });
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              photo.filePath ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.image,
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                          if (isSelected)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.brown.withValues(alpha: 0.3),
                                border: Border.all(
                                    color: Colors.brown, width: 3),
                              ),
                            ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? Colors.brown
                                    : Colors.black.withValues(alpha: 0.3),
                                border: Border.all(
                                    color: Colors.white, width: 2),
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check,
                                      color: Colors.white, size: 14)
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
