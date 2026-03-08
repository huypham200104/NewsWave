import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

/// Reusable chip widget for topic selection
class TopicChip extends StatelessWidget {
  final String topic;
  final bool isSelected;
  final VoidCallback onTap;
  final int animationDelay;

  const TopicChip({
    super.key,
    required this.topic,
    required this.isSelected,
    required this.onTap,
    this.animationDelay = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryBlue
              : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.withAlpha(76),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryBlue.withAlpha(76),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Text(
          topic,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
          ),
        ),
      ),
    ).animate().scale(delay: Duration(milliseconds: animationDelay));
  }
}
