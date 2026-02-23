import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memore/core/utils/snackbar_helper.dart';
import 'dart:io';
import '../../../data/local/photo_storage_manager.dart';
import '../recent_photos_viewer/recent_photos_viewer_screen.dart' show RecentPhotosViewerScreen, PhotoItem;

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<Map<String, dynamic>> _photos = [];
  bool _isLoading = true;
  String _selectedFilter = 'Tất cả';

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    setState(() => _isLoading = true);

    try {
      final photos = PhotoStorageManager.instance.getUserPhotos();

      // Transform photos to expected format and add computed fields
      final transformedPhotos = photos.map((photo) {
        final timestamp = photo['timestamp'] as int;
        final date = DateTime.fromMillisecondsSinceEpoch(timestamp);

        return {
          ...photo,
          'filePath': photo['storagePath'], // Use storagePath for filePath
          'source': 'camera', // All photos from PhotoStorageManager are camera photos
          'dateString': '${date.day}/${date.month}/${date.year}',
        };
      }).toList();

      setState(() {
        _photos = transformedPhotos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        SnackBarHelper.showError(context, 'Lỗi khi tải ảnh: $e');
      }
    }
  }

  List<Map<String, dynamic>> get _filteredPhotos {
    if (_selectedFilter == 'Tất cả') {
      return _photos;
    } else if (_selectedFilter == 'Camera') {
      return _photos.where((photo) => photo['source'] == 'camera').toList();
    } else if (_selectedFilter == 'Yêu thích') {
      return _photos.where((photo) => photo['isLiked'] == true).toList();
    }
    return _photos;
  }

  void _openPhotoViewer(int index) {
    final photos = _filteredPhotos.map((photo) => PhotoItem(
      imageUrl: 'file://${photo['filePath']}', // Add file:// prefix for local files
      uploadedAt: DateTime.fromMillisecondsSinceEpoch(photo['timestamp'] as int),
    )).toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RecentPhotosViewerScreen(
          userId: 'current_user',
          userName: 'Tôi',
          userAvatar: '',
          photos: photos,
          initialIndex: index,
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(
          label,
          style: GoogleFonts.inika(
            color: isSelected ? Colors.white : const Color(0xFF8B4513),
            fontSize: 14,
          ),
        ),
        onSelected: (selected) {
          setState(() {
            _selectedFilter = selected ? label : 'Tất cả';
          });
        },
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF8B4513),
        side: BorderSide(
          color: isSelected ? const Color(0xFF8B4513) : Colors.grey[300]!,
        ),
      ),
    );
  }

  Widget _buildPhotoCard(Map<String, dynamic> photo, int index) {
    return GestureDetector(
      onTap: () => _openPhotoViewer(index),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                File(photo['filePath']),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 40,
                    ),
                  );
                },
              ),
              // Overlay with photo info
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (photo['caption']?.isNotEmpty == true)
                        Text(
                          photo['caption'],
                          style: GoogleFonts.inika(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      Text(
                        photo['dateString'] ?? '',
                        style: GoogleFonts.inika(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Like indicator
              if (photo['isLiked'] == true)
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        title: Text(
          'Thư viện ảnh',
          style: GoogleFonts.inika(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF3E2723),
          ),
        ),
        backgroundColor: const Color(0xFFF5F5DC),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF3E2723)),
        actions: [
          IconButton(
            onPressed: _loadPhotos,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Tất cả'),
                  _buildFilterChip('Camera'),
                  _buildFilterChip('Yêu thích'),
                ],
              ),
            ),
          ),

          // Photos grid
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B4513)),
                    ),
                  )
                : _filteredPhotos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_library_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Chưa có ảnh nào',
                              style: GoogleFonts.inika(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Hãy chụp ảnh đầu tiên của bạn!',
                              style: GoogleFonts.inika(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1,
                          ),
                          itemCount: _filteredPhotos.length,
                          itemBuilder: (context, index) {
                            return _buildPhotoCard(_filteredPhotos[index], index);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}