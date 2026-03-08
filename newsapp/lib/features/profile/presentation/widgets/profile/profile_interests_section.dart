import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/theme/app_colors.dart';

class ProfileInterestsSection extends StatelessWidget {
  final List<String> topics;
  final bool isDark;

  const ProfileInterestsSection({
    super.key,
    required this.topics,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (topics.isEmpty) return const SizedBox.shrink();
    
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Interests',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: topics.map((topic) {
            return Chip(
              label: Text(topic),
              backgroundColor: primaryColor.withAlpha(20),
              labelStyle: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Colors.transparent),
              ),
            );
          }).toList(),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0);
  }
}
