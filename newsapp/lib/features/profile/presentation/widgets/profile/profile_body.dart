import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../onboarding/presentation/pages/onboarding_page.dart';
import 'profile_avatar_section.dart';
import 'profile_info_section.dart';
import 'profile_interests_section.dart';
import 'profile_menu_section.dart';
import '../../models/profile_menu_item.dart';
import '../../pages/edit_profile_page.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../settings/presentation/bloc/settings_event.dart';
import '../../../../settings/presentation/widgets/language_bottom_sheet.dart';
import '../../../../settings/presentation/widgets/appearance_bottom_sheet.dart';

class ProfileBody extends StatelessWidget {
  final String userName;
  final List<String> userTopics;
  final bool isDark;
  final String languageText;
  final String appearanceText;
  final bool notificationsEnabled;

  const ProfileBody({
    super.key,
    required this.userName,
    required this.userTopics,
    required this.isDark,
    required this.languageText,
    required this.appearanceText,
    required this.notificationsEnabled,
  });

  Future<void> _resetOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_onboarding', false);
    if (context.mounted) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingPage()),
      );
    }
  }

  void _showLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const LanguageBottomSheet(),
    );
  }

  void _showAppearanceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const AppearanceBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            
            // Avatar Section
            ProfileAvatarSection(userName: userName),
            
            const SizedBox(height: 16),
            
            // User Info Section
            ProfileInfoSection(userName: userName, isDark: isDark),
            
            const SizedBox(height: 32),

            // Interests Section
            ProfileInterestsSection(topics: userTopics, isDark: isDark),
            
            if (userTopics.isNotEmpty) const SizedBox(height: 32),

            // Settings Menu
            ProfileMenuSection(
              title: 'Settings',
              isDark: isDark,
              animationDelay: 500,
              items: [
                ProfileMenuItem(
                  icon: notificationsEnabled ? Icons.notifications_active_outlined : Icons.notifications_off_outlined,
                  title: 'Notifications',
                  trailing: notificationsEnabled ? 'On' : 'Off',
                  onTap: () {
                    context.read<SettingsBloc>().add(NotificationsToggled(!notificationsEnabled));
                  },
                ),
                ProfileMenuItem(
                  icon: Icons.language_outlined,
                  title: 'Language',
                  trailing: languageText,
                  onTap: () => _showLanguageSheet(context),
                ),
                ProfileMenuItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Appearance',
                  trailing: appearanceText,
                  onTap: () => _showAppearanceSheet(context),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Account Menu
            ProfileMenuSection(
              title: 'Account',
              isDark: isDark,
              animationDelay: 600,
              items: [
                ProfileMenuItem(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfilePage()),
                    );
                  },
                ),
                ProfileMenuItem(
                  icon: Icons.settings_backup_restore,
                  title: 'Reset Onboarding Flow',
                  onTap: () => _resetOnboarding(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
