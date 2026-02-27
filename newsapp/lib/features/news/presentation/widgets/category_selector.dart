import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CategorySelector extends StatefulWidget {
  const CategorySelector({super.key});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final List<String> categories = ['For You', 'World', 'Tech', 'Business', 'Sports'];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(categories[index]),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  selectedIndex = index;
                });
              },
              selectedColor: isDark ? AppColors.accentBlue : AppColors.primaryBlue,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: BorderSide.none,
              backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            ),
          );
        },
      ),
    );
  }
}

