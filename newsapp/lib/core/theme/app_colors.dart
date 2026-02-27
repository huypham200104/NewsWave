import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors (Deep Blue chuyên nghiệp như trong ảnh)
  static const Color primaryBlue = Color(0xFF1A237E); 
  static const Color accentBlue = Color(0xFF2196F3);

  // Light Mode Palette
  static const Color bgLight = Color(0xFFFFFFFF); // Trắng tinh khiết cho cảm giác minimalist
  static const Color surfaceLight = Color(0xFFF8F9FA); // Màu cho các card bài báo
  static const Color textPrimaryLight = Color(0xFF121212);
  static const Color textSecondaryLight = Color(0xFF616161);

  // Dark Mode Palette (Sử dụng Deep Grey/Navy thay vì đen thuần)
  static const Color bgDark = Color(0xFF121212); 
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Color(0xFFECEFF1);
  static const Color textSecondaryDark = Color(0xFFB0BEC5);

  // Pastel Colors cho Category Chips (như trong giao diện bạn yêu cầu)
  static const Color chipTech = Color(0xFFE3F2FD);
  static const Color chipBusiness = Color(0xFFF3E5F5);
}