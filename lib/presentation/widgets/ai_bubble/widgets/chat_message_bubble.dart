import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';

class ChatMessage {
  final bool isBot;
  final String? text;
  final String? imageUrl;
  final String? photoId;
  final bool isLoading;
  final List<String>? actions;

  ChatMessage({
    required this.isBot,
    this.text,
    this.imageUrl,
    this.photoId,
    this.isLoading = false,
    this.actions,
  });
}

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final void Function(String action)? onActionTap;

  const ChatMessageBubble({
    super.key,
    required this.message,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        mainAxisAlignment:
            message.isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.isBot) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.auto_fix_high, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isBot
                    ? AppColors.secondary.withOpacity(0.15)
                    : AppColors.primary.withOpacity(0.8),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(message.isBot ? 4 : 16),
                  bottomRight: Radius.circular(message.isBot ? 16 : 4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.isLoading)
                    _buildLoading()
                  else ...[
                    if (message.text != null)
                      Text(
                        message.text!,
                        style: TextStyle(
                          fontSize: 14,
                          color: message.isBot ? AppColors.text : Colors.white,
                          height: 1.4,
                        ),
                      ),
                    if (message.imageUrl != null) ...[
                      if (message.text != null) const SizedBox(height: 8),
                      _buildImage(),
                    ],
                    if (message.actions != null && message.actions!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _buildActions(),
                    ],
                  ],
                ],
              ),
            ),
          ),
          if (!message.isBot) const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Đang xử lý...',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 220, maxHeight: 220),
        child: message.imageUrl!.startsWith('http')
            ? CachedNetworkImage(
                imageUrl: message.imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 200,
                  height: 150,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 200,
                  height: 150,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              )
            : Image.file(
                File(message.imageUrl!),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 200,
                  height: 150,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
      ),
    );
  }

  Widget _buildActions() {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: message.actions!.map((action) {
        return ActionChip(
          label: Text(
            action,
            style: const TextStyle(fontSize: 12, color: AppColors.primary),
          ),
          backgroundColor: AppColors.background,
          side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
          onPressed: () => onActionTap?.call(action),
        );
      }).toList(),
    );
  }
}
