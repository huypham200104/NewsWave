import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../../../../core/localization/app_localizations.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        String currentLanguage = 'en';
        if (state is SettingsLoaded) {
          currentLanguage = state.settings.languageCode;
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
              Text(
                context.tr('select_language'),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _LanguageOption(
                title: 'English',
                code: 'en',
                isSelected: currentLanguage == 'en',
                onTap: () {
                  context.read<SettingsBloc>().add(const LanguageChanged('en'));
                  Navigator.pop(context);
                },
              ),
              _LanguageOption(
                title: 'Tiếng Việt',
                code: 'vi',
                isSelected: currentLanguage == 'vi',
                onTap: () {
                  context.read<SettingsBloc>().add(const LanguageChanged('vi'));
                  Navigator.pop(context);
                },
              ),
              // Add more languages as needed
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String title;
  final String code;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.title,
    required this.code,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: TextStyle(
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      )),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
      onTap: onTap,
    );
  }
}
