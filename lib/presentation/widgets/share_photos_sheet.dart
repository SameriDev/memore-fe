import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memore/core/utils/snackbar_helper.dart';
import '../../data/local/photo_sharing_manager.dart';
import '../../data/local/friend_manager.dart';

class SharePhotosSheet extends StatefulWidget {
  final List<String> photoIds;
  final String? title;

  const SharePhotosSheet({
    super.key,
    required this.photoIds,
    this.title,
  });

  @override
  State<SharePhotosSheet> createState() => _SharePhotosSheetState();
}

class _SharePhotosSheetState extends State<SharePhotosSheet> {
  final _sharingManager = PhotoSharingManager.instance;
  final _friendManager = FriendManager.instance;
  final _messageController = TextEditingController();

  List<Map<String, dynamic>> _friends = [];
  List<String> _selectedFriends = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  void _loadFriends() {
    final friendsList = _friendManager.getFriendsList();
    setState(() {
      _friends = friendsList.map((friend) => {
        'id': friend.id,
        'name': friend.name,
        'avatarUrl': friend.avatarUrl,
        'isOnline': friend.isOnline,
      }).toList();
    });
  }

  void _toggleFriendSelection(String friendId) {
    setState(() {
      if (_selectedFriends.contains(friendId)) {
        _selectedFriends.remove(friendId);
      } else {
        _selectedFriends.add(friendId);
      }
    });
  }

