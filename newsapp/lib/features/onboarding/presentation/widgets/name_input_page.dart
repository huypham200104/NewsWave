import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

/// Third onboarding page for name input
class NameInputPage extends StatelessWidget {
  final ValueChanged<String> onNameChanged;
  final VoidCallback onComplete;
  final VoidCallback onSkip;

  const NameInputPage({
    super.key,
    required this.onNameChanged,
    required this.onComplete,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: onSkip,
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 500.ms),
            const SizedBox(height: 20),
            Text(
              'What should we call you?',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.2, end: 0),
            const SizedBox(height: 48),
            TextField(
              onChanged: onNameChanged,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
              decoration: InputDecoration(
                hintText: 'Your name',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
                ),
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onComplete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Start Reading',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ).animate().scale(delay: 400.ms),
          ],
        ),
      ),
    );
  }
}
