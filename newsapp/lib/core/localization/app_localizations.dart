import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'News Wave',
      'profile': 'Profile',
      'settings': 'Settings',
      'language': 'Language',
      'appearance': 'Appearance',
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',
      'system': 'System',
      'edit_profile': 'Edit Profile',
      'reset_onboarding_flow': 'Reset Onboarding Flow',
      'account': 'Account',
      'for_you': 'For You',
      'world': 'World',
      'notifications': 'Notifications',
      'on': 'On',
      'off': 'Off',
      'select_language': 'Select Language',
    },
    'vi': {
      'app_name': 'News Wave',
      'profile': 'Hồ sơ',
      'settings': 'Cài đặt',
      'language': 'Ngôn ngữ',
      'appearance': 'Giao diện',
      'dark_mode': 'Chế độ tối',
      'light_mode': 'Chế độ sáng',
      'system': 'Hệ thống',
      'edit_profile': 'Chỉnh sửa hồ sơ',
      'reset_onboarding_flow': 'Thiết lập lại khởi động',
      'account': 'Tài khoản',
      'for_you': 'Dành cho bạn',
      'world': 'Thế giới',
      'notifications': 'Thông báo',
      'on': 'Bật',
      'off': 'Tắt',
      'select_language': 'Chọn ngôn ngữ',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'vi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationsExtension on BuildContext {
  String tr(String key) => AppLocalizations.of(this)?.translate(key) ?? key;
}