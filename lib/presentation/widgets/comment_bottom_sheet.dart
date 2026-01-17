import 'package:flutter/material.dart';
import '../../core/constants/app_sizes.dart';

class Comment {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final DateTime timestamp;
  final List<String> reactions;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.timestamp,
    this.reactions = const [],
  });
}

class CommentBottomSheet extends StatefulWidget {
  final String photoId;
  final VoidCallback? onClose;

  const CommentBottomSheet({
    required this.photoId,
    this.onClose,
    super.key,
  });

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  List<Comment> _comments = [];
  bool _isLoading = true;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadComments();
    // Auto-focus the input field
    Future.delayed(const Duration(milliseconds: 300), () {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    // TODO: Load actual comments from provider
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _comments = [
        Comment(
          id: 'c1',
          userId: 'user_001',
          userName: 'Sarah Johnson',
          text: 'Love this photo! 😍',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          reactions: ['❤️', '👍'],
        ),
        Comment(
          id: 'c2',
          userId: 'user_002',
          userName: 'Mike Chen',
          text: 'Great shot! Where was this taken?',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          reactions: ['👍'],
        ),
        Comment(
          id: 'c3',
          userId: 'user_003',
          userName: 'Emma Davis',
          text: 'Beautiful sunset 🌅',
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          reactions: ['❤️', '😍', '🔥'],
        ),
      ];
      _isLoading = false;
    });

    // Scroll to bottom after loading
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendComment() async {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _isSending = true;
    });

    // TODO: Send comment to backend
    await Future.delayed(const Duration(milliseconds: 500));

    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user',
      userName: 'You',
      text: _commentController.text.trim(),
      timestamp: DateTime.now(),
    );

    setState(() {
      _comments.add(newComment);
      _commentController.clear();
      _isSending = false;
    });

    // Scroll to bottom after adding comment
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF666666),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            child: Row(
              children: [
                const Text(
                  'Comments',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFF666666),
                    size: 24,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onClose?.call();
                  },
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            color: const Color(0xFF404040).withValues(alpha: 0.3),
          ),

          // Comments list
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFFD700),
                    ),
                  )
                : _comments.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(AppSizes.paddingMd),
                        itemCount: _comments.length,
                        itemBuilder: (context, index) {
                          return _buildCommentItem(_comments[index]);
                        },
                      ),
          ),

          // Input section
          Container(
            padding: EdgeInsets.only(
              left: AppSizes.paddingMd,
              right: AppSizes.paddingMd,
              bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.paddingMd,
              top: AppSizes.paddingSm,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF2A2A2A),
              border: Border(
                top: BorderSide(
                  color: Color(0xFF404040),
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFFFFD700),
                  child: const Text(
                    'Y',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: AppSizes.spacingSm),

                // Input field
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    focusNode: _focusNode,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      hintStyle: const TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1A1A1A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendComment(),
                  ),
                ),

                const SizedBox(width: AppSizes.spacingSm),

                // Send button
                _isSending
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Color(0xFFFFD700),
                          strokeWidth: 2,
                        ),
                      )
                    : IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Color(0xFFFFD700),
                          size: 24,
                        ),
                        onPressed: _sendComment,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.comment_outlined,
            color: const Color(0xFF666666).withValues(alpha: 0.5),
            size: 64,
          ),
          const SizedBox(height: AppSizes.spacingMd),
          const Text(
            'No comments yet',
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.spacingSm),
          const Text(
            'Be the first to comment!',
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Comment comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spacingMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: _getAvatarColor(comment.userId),
            child: Text(
              comment.userName.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: AppSizes.spacingSm),

          // Comment content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and time
                Row(
                  children: [
                    Text(
                      comment.userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: AppSizes.spacingSm),
                    Text(
                      _getTimeAgo(comment.timestamp),
                      style: const TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Comment text
                Text(
                  comment.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),

                // Reactions
                if (comment.reactions.isNotEmpty) ...[
                  const SizedBox(height: AppSizes.spacingSm),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...comment.reactions.take(3).map((reaction) => Text(
                                  reaction,
                                  style: const TextStyle(fontSize: 12),
                                )),
                            if (comment.reactions.length > 3) ...[
                              const SizedBox(width: 4),
                              Text(
                                '+${comment.reactions.length - 3}',
                                style: const TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // More options
          IconButton(
            icon: const Icon(
              Icons.more_horiz,
              color: Color(0xFF666666),
              size: 20,
            ),
            onPressed: () => _showCommentOptions(comment),
          ),
        ],
      ),
    );
  }

  void _showCommentOptions(Comment comment) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.add_reaction_outlined,
                color: Colors.white,
                size: 24,
              ),
              title: const Text(
                'React to comment',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showReactionPicker(comment);
              },
            ),
            if (comment.userId == 'current_user')
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFEF4444),
                  size: 24,
                ),
                title: const Text(
                  'Delete comment',
                  style: TextStyle(
                    color: Color(0xFFEF4444),
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _deleteComment(comment);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showReactionPicker(Comment comment) {
    // TODO: Implement reaction picker
  }

  void _deleteComment(Comment comment) {
    setState(() {
      _comments.removeWhere((c) => c.id == comment.id);
    });
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${(difference.inDays / 7).floor()}w';
    }
  }

  Color _getAvatarColor(String id) {
    final colors = [
      const Color(0xFFFFD700),
      const Color(0xFF8B5CF6),
      const Color(0xFF06B6D4),
      const Color(0xFFEF4444),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
    ];
    final index = id.hashCode % colors.length;
    return colors[index];
  }
}