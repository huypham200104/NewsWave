import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../news/presentation/pages/main_screen.dart';
import '../widgets/showcase_page.dart';
import '../widgets/topics_selection_page.dart';
import '../widgets/name_input_page.dart';

/// Main onboarding coordinator page
/// Manages the onboarding flow using PageView
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const int _showcasePageIndex = 0;
  static const Duration _autoAdvanceDelay = Duration(milliseconds: 2500);
  
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String? _userName;
  final List<String> _selectedTopics = [];
  
  static const List<String> _allTopics = [
    'Technology', 'Business', 'Sports', 'Entertainment',
    'Health', 'Science', 'Politics', 'Gaming', 'Travel', 'Food'
  ];

  @override
  void initState() {
    super.initState();
    _scheduleAutoAdvance();
  }

  /// Auto advance from showcase page to topics page
  void _scheduleAutoAdvance() {
    Future.delayed(_autoAdvanceDelay, () {
      if (mounted && _currentPage == _showcasePageIndex) {
        _navigateToNextPage();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Navigate to next page with animation
  void _navigateToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  /// Toggle topic selection
  void _toggleTopic(String topic) {
    setState(() {
      if (_selectedTopics.contains(topic)) {
        _selectedTopics.remove(topic);
      } else {
        _selectedTopics.add(topic);
      }
    });
  }

  /// Handle name input changes
  void _handleNameChanged(String value) {
    setState(() {
      _userName = value;
    });
  }

  /// Save onboarding data and navigate to main screen
  Future<void> _completeOnboarding() async {
    await _saveOnboardingData();
    if (mounted) {
      await _navigateToMainScreen();
    }
  }

  /// Save user preferences to SharedPreferences
  Future<void> _saveOnboardingData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_onboarding', true);
    
    if (_userName != null && _userName!.isNotEmpty) {
      await prefs.setString('user_name', _userName!);
    }
    
    if (_selectedTopics.isNotEmpty) {
      await prefs.setStringList('user_topics', _selectedTopics);
    }
  }

  /// Navigate to main screen with replacement
  Future<void> _navigateToMainScreen() async {
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: _handlePageChanged,
        children: [
          const ShowcasePage(),
          TopicsSelectionPage(
            allTopics: _allTopics,
            selectedTopics: _selectedTopics,
            onTopicToggled: _toggleTopic,
            onContinue: _navigateToNextPage,
          ),
          NameInputPage(
            onNameChanged: _handleNameChanged,
            onComplete: _completeOnboarding,
            onSkip: _completeOnboarding,
          ),
        ],
      ),
    );
  }

  /// Handle page change event
  void _handlePageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }
}
