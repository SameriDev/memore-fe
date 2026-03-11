import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'ai_chat_panel.dart';

class AiFloatingBubble extends StatelessWidget {
  const AiFloatingBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 90,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AiChatPanel()),
          );
        },
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_fix_high,
            color: Colors.white,
            size: 26,
          ),
        ),
      ),
    );
  }
}
