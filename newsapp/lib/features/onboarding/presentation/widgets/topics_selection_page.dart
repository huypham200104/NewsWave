import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import 'topic_chip.dart';

/// Second onboarding page for topic selection
class TopicsSelectionPage extends StatelessWidget {
  final List<String> allTopics;
  final List<String> selectedTopics;
  final ValueChanged<String> onTopicToggled;
  final VoidCallback onContinue;

  const TopicsSelectionPage({
    super.key,
    required this.allTopics,
    required this.selectedTopics,
    required this.onTopicToggled,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canContinue = selectedTopics.length >= 3;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              'Pick your interests',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.2, end: 0),
            const SizedBox(height: 12),
            Text(
              'Choose 3 or more topics you care about.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 500.ms).slideX(begin: -0.2, end: 0),
            const SizedBox(height: 32),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 12.0,
                  runSpacing: 16.0,
                  children: allTopics.asMap().entries.map((entry) {
                    final index = entry.key;
                    final topic = entry.value;
                    final isSelected = selectedTopics.contains(topic);
                    
                    return TopicChip(
                      topic: topic,
                      isSelected: isSelected,
                      onTap: () => onTopicToggled(topic),
                      animationDelay: 300 + (index * 50),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: canContinue ? onContinue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ).animate().fadeIn(delay: 800.ms),
            ),
          ],
        ),
      ),
    );
  }
}
