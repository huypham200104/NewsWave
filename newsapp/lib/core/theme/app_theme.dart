import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  // Tên family phải trùng khớp với khai báo trong pubspec.yaml
  static const String _fontFamily = 'Inter';

  // --- LIGHT THEME ---
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        // 1. Áp dụng font family toàn cục
        fontFamily: _fontFamily, 
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBlue,
          primary: AppColors.primaryBlue,
          surface: AppColors.surfaceLight,
        ),
        // Typography: Cập nhật style để tận dụng độ dày của font Variable
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.w700, // Bold cho tiêu đề
            color: AppColors.textPrimaryLight,
            letterSpacing: -0.5, // Inter trông đẹp hơn khi khép sát một chút
          ),
          bodyLarge: TextStyle(
            fontWeight: FontWeight.w400, // Regular cho nội dung
            color: AppColors.textPrimaryLight,
          ),
          labelLarge: TextStyle(
            fontWeight: FontWeight.w600, // Semi-bold cho các nút/chip
          ),
        ),
        // Card: Bo góc lớn (16-24) và shadow cực nhẹ
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0.5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        // Chip: Style tối giản cho category
        chipTheme: const ChipThemeData(
          backgroundColor: AppColors.surfaceLight,
          side: BorderSide.none,
          shape: StadiumBorder(),
          labelStyle: TextStyle(
            fontSize: 12, 
            fontWeight: FontWeight.w500,
            fontFamily: _fontFamily, // Đảm bảo chip cũng dùng font này
          ),
        ),
        // Search Bar
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceLight,
          hintStyle: const TextStyle(fontFamily: _fontFamily),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      );

  // --- DARK THEME ---
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        // 1. Áp dụng font family toàn cục
        fontFamily: _fontFamily,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accentBlue,
          surface: AppColors.surfaceDark,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
          bodyLarge: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.white70,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.surfaceDark,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        chipTheme: const ChipThemeData(
          backgroundColor: Color(0xFF2C2C2C),
          side: BorderSide.none,
          shape: StadiumBorder(),
          labelStyle: TextStyle(fontFamily: _fontFamily),
        ),
      );
}