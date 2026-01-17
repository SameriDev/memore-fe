import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_sizes.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSizes.spacingSm),
            Expanded(child: _buildMessagesList()),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesList() {
    final messages = _getMockMessages();

    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.message_outlined, size: 64, color: Colors.grey.shade700),
            const SizedBox(height: 16),
            Text(
              'No messages yet',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingSm),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _buildMessageTile(message, context);
      },
    );
  }

  Widget _buildMessageTile(_MessageItem message, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMd,
          vertical: AppSizes.paddingXs,
        ),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xFF6B4EFF),
          child: Text(
            message.userName.substring(0, 1).toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                message.userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              message.time,
              style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
            ),
          ],
        ),
        subtitle: Text(
          message.lastMessage,
          style: const TextStyle(color: Color(0xFF999999), fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Color(0xFF666666),
          size: 20,
        ),
        onTap: () {
          context.push(
            '${AppRoutes.chat}?userId=${message.userId}&userName=${message.userName}',
          );
        },
      ),
    );
  }

  List<_MessageItem> _getMockMessages() {
    return [
      _MessageItem(
        userId: '1',
        userName: 'Danny D',
        lastMessage: 'Replied to your Locket!',
        time: '2m',
      ),
      _MessageItem(
        userId: '2',
        userName: 'Sarah',
        lastMessage: 'Hey! How are you?',
        time: '1h',
      ),
      _MessageItem(
        userId: '3',
        userName: 'Mike',
        lastMessage: 'That photo was amazing!',
        time: '3h',
      ),
    ];
  }
}

class _MessageItem {
  final String userId;
  final String userName;
  final String lastMessage;
  final String time;

  _MessageItem({
    required this.userId,
    required this.userName,
    required this.lastMessage,
    required this.time,
  });
}
