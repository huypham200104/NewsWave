import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../settings/presentation/bloc/settings_event.dart';
import '../../../../settings/presentation/bloc/settings_state.dart';

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
              BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  final isDarkMode = state is SettingsLoaded ? state.settings.isDarkMode : false;
                  return IconButton(
                    icon: Icon(
                      !isDarkMode
                          ? Icons.wb_sunny_outlined
                          : Icons.nightlight_round_outlined,
                      color: !isDarkMode
                          ? Colors.orange
                          : AppColors.accentBlue,
                    ),
                    onPressed: () {
                      context.read<SettingsBloc>().add(ThemeChanged(!isDarkMode));
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
