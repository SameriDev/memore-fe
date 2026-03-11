import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SuggestedPromptChips extends StatelessWidget {
  final void Function(String prompt) onPromptSelected;

  const SuggestedPromptChips({
    super.key,
    required this.onPromptSelected,
  });

  static const List<String> suggestions = [
    'Làm sáng hơn',
    'Làm ấm hơn',
    'Xóa nền',
    'Thêm hoàng hôn',
    'Phong cách tranh vẽ',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: suggestions.map((prompt) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(
                prompt,
                style: const TextStyle(fontSize: 13, color: AppColors.primary),
              ),
              backgroundColor: AppColors.surface,
              side: BorderSide(color: AppColors.secondary.withOpacity(0.4)),
              onPressed: () => onPromptSelected(prompt),
            ),
          );
        }).toList(),
      ),
    );
  }
}
