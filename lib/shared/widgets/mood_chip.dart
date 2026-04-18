import 'package:flutter/material.dart';
import '../../data/models/journal_entry.dart';
import '../theme/app_colors.dart';

/// Selectable mood chip with emoji and label.
class MoodChip extends StatelessWidget {
  final Mood mood;
  final bool isSelected;
  final VoidCallback onTap;

  const MoodChip({
    super.key,
    required this.mood,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final moodColor = AppColors.moodColor(mood.index);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? moodColor.withOpacity(0.2) : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? moodColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(mood.emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Text(
              mood.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? moodColor : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