  Future<void> _sharePhotos() async {
    if (_selectedFriends.isEmpty) {
      SnackBarHelper.showError(context, 'Please select at least one friend to share with');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      bool allShared = true;

      for (final photoId in widget.photoIds) {
        final success = await _sharingManager.sharePhotoWithFriends(
          photoId,
          _selectedFriends,
          message: _messageController.text.trim().isEmpty ? null : _messageController.text.trim(),
        );

        if (!success) {
          allShared = false;
        }
      }

      if (allShared) {
        if (mounted) {
          SnackBarHelper.showSuccess(
            context,
            widget.photoIds.length == 1
                ? 'Photo shared successfully!'
                : '${widget.photoIds.length} photos shared successfully!',
          );
          Navigator.of(context).pop();
        }
      } else {
        if (mounted) {
          SnackBarHelper.showError(context, 'Some photos could not be shared. Please try again.');
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, 'Error sharing photos: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5DC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Drag indicator
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Text(
                      widget.title ?? 'Share Photos',
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

                // Photo count
                if (widget.photoIds.length > 1)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B4513).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${widget.photoIds.length} photos selected',
                      style: GoogleFonts.inika(
                        fontSize: 12,
                        color: const Color(0xFF8B4513),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Selected friends summary
          if (_selectedFriends.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Friends (${_selectedFriends.length})',
                    style: GoogleFonts.inika(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3E2723),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _selectedFriends.map((friendId) {
                      final friend = _friends.firstWhere((f) => f['id'] == friendId);
                      return Chip(
                        avatar: CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(friend['avatarUrl']),
                        ),
                        label: Text(
                          friend['name'],
                          style: GoogleFonts.inika(fontSize: 12),
                        ),
                        backgroundColor: const Color(0xFF8B4513).withValues(alpha: 0.1),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () => _toggleFriendSelection(friendId),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

          // Message input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _messageController,
              style: GoogleFonts.inika(),
              decoration: InputDecoration(
                hintText: 'Add a message (optional)...',
                hintStyle: GoogleFonts.inika(
                  color: Colors.grey[600],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF8B4513)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 2,
            ),
          ),

          const SizedBox(height: 16),

          // Friends list
          Expanded(
            child: _friends.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.group_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No friends found',
                          style: GoogleFonts.inika(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add some friends to start sharing!',
                          style: GoogleFonts.inika(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _friends.length,
                    itemBuilder: (context, index) {
                      final friend = _friends[index];
                      final isSelected = _selectedFriends.contains(friend['id']);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(
                                  color: const Color(0xFF8B4513),
                                  width: 2,
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(friend['avatarUrl']),
                                backgroundColor: const Color(0xFF8B4513),
                              ),
                              if (friend['isOnline'] as bool)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4CAF50),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          title: Text(
                            friend['name'],
                            style: GoogleFonts.inika(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF3E2723),
                            ),
                          ),
                          subtitle: Text(
                            friend['isOnline'] as bool ? 'Online' : 'Offline',
                            style: GoogleFonts.inika(
                              fontSize: 12,
                              color: friend['isOnline'] as bool
                                  ? const Color(0xFF4CAF50)
                                  : Colors.grey[600],
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF8B4513),
                                )
                              : const Icon(
                                  Icons.radio_button_unchecked,
                                  color: Colors.grey,
                                ),
                          onTap: () => _toggleFriendSelection(friend['id']),
                        ),
                      );
                    },
                  ),
          ),

          // Share button
          Container(
            padding: const EdgeInsets.all(16),
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
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading || _selectedFriends.isEmpty ? null : _sharePhotos,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B4513),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        _selectedFriends.isEmpty
                            ? 'Select friends to share'
                            : 'Share with ${_selectedFriends.length} friend${_selectedFriends.length > 1 ? 's' : ''}',
                        style: GoogleFonts.inika(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SharedPhotosViewScreen extends StatefulWidget {
  const SharedPhotosViewScreen({super.key});

  @override
  State<SharedPhotosViewScreen> createState() => _SharedPhotosViewScreenState();
}

class _SharedPhotosViewScreenState extends State<SharedPhotosViewScreen>
    with SingleTickerProviderStateMixin {
  final _sharingManager = PhotoSharingManager.instance;
  late TabController _tabController;

  List<Map<String, dynamic>> _sharedPhotos = [];
  List<Map<String, dynamic>> _outgoingShares = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSharedPhotos();
  }

  void _loadSharedPhotos() {
    setState(() {
      _sharedPhotos = _sharingManager.getSharedPhotos();
      _outgoingShares = _sharingManager.getOutgoingShares();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        title: Text(
          'Shared Photos',
          style: GoogleFonts.inika(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF3E2723),
          ),
        ),
        backgroundColor: const Color(0xFFF5F5DC),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF3E2723)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF8B4513),
          labelColor: const Color(0xFF8B4513),
          unselectedLabelColor: Colors.grey[600],
          labelStyle: GoogleFonts.inika(
            fontWeight: FontWeight.w600,
          ),
          tabs: [
            Tab(text: 'Received (${_sharedPhotos.length})'),
            Tab(text: 'Sent (${_outgoingShares.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReceivedTab(),
          _buildSentTab(),
        ],
      ),
    );
  }

  Widget _buildReceivedTab() {
    if (_sharedPhotos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No shared photos yet',
              style: GoogleFonts.inika(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Photos shared with you will appear here',
              style: GoogleFonts.inika(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _sharedPhotos.length,
      itemBuilder: (context, index) {
        final share = _sharedPhotos[index];
        return _buildSharedPhotoItem(share, isReceived: true);
      },
    );
  }

  Widget _buildSentTab() {
    if (_outgoingShares.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.send_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No photos sent yet',
              style: GoogleFonts.inika(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Photos you share will appear here',
              style: GoogleFonts.inika(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _outgoingShares.length,
      itemBuilder: (context, index) {
        final share = _outgoingShares[index];
        return _buildSharedPhotoItem(share, isReceived: false);
      },
    );
  }

  Widget _buildSharedPhotoItem(Map<String, dynamic> share, {required bool isReceived}) {
    final photoData = share['photoData'] as Map<String, dynamic>;
    final sharedAt = DateTime.parse(share['sharedAt']);
    final timeAgo = _getTimeAgo(sharedAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    isReceived ? share['fromUserAvatar'] : share['fromUserAvatar'],
                  ),
                  backgroundColor: const Color(0xFF8B4513),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isReceived
                            ? '${share['fromUserName']} shared with you'
                            : 'Sent to ${share['fromUserName']}',
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
                if (isReceived && !(share['isViewed'] as bool? ?? false))
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF8B4513),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),

          // Photo
          Container(
            width: double.infinity,
            height: 250,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(photoData['imageUrl']),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Message
          if (share['message'] != null && (share['message'] as String).isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5DC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  share['message'],
                  style: GoogleFonts.inika(
                    fontSize: 14,
                    color: const Color(0xFF3E2723),
                    fontStyle: FontStyle.italic,
                  ),
                ),
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