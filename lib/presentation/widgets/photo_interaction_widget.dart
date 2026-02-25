import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/local/photo_interaction_manager.dart';
import 'like_animation_widget.dart';

class PhotoInteractionWidget extends StatefulWidget {
  final String photoId;
  final bool showCommentsButton;
  final bool showShareButton;
  final VoidCallback? onCommentsPressed;
  final VoidCallback? onSharePressed;

  const PhotoInteractionWidget({
    super.key,
    required this.photoId,
    this.showCommentsButton = true,
    this.showShareButton = true,
    this.onCommentsPressed,
    this.onSharePressed,
  });

  @override
  State<PhotoInteractionWidget> createState() => _PhotoInteractionWidgetState();
}

class _PhotoInteractionWidgetState extends State<PhotoInteractionWidget> {
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

  Future<void> _toggleLike() async {
    bool success;
    if (_isLiked) {
      success = await _interactionManager.unlikePhoto(widget.photoId);
    } else {
      success = await _interactionManager.likePhoto(widget.photoId);
    }

    if (success) {
      _loadInteractionData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: Colors.grey.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Like Button
          LikeButton(
            photoId: widget.photoId,
            isLiked: _isLiked,
            likesCount: _likesCount,
            onPressed: _toggleLike,
            size: 24,
            textStyle: GoogleFonts.inika(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(width: 24),

          // Comments Button
          if (widget.showCommentsButton) ...[
            GestureDetector(
              onTap: widget.onCommentsPressed,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                  if (_commentsCount > 0) ...[
                    const SizedBox(width: 4),
                    Text(
                      _commentsCount.toString(),
                      style: GoogleFonts.inika(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 24),
          ],

          // Share Button
          if (widget.showShareButton) ...[
            GestureDetector(
              onTap: widget.onSharePressed,
              child: Icon(
                Icons.share_outlined,
                color: Colors.grey[600],
                size: 24,
              ),
            ),
          ],

          const Spacer(),

          // Interaction Summary
          if (_likesCount > 0 || _commentsCount > 0)
            GestureDetector(
              onTap: widget.onCommentsPressed,
              child: Text(
                _buildInteractionSummary(),
                style: GoogleFonts.inika(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _buildInteractionSummary() {
    final parts = <String>[];

    if (_likesCount > 0) {
      parts.add('$_likesCount ${_likesCount == 1 ? 'like' : 'likes'}');
    }

    if (_commentsCount > 0) {
      parts.add('$_commentsCount ${_commentsCount == 1 ? 'comment' : 'comments'}');
    }

    return parts.join(' • ');
  }
}

class PhotoCommentsSheet extends StatefulWidget {
  final String photoId;

  const PhotoCommentsSheet({
    super.key,
    required this.photoId,
  });

  @override
  State<PhotoCommentsSheet> createState() => _PhotoCommentsSheetState();
}

class _PhotoCommentsSheetState extends State<PhotoCommentsSheet> {
  final _interactionManager = PhotoInteractionManager.instance;
  final _commentController = TextEditingController();
  final _scrollController = ScrollController();
  List<Map<String, dynamic>> _comments = [];
  List<Map<String, dynamic>> _likers = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _comments = _interactionManager.getPhotoComments(widget.photoId);
      _likers = _interactionManager.getPhotoLikers(widget.photoId);
    });
  }

  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final commentId = await _interactionManager.addComment(widget.photoId, text);

    if (commentId != null) {
      _commentController.clear();
      _loadData();

      // Scroll to bottom to show new comment
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _likeComment(String commentId) async {
    await _interactionManager.likeComment(widget.photoId, commentId);
    _loadData();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
                  children: [
                    Text(
                      'Interactions',
                      style: GoogleFonts.inika(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3E2723),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
          ),
        ),

        // Likes summary
        if (_likers.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5DC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.favorite,
                  color: const Color(0xFFE91E63),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Liked by ${_likers.map((e) => e['name']).join(', ')}',
                    style: GoogleFonts.inika(
                      fontSize: 12,
                      color: const Color(0xFF6D4C41),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Comments List
          Expanded(
            child: _comments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No comments yet',
                          style: GoogleFonts.inika(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Be the first to comment!',
                          style: GoogleFonts.inika(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      return _buildCommentItem(comment);
                    },
                  ),
          ),

          // Comment Input
          Container(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    style: GoogleFonts.inika(),
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      hintStyle: GoogleFonts.inika(
                        color: Colors.grey[600],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Color(0xFF8B4513)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5F5DC),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _addComment(),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B4513),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _isLoading ? null : _addComment,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    final timestamp = DateTime.parse(comment['timestamp']);
    final timeAgo = _getTimeAgo(timestamp);
    final likedBy = List<String>.from(comment['likedBy'] ?? []);
    final likesCount = comment['likes'] as int? ?? 0;
    // Check if current user liked this comment
    final userId = _interactionManager.currentUserId;
    final isLikedByUser = userId != null && likedBy.contains(userId);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(comment['userAvatar']),
                backgroundColor: const Color(0xFF8B4513),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment['userName'],
                      style: GoogleFonts.inika(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3E2723),
                      ),
                    ),
                    Text(
                      timeAgo,
                      style: GoogleFonts.inika(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _likeComment(comment['id']),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isLikedByUser ? Icons.favorite : Icons.favorite_border,
                      size: 16,
                      color: isLikedByUser ? const Color(0xFFE91E63) : Colors.grey[600],
                    ),
                    if (likesCount > 0) ...[
                      const SizedBox(width: 4),
                      Text(
                        likesCount.toString(),
                        style: GoogleFonts.inika(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment['text'],
            style: GoogleFonts.inika(
              fontSize: 14,
              color: const Color(0xFF3E2723),
            ),
          ),
        ],
      ),
    );
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
}