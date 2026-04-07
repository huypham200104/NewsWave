import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // <--- THÊM DÒNG NÀY
import 'core/theme/app_theme.dart';
import 'core/theme/theme_bloc.dart';
import 'features/news/presentation/pages/main_screen.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // <--- THÊM DÒNG NÀY
import 'core/localization/app_localizations.dart'; // <--- THÊM DÒNG NÀY

import 'injection_container.dart';

// QUAN TRỌNG: Chỉ import file news_bloc.dart vì nó chứa cả Event
import 'features/news/presentation/bloc/news_bloc.dart'; 
import 'features/news/presentation/bloc/bookmark/bookmark_bloc.dart';
import 'features/news/presentation/bloc/bookmark/bookmark_event.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/presentation/bloc/settings_event.dart';
import 'features/settings/presentation/bloc/settings_state.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/profile/presentation/bloc/profile_event.dart';

import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  await configureDependencies();

  final prefs = await SharedPreferences.getInstance();
  final hasCompletedOnboarding = prefs.getBool('has_completed_onboarding') ?? false;
  final userTopics = prefs.getStringList('user_topics') ?? [];

  runApp(NewsWaveApp(
    showOnboarding: !hasCompletedOnboarding,
    userTopics: userTopics,
  ));
}

class NewsWaveApp extends StatelessWidget {
  final bool showOnboarding;
  final List<String> userTopics;

  const NewsWaveApp({
    super.key, 
    required this.showOnboarding,
    this.userTopics = const [],
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (_) => getIt<ThemeBloc>(),
        ),
        BlocProvider<NewsBloc>(
          create: (_) => getIt<NewsBloc>()..add(GetTopHeadlinesEvent(topics: userTopics)), 
        ),
        BlocProvider<BookmarkBloc>(
          create: (_) => getIt<BookmarkBloc>()..add(LoadBookmarksEvent()),
        ),
        BlocProvider<SettingsBloc>(
          create: (_) => getIt<SettingsBloc>()..add(LoadSettings()),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => getIt<ProfileBloc>()..add(LoadProfile()),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final isDarkMode = state is SettingsLoaded ? state.settings.isDarkMode : false;
          final languageCode = state is SettingsLoaded ? state.settings.languageCode : 'en';
          final themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'News Wave',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            locale: Locale(languageCode),
            supportedLocales: const [
              Locale('en', ''),
              Locale('vi', ''),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: showOnboarding ? const OnboardingPage() : const MainScreen(),
          );
        },
      ),
    );

  }
}