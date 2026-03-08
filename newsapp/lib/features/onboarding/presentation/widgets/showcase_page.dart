import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

/// First onboarding page showing app branding
class ShowcasePage extends StatelessWidget {
  const ShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryBlue,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.newspaper, size: 100, color: Colors.white)
                .animate()
                .scale(duration: 800.ms, curve: Curves.easeOutBack)
                .then(delay: 200.ms)
                .shimmer(duration: 1000.ms, color: Colors.white54),
            const SizedBox(height: 24),
            const Text(
              'NewsWave',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2.0,
              ),
            ).animate().fadeIn(delay: 500.ms, duration: 800.ms).slideY(begin: 0.5, end: 0),
            const SizedBox(height: 16),
            const Text(
              'Your News, Your Way',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ).animate().fadeIn(delay: 1000.ms, duration: 800.ms).slideY(begin: 0.5, end: 0),
          ],
        ),
      ),
    );
  }
}
