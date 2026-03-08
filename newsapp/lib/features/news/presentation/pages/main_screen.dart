import 'package:flutter/material.dart';
import 'home_page.dart';
import 'discover_page.dart';
import 'bookmarks_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../widgets/common/news_bottom_navigation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    DiscoverPage(),
    BookmarksPage(),
    ProfilePage(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NewsBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
