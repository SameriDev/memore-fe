import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/data_sources/remote/album_service.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/models/photo_dto.dart';
import '../../widgets/decorated_background.dart';
import '../../widgets/optimized_cached_image.dart';

/// Screen to select exactly 3 photos as Album Preview Grid images.
/// Returns [true] on success.
class SelectPreviewPhotosScreen extends StatefulWidget {
  final String albumId;
  final List<PhotoDto> albumPhotos;

  const SelectPreviewPhotosScreen({
    super.key,
    required this.albumId,
    required this.albumPhotos,
  });

  @override
  State<SelectPreviewPhotosScreen> createState() =>
      _SelectPreviewPhotosScreenState();
}

class _SelectPreviewPhotosScreenState
    extends State<SelectPreviewPhotosScreen> {
  final List<String> _selectedIds = [];

  String? get _currentUserId => StorageService.instance.userId;

  bool _isSelected(String id) => _selectedIds.contains(id);

  void _togglePhoto(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else if (_selectedIds.length < 3) {
        _selectedIds.add(id);
      }
    });
  }

  Future<void> _save() async {
    if (_selectedIds.length != 3 || _currentUserId == null) return;

    final result = await AlbumService.instance.updatePreviewImages(
      albumId: widget.albumId,
      photoIds: _selectedIds,
      requesterId: _currentUserId!,
    );

    if (!mounted) return;
    if (result != null) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật preview thất bại')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DecoratedBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 30,
                  bottom: 8,
                ),
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
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Chọn 3 ảnh preview',
                        style: GoogleFonts.inika(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      '${_selectedIds.length}/3',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _selectedIds.length == 3
                            ? Colors.brown
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Chọn đúng 3 ảnh để hiển thị trong lưới preview album',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 12),
              // Photo grid
              Expanded(
                child: widget.albumPhotos.isEmpty
                    ? Center(
                        child: Text(
                          'Album chưa có ảnh',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemCount: widget.albumPhotos.length,
                        itemBuilder: (context, index) {
                          final photo = widget.albumPhotos[index];
                          final id = photo.id;
                          final url = photo.filePath ?? '';
                          final selected = _isSelected(id);
                          final selectionOrder =
                              _selectedIds.indexOf(id) + 1;

                          return GestureDetector(
                            onTap: () => _togglePhoto(id),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: url.isEmpty
                                      ? Container(color: Colors.grey[200])
                                      : OptimizedCachedImage.timeline(
                                          imageUrl: url,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                ),
                                if (selected)
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.brown.withOpacity(0.4),
                                    ),
                                  ),
                                if (selected)
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(
                                        color: Colors.brown,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '$selectionOrder',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (!selected &&
                                    _selectedIds.length == 3)
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              // Save button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedIds.length == 3 ? _save : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      disabledBackgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Lưu preview',
                      style: GoogleFonts.inika(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
