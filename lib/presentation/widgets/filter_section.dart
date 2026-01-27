import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';

class FilterSection extends StatelessWidget {
  final List<String> activeFilters;
  final VoidCallback? onFilterTap;
  final Function(String)? onRemoveFilter;

  const FilterSection({
    super.key,
    required this.activeFilters,
    this.onFilterTap,
    this.onRemoveFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.horizontalPadding,
        vertical: 8,
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onFilterTap,
            borderRadius: BorderRadius.circular(50),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: const Icon(Icons.tune, size: 24),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: activeFilters.map((filter) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _FilterChip(
                      label: filter,
                      onRemove: () => onRemoveFilter?.call(filter),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _FilterChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 20, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
