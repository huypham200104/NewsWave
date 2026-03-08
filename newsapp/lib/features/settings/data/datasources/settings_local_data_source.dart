import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/app_settings.dart';

abstract class SettingsLocalDataSource {
  Future<AppSettings> getSettings();
  Future<void> cacheTheme(bool isDarkMode);
  Future<void> cacheLanguage(String languageCode);
  Future<void> cacheNotifications(bool enabled);
}

const cachedTheme = 'CACHED_THEME';
const cachedLanguage = 'CACHED_LANGUAGE';
const cachedNotifications = 'CACHED_NOTIFICATIONS';

@LazySingleton(as: SettingsLocalDataSource)
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<AppSettings> getSettings() async {
    final isDarkMode = sharedPreferences.getBool(cachedTheme) ?? false;
    final languageCode = sharedPreferences.getString(cachedLanguage) ?? 'en';
    final notificationsEnabled = sharedPreferences.getBool(cachedNotifications) ?? true;

    return AppSettings(
      isDarkMode: isDarkMode,
      languageCode: languageCode,
      notificationsEnabled: notificationsEnabled,
    );
  }

  @override
  Future<void> cacheTheme(bool isDarkMode) {
    return sharedPreferences.setBool(cachedTheme, isDarkMode);
  }

  @override
  Future<void> cacheLanguage(String languageCode) {
    return sharedPreferences.setString(cachedLanguage, languageCode);
  }

  @override
  Future<void> cacheNotifications(bool enabled) {
    return sharedPreferences.setBool(cachedNotifications, enabled);
  }
}
