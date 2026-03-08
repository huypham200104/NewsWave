import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

class AppearanceBottomSheet extends StatelessWidget {
  const AppearanceBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        bool isDarkMode = false;
        if (state is SettingsLoaded) {
          isDarkMode = state.settings.isDarkMode;
        }

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Appearance',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _AppearanceOption(
                title: 'Light Mode',
                icon: Icons.light_mode_outlined,
                isSelected: !isDarkMode,
                onTap: () {
                  context.read<SettingsBloc>().add(const ThemeChanged(false));
                  Navigator.pop(context);
                },
              ),
              _AppearanceOption(
                title: 'Dark Mode',
                icon: Icons.dark_mode_outlined,
                isSelected: isDarkMode,
                onTap: () {
                  context.read<SettingsBloc>().add(const ThemeChanged(true));
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

class _AppearanceOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _AppearanceOption({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: TextStyle(
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      )),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
      onTap: onTap,
    );
  }
}
