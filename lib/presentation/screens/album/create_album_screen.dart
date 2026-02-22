import 'package:flutter/material.dart';
import '../../../data/data_sources/remote/album_service.dart';
import '../../../data/data_sources/remote/friendship_service.dart';
import '../../../data/local/storage_service.dart';
import '../../../domain/entities/friend.dart';
import '../../widgets/decorated_background.dart';
import '../../widgets/friend_picker_widget.dart';

class CreateAlbumScreen extends StatefulWidget {
  const CreateAlbumScreen({super.key});

  @override
  State<CreateAlbumScreen> createState() => _CreateAlbumScreenState();
}

class _CreateAlbumScreenState extends State<CreateAlbumScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  List<Friend> _friends = [];
  Set<String> _selectedFriendIds = {};
  bool _isLoading = false;
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _loadFriends() async {
    setState(() => _isLoading = true);
    final userId = StorageService.instance.userId;
    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }
    final dtos = await FriendshipService.instance.getUserFriends(userId);
    setState(() {
      _friends = dtos.map((dto) => dto.toEntity(userId)).toList();
      _isLoading = false;
    });
  }

  Future<void> _createAlbum() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên album')),
      );
      return;
    }

    setState(() => _isCreating = true);
    final userId = StorageService.instance.userId;
    if (userId == null) return;

    final result = await AlbumService.instance.createAlbum(
      name: name,
      creatorId: userId,
      description: _descController.text.trim().isNotEmpty
          ? _descController.text.trim()
          : null,
      inviteFriendIds:
          _selectedFriendIds.isNotEmpty ? _selectedFriendIds.toList() : null,
    );

    setState(() => _isCreating = false);

    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tạo album thành công!')),
      );
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tạo album thất bại')),
      );
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
              // Header
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
                    'Tạo Album Mới',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Album name
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Tên album',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Description
              TextField(
                controller: _descController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Mô tả (tùy chọn)',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Mời bạn bè',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              // Friend picker
              Expanded(
                child: _isLoading
                    ? const Center(
                        child:
                            CircularProgressIndicator(color: Colors.brown))
                    : FriendPickerWidget(
                        friends: _friends,
                        selectedIds: _selectedFriendIds,
                        onSelectionChanged: (ids) =>
                            setState(() => _selectedFriendIds = ids),
                      ),
              ),
              // Create button
              Padding(
                padding: const EdgeInsets.only(bottom: 32, top: 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isCreating ? null : _createAlbum,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isCreating
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Tạo Album',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
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
