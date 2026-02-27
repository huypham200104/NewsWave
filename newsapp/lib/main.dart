import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // <--- THÊM DÒNG NÀY
import 'core/theme/app_theme.dart';
import 'core/theme/theme_bloc.dart';
import 'features/news/presentation/pages/home_page.dart';

import 'injection_container.dart';

// QUAN TRỌNG: Chỉ import file news_bloc.dart vì nó chứa cả Event
import 'features/news/presentation/bloc/news_bloc.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // <--- THÊM DÒNG NÀY
  await configureDependencies();
  runApp(const NewsWaveApp());
}

class NewsWaveApp extends StatelessWidget {
  const NewsWaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (_) => getIt<ThemeBloc>(),
        ),
        BlocProvider<NewsBloc>(
          create: (_) => getIt<NewsBloc>()..add(GetTopHeadlinesEvent()), 
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'News Wave',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            home: const HomePage(),
          );
        },
      ),
    );

  }
}