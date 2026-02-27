import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'category_selector.dart';
import 'news_search_bar.dart';

class HomeGreeting extends StatelessWidget {
  const HomeGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Hello Huy',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
        ),
        const NewsSearchBar(),
        const CategorySelector(),
        const SizedBox(height: 16),
      ],
    );
  }
}
