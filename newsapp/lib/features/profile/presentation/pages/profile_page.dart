import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/profile_bloc.dart';
import '../bloc/profile_state.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../settings/presentation/bloc/settings_state.dart';
import '../widgets/profile/profile_body.dart';
import '../../../../core/localization/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        String userName = 'Reader';
        List<String> userTopics = [];

        if (profileState is ProfileLoaded) {
          userName = profileState.profile.userName;
          userTopics = profileState.profile.topics;
        }

        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            bool isDark = Theme.of(context).brightness == Brightness.dark;
            String languageText = 'English';
            String appearanceText = context.tr('system');
            bool notificationsEnabled = true;

            if (settingsState is SettingsLoaded) {
              isDark = settingsState.settings.isDarkMode;
              languageText = settingsState.settings.languageCode == 'vi' ? 'Tiếng Việt' : 'English';
              appearanceText = isDark ? context.tr('dark_mode') : context.tr('light_mode');
              notificationsEnabled = settingsState.settings.notificationsEnabled;
            }

            return Scaffold(
              appBar: AppBar(
                title: Text(context.tr('profile')),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: ProfileBody(
                userName: userName,
                userTopics: userTopics,
                isDark: isDark,
                languageText: languageText,
                appearanceText: appearanceText,
                notificationsEnabled: notificationsEnabled,
              ),
            );
          },
        );
      },
    );
  }
}
