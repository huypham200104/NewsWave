import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../models/profile_menu_item.dart';

class ProfileMenuSection extends StatelessWidget {
  final String title;
  final List<ProfileMenuItem> items;
  final bool isDark;
  final int animationDelay;

  const ProfileMenuSection({
    super.key,
    required this.title,
    required this.items,
    required this.isDark,
    this.animationDelay = 500,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isDark ? [] : [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;

              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (item.iconColor ?? primaryColor).withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        item.icon,
                        color: item.iconColor ?? primaryColor,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: item.textColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                      ),
                    ),
                    trailing: item.showTrailing
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (item.trailing != null)
                                Text(
                                  item.trailing!,
                                  style: TextStyle(
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  ),
                                ),
                              const SizedBox(width: 8),
                              Icon(Icons.chevron_right, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                            ],
                          )
                        : null,
                    onTap: item.onTap,
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      thickness: 1,
                      indent: 56,
                      color: isDark ? Colors.white10 : Colors.black12,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    ).animate().fadeIn(delay: animationDelay.ms).slideX(begin: 0.2, end: 0);
  }
}
