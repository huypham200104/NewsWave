import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../bloc/news_bloc.dart';

class CategorySelector extends StatefulWidget {
  const CategorySelector({super.key});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final List<String> categories = ['For You', 'World', 'Tech', 'Business', 'Sports'];
  int selectedIndex = 0;
  List<String> _userTopics = [];

  @override
  void initState() {
    super.initState();
    _loadUserTopics();
  }

  Future<void> _loadUserTopics() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _userTopics = prefs.getStringList('user_topics') ?? [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 44, // Slightly smaller height for a sleeker look
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                
                final bloc = context.read<NewsBloc>();
                if (index == 0) {
                  bloc.add(GetTopHeadlinesEvent(topics: _userTopics));
                } else {
                  bloc.add(GetNewsByCategoryEvent(categories[index].toLowerCase()));
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected 
                      ? (isDark ? AppColors.accentBlue : AppColors.primaryBlue) 
                      : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [], // Shadow removed as requested
                  border: Border.all(
                    color: isSelected 
                        ? Colors.transparent 
                        : (isDark ? Colors.white12 : Colors.black12),
                    width: 1,
                  ),
                ),
                child: Text(
                  categories[index],
                  style: TextStyle(
                    color: isSelected 
                        ? Colors.white 
                        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

