import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/data_sources/remote/notification_service.dart';
import '../../widgets/decorated_background.dart';

enum _NotifType { like, comment, friendRequest, photo, album, other }

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NovuNotification> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    final notifications = await NotificationService.instance.getNotifications();
    setState(() {
      _notifications = notifications;
      _isLoading = false;
    });
  }

  Future<void> _markAllRead() async {
    await NotificationService.instance.markAllAsRead();
    _loadNotifications();
  }

  // --- Helpers ---

  _NotifType _getType(NovuNotification notif) {
    final subject = (notif.subject ?? '').toLowerCase();
    final content = (notif.content ?? '').toLowerCase();
    final type = notif.payload?['type']?.toString().toLowerCase() ?? '';
    final combined = '$subject $content $type';

    if (combined.contains('like') || combined.contains('thích')) {
      return _NotifType.like;
    }
    if (combined.contains('comment') || combined.contains('bình luận')) {
      return _NotifType.comment;
    }
    if (combined.contains('friend') ||
        combined.contains('bạn bè') ||
        combined.contains('kết bạn') ||
        combined.contains('person_add')) {
      return _NotifType.friendRequest;
    }
    if (combined.contains('photo') ||
        combined.contains('ảnh') ||
        combined.contains('camera')) {
      return _NotifType.photo;
    }
    if (combined.contains('album')) {
      return _NotifType.album;
    }
    return _NotifType.other;
  }

  IconData _iconFor(_NotifType t) => switch (t) {
        _NotifType.like => Icons.favorite,
        _NotifType.comment => Icons.chat_bubble,
        _NotifType.friendRequest => Icons.person_add,
        _NotifType.photo => Icons.camera_alt,
        _NotifType.album => Icons.photo_album,
        _NotifType.other => Icons.notifications,
      };

  Color _colorFor(_NotifType t) => switch (t) {
        _NotifType.like => const Color(0xFFFCE4EC),
        _NotifType.comment => const Color(0xFFE3F2FD),
        _NotifType.friendRequest => const Color(0xFFF3E5F5),
        _NotifType.photo => const Color(0xFFE8F5E9),
        _NotifType.album => const Color(0xFFFFF3E0),
        _NotifType.other => const Color(0xFFEFEBE9),
      };

  Color _iconColorFor(_NotifType t) => switch (t) {
        _NotifType.like => const Color(0xFFE91E63),
        _NotifType.comment => const Color(0xFF1976D2),
        _NotifType.friendRequest => const Color(0xFF7B1FA2),
        _NotifType.photo => const Color(0xFF388E3C),
        _NotifType.album => const Color(0xFFE65100),
        _NotifType.other => AppColors.primary,
      };

  String _formatTime(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 1) return 'Vừa xong';
      if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
      if (diff.inHours < 24) return '${diff.inHours} giờ trước';
      if (diff.inDays < 7) return '${diff.inDays} ngày trước';
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return '';
    }
  }

  String _timeGroup(String? dateStr) {
    if (dateStr == null) return 'Trước đó';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final weekAgo = today.subtract(const Duration(days: 7));
      final d = DateTime(date.year, date.month, date.day);

      if (!d.isBefore(today)) return 'Hôm nay';
      if (!d.isBefore(yesterday)) return 'Hôm qua';
      if (!d.isBefore(weekAgo)) return 'Tuần này';
      return 'Trước đó';
    } catch (_) {
      return 'Trước đó';
    }
  }

  Map<String, List<NovuNotification>> _grouped() {
    final order = ['Hôm nay', 'Hôm qua', 'Tuần này', 'Trước đó'];
    final map = <String, List<NovuNotification>>{};
    for (final n in _notifications) {
      final g = _timeGroup(n.createdAt);
      (map[g] ??= []).add(n);
    }
    final result = <String, List<NovuNotification>>{};
    for (final key in order) {
      if (map.containsKey(key)) result[key] = map[key]!;
    }
    return result;
  }

  // --- Build ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DecoratedBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.cardBackground,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back,
                  color: AppColors.text, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Thông báo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: AppColors.text,
              ),
            ),
          ),
          if (_notifications.any((n) => !n.isRead))
            GestureDetector(
              onTap: _markAllRead,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Đọc hết',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (_notifications.isEmpty) {
      return _buildEmptyState();
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _loadNotifications,
      child: _buildGroupedList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_off_outlined,
              size: 80, color: AppColors.textSecondary.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          const Text(
            'Chưa có thông báo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thông báo mới sẽ xuất hiện ở đây',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedList() {
    final groups = _grouped();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: groups.entries.fold<int>(
          0, (sum, e) => sum + 1 + e.value.length), // headers + items
      itemBuilder: (context, index) {
        var i = 0;
        for (final entry in groups.entries) {
          if (index == i) {
            return _buildGroupHeader(entry.key);
          }
          i++;
          if (index < i + entry.value.length) {
            return _buildNotificationCard(entry.value[index - i]);
          }
          i += entry.value.length;
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildGroupHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NovuNotification notif) {
    final type = _getType(notif);
    return Dismissible(
      key: Key(notif.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.done_all, color: AppColors.primary),
      ),
      onDismissed: (_) async {
        if (!notif.isRead) {
          await NotificationService.instance.markAsRead(notif.id);
        }
        setState(() => _notifications.removeWhere((n) => n.id == notif.id));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: notif.isRead ? AppColors.cardBackground : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          leading: CircleAvatar(
            backgroundColor: _colorFor(type),
            child: Icon(_iconFor(type), color: _iconColorFor(type), size: 20),
          ),
          title: Text(
            notif.content ?? 'Thông báo mới',
            style: TextStyle(
              fontSize: 14,
              fontWeight: notif.isRead ? FontWeight.normal : FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _formatTime(notif.createdAt),
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary),
            ),
          ),
          trailing: notif.isRead
              ? null
              : Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
          onTap: () async {
            if (!notif.isRead) {
              await NotificationService.instance.markAsRead(notif.id);
              _loadNotifications();
            }
          },
        ),
      ),
    );
  }
}
