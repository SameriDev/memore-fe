import 'package:flutter/material.dart';
import '../../domain/entities/friend.dart';

class FriendPickerWidget extends StatefulWidget {
  final List<Friend> friends;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onSelectionChanged;

  const FriendPickerWidget({
    super.key,
    required this.friends,
    required this.selectedIds,
    required this.onSelectionChanged,
  });

  @override
  State<FriendPickerWidget> createState() => _FriendPickerWidgetState();
}

class _FriendPickerWidgetState extends State<FriendPickerWidget> {
  String _searchQuery = '';

  List<Friend> get _filteredFriends {
    if (_searchQuery.isEmpty) return widget.friends;
    return widget.friends
        .where((f) => f.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _toggleSelection(String friendId) {
    final newSelection = Set<String>.from(widget.selectedIds);
    if (newSelection.contains(friendId)) {
      newSelection.remove(friendId);
    } else {
      newSelection.add(friendId);
    }
    widget.onSelectionChanged(newSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: const InputDecoration(
              hintText: 'Tìm bạn bè...',
              border: InputBorder.none,
              icon: Icon(Icons.search, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Selected count
        if (widget.selectedIds.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Đã chọn ${widget.selectedIds.length} bạn',
              style: TextStyle(
                fontSize: 13,
                color: Colors.brown[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        // Selected chips
        if (widget.selectedIds.isNotEmpty)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: widget.selectedIds.map((id) {
              final friend = widget.friends.firstWhere(
                (f) => f.id == id,
                orElse: () => Friend(id: id, name: 'Unknown', avatarUrl: '', isOnline: false, lastActiveTime: ''),
              );
              return Chip(
                avatar: CircleAvatar(
                  backgroundImage: friend.avatarUrl.isNotEmpty
                      ? NetworkImage(friend.avatarUrl)
                      : null,
                  child: friend.avatarUrl.isEmpty
                      ? Text(friend.name.isNotEmpty ? friend.name[0] : '?')
                      : null,
                ),
                label: Text(friend.name, style: const TextStyle(fontSize: 12)),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => _toggleSelection(id),
                backgroundColor: Colors.brown[50],
              );
            }).toList(),
          ),
        if (widget.selectedIds.isNotEmpty) const SizedBox(height: 8),
        // Friend list
        Expanded(
          child: _filteredFriends.isEmpty
              ? Center(
                  child: Text(
                    'Không tìm thấy bạn bè',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                )
              : ListView.builder(
                  itemCount: _filteredFriends.length,
                  itemBuilder: (context, index) {
                    final friend = _filteredFriends[index];
                    final isSelected = widget.selectedIds.contains(friend.id);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: friend.avatarUrl.isNotEmpty
                            ? NetworkImage(friend.avatarUrl)
                            : null,
                        child: friend.avatarUrl.isEmpty
                            ? Text(friend.name.isNotEmpty ? friend.name[0] : '?')
                            : null,
                      ),
                      title: Text(friend.name),
                      trailing: Checkbox(
                        value: isSelected,
                        activeColor: Colors.brown,
                        onChanged: (_) => _toggleSelection(friend.id),
                      ),
                      onTap: () => _toggleSelection(friend.id),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
