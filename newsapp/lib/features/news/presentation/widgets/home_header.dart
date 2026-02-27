import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_bloc.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'NewsWave',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
              color: isDark ? AppColors.textPrimaryDark : AppColors.primaryBlue,
            ),
          ),
          Row(
            children: [
              BlocBuilder<ThemeBloc, ThemeMode>(
                builder: (context, mode) {
                  return IconButton(
                    icon: Icon(
                      mode == ThemeMode.light
                          ? Icons.wb_sunny_outlined
                          : Icons.nightlight_round_outlined,
                      color: mode == ThemeMode.light
                          ? Colors.orange
                          : AppColors.accentBlue,
                    ),
                    onPressed: () {
                      context.read<ThemeBloc>().add(ThemeEvent.toggle);
                    },
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.notifications_none,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
