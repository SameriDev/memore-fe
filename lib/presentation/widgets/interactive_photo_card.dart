import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memore/core/utils/snackbar_helper.dart';
import 'package:memore/core/utils/show_app_popup.dart';
import '../../data/local/photo_interaction_manager.dart';
import 'app_popup.dart';
import 'photo_interaction_widget.dart';
import 'like_animation_widget.dart';

class InteractivePhotoCard extends StatefulWidget {
  final String photoId;
  final String imageUrl;
  final String caption;
  final String ownerName;
  final String ownerAvatar;
  final DateTime timestamp;
  final VoidCallback? onTap;
  final bool showInteractions;
  final double borderRadius;

  const InteractivePhotoCard({
    super.key,
    required this.photoId,
    required this.imageUrl,
    required this.caption,
    required this.ownerName,
    required this.ownerAvatar,
    required this.timestamp,
    this.onTap,
    this.showInteractions = true,
    this.borderRadius = 12.0,
  });

  @override
  State<InteractivePhotoCard> createState() => _InteractivePhotoCardState();
}

class _InteractivePhotoCardState extends State<InteractivePhotoCard> {
  final _interactionManager = PhotoInteractionManager.instance;
  bool _isLiked = false;
  int _likesCount = 0;
  int _commentsCount = 0;

  @override
  void initState() {
    super.initState();
    _loadInteractionData();
  }

  void _loadInteractionData() {
    setState(() {
      _isLiked = _interactionManager.isPhotoLiked(widget.photoId);
      _likesCount = _interactionManager.getPhotoLikesCount(widget.photoId);
      _commentsCount = _interactionManager.getPhotoCommentsCount(widget.photoId);
    });
  }

  Future<void> _handleDoubleTap() async {
    if (!_isLiked) {
      final success = await _interactionManager.likePhoto(widget.photoId);
      if (success) {
        _loadInteractionData();
      }
    }
  }

  void _showCommentsSheet() {
    showAppPopup(
      context: context,
      builder: (ctx) => AppPopup(
        size: AppPopupSize.large,
        content: PhotoCommentsSheet(photoId: widget.photoId),
      ),
    ).then((_) {
      _loadInteractionData();
    });
  }

  void _showShareSheet() {
    showAppPopup(
      context: context,
      builder: (ctx) => AppPopup(
        size: AppPopupSize.small,
        title: 'Share Photo',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildShareOption(
              icon: Icons.person_add,
              title: 'Share with Friends',
              subtitle: 'Send to your Memore friends',
              onTap: () {
                Navigator.pop(ctx);
                _shareWithFriends();
              },
            ),
            _buildShareOption(
              icon: Icons.copy,
              title: 'Copy Link',
              subtitle: 'Copy photo link to clipboard',
              onTap: () {
                Navigator.pop(ctx);
                _copyLink();
              },
            ),
            _buildShareOption(
              icon: Icons.download,
              title: 'Save to Device',
              subtitle: 'Download photo to your device',
              onTap: () {
                Navigator.pop(ctx);
                _saveToDevice();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF8B4513).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF8B4513),
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.inika(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF3E2723),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inika(
          fontSize: 14,
          color: const Color(0xFF6D4C41),
        ),
      ),
      onTap: onTap,
    );
  }

  void _shareWithFriends() {
    SnackBarHelper.showInfo(context, 'Sharing with friends feature coming soon!');
  }

  void _copyLink() {
    SnackBarHelper.showInfo(context, 'Photo link copied to clipboard!');
  }

  void _saveToDevice() {
    SnackBarHelper.showSuccess(context, 'Photo saved to device!');
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with owner info
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.ownerAvatar),
                  backgroundColor: const Color(0xFF8B4513),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.ownerName,
                        style: GoogleFonts.inika(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF3E2723),
                        ),
                      ),
                      Text(
                        _getTimeAgo(widget.timestamp),
                        style: GoogleFonts.inika(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {}, // More options menu
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Photo with double-tap to like
          DoubleTapLikeOverlay(
            photoId: widget.photoId,
            isLiked: _isLiked,
            onDoubleTap: _handleDoubleTap,
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(widget.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          // Caption
          if (widget.caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                widget.caption,
                style: GoogleFonts.inika(
                  fontSize: 14,
                  color: const Color(0xFF3E2723),
                ),
              ),
            ),

          // Interactions
          if (widget.showInteractions)
            PhotoInteractionWidget(
              photoId: widget.photoId,
              onCommentsPressed: _showCommentsSheet,
              onSharePressed: _showShareSheet,
            ),
        ],
      ),
    );
  }
}

class PhotoFeedCard extends StatelessWidget {
  final String photoId;
  final String imageUrl;
  final String caption;
  final String ownerName;
  final String ownerAvatar;
  final String ownerId;
  final DateTime timestamp;
  final VoidCallback? onTap;

  const PhotoFeedCard({
    super.key,
    required this.photoId,
    required this.imageUrl,
    required this.caption,
    required this.ownerName,
    required this.ownerAvatar,
    required this.ownerId,
    required this.timestamp,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InteractivePhotoCard(
      photoId: photoId,
      imageUrl: imageUrl,
      caption: caption,
      ownerName: ownerName,
      ownerAvatar: ownerAvatar,
      timestamp: timestamp,
      onTap: onTap,
      showInteractions: true,
      borderRadius: 16,
    );
  }
}

class SimplePhotoCard extends StatelessWidget {
  final String photoId;
  final String imageUrl;
  final String caption;
  final VoidCallback? onTap;
  final double height;

  const SimplePhotoCard({
    super.key,
    required this.photoId,
    required this.imageUrl,
    this.caption = '',
    this.onTap,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
              if (caption.isNotEmpty)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                    child: Text(
                      caption,
                      style: GoogleFonts.inika(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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