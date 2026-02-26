import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/photo_dto.dart';

class PanoramaPreviewScreen extends StatefulWidget {
  final PhotoDto photoDto;

  const PanoramaPreviewScreen({super.key, required this.photoDto});

  @override
  State<PanoramaPreviewScreen> createState() => _PanoramaPreviewScreenState();
}

class _PanoramaPreviewScreenState extends State<PanoramaPreviewScreen> {
  bool _showPanoramaView = false;

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.photoDto.filePath ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F2F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Xem trước Panorama',
          style: TextStyle(color: AppColors.text, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showPanoramaView ? Icons.photo : Icons.panorama_horizontal,
              color: AppColors.primary,
            ),
            onPressed: () => setState(() => _showPanoramaView = !_showPanoramaView),
            tooltip: _showPanoramaView ? 'Xem ảnh phẳng' : 'Xem 360°',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _showPanoramaView
                ? PanoramaViewer(
                    child: Image.network(imageUrl, fit: BoxFit.fill),
                  )
                : InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.contain,
                        placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (_, __, ___) => const Center(child: Icon(Icons.broken_image, size: 48)),
                      ),
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Xong'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
