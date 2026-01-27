import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/news/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo Hive
  await Hive.initFlutter();
  
  runApp(const NewsWaveApp());
}

class NewsWaveApp extends StatelessWidget {
  const NewsWaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Ẩn banner DEBUG
      title: 'News Wave',
      theme: AppTheme.light, // Theme sáng
      darkTheme: AppTheme.dark, // Theme tối
      themeMode: ThemeMode.system, // Tự động theo hệ thống
      home: const HomePage(),
    );
  }
}