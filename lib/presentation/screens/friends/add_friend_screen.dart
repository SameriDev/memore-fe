import 'package:flutter/material.dart';
import 'package:memore/core/utils/snackbar_helper.dart';
import '../../../data/data_sources/remote/user_service.dart';
import '../../../data/data_sources/remote/friendship_service.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/models/user_dto.dart';
import '../../widgets/decorated_background.dart';
import '../../routes/custom_route_transitions.dart';
import 'pending_requests_screen.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final TextEditingController _controller = TextEditingController();
  List<UserDto> _results = [];
  final Set<String> _sentIds = {};
  bool _isLoading = false;
  bool _hasSearched = false;

  Future<void> _search() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    final results = await UserService.instance.searchByUsername(query);
    final currentUserId = StorageService.instance.userId;
    setState(() {
      _results = results.where((u) => u.id != currentUserId).toList();
      _isLoading = false;
    });
  }

  Future<void> _sendRequest(UserDto user) async {
    final currentUserId = StorageService.instance.userId;
    if (currentUserId == null) return;

    final result = await FriendshipService.instance.sendRequest(currentUserId, user.id);
    if (result != null && mounted) {
      setState(() => _sentIds.add(user.id));
      SnackBarHelper.showSuccess(context, 'Đã gửi lời mời kết bạn');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBackground(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Add Friend', style: TextStyle(color: Colors.black)),
            actions: [
              TextButton(
                onPressed: () => context.pushSlideBottom(const PendingRequestsScreen()),
                child: const Text('Lời mời', style: TextStyle(color: Colors.brown, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Nhập username...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.brown),
                  onPressed: _search,
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _hasSearched && _results.isEmpty
                    ? const Center(
                        child: Text(
                          'Không tìm thấy người dùng',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _results.length,
                        itemBuilder: (context, index) {
                          final user = _results[index];
                          final isSent = _sentIds.contains(user.id);
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                user.avatarUrl ?? 'https://i.pravatar.cc/150?u=${user.id}',
                              ),
                            ),
                            title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text('@${user.username}', style: const TextStyle(color: Colors.black54)),
                            trailing: isSent
                                ? const TextButton(onPressed: null, child: Text('Đã gửi'))
                                : ElevatedButton(
                                    onPressed: () => _sendRequest(user),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.brown,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Add'),
                                  ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
