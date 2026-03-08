import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/theme/app_colors.dart';

class ProfileInfoSection extends StatelessWidget {
  final String userName;
  final bool isDark;

  const ProfileInfoSection({
    super.key,
    required this.userName,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          userName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 4),
        Text(
          'NewsWave Explorer',
          style: TextStyle(
            fontSize: 16,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ).animate().fadeIn(delay: 300.ms),
      ],
    );
  }
}
