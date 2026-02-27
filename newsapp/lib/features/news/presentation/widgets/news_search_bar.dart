import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class NewsSearchBar extends StatelessWidget {
  const NewsSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search news, topics...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          filled: true,
          fillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

