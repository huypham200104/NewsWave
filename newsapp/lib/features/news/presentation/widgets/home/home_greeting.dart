import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/theme/app_colors.dart';
import 'category_selector.dart';
import 'news_search_bar.dart';

class HomeGreeting extends StatefulWidget {
  const HomeGreeting({super.key});

  @override
  State<HomeGreeting> createState() => _HomeGreetingState();
}

class _HomeGreetingState extends State<HomeGreeting> {
  String _userName = 'Reader'; // Fallback name

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Reader';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Hello $_userName',
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
