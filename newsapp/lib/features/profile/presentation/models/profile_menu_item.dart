import 'package:flutter/material.dart';

class ProfileMenuItem {
  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;
  final bool showTrailing;

  ProfileMenuItem({
    required this.icon,
    required this.title,
    this.trailing,
    required this.onTap,
    this.textColor,
    this.iconColor,
    this.showTrailing = true,
  });
}
