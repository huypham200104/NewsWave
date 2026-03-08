import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final bool isDarkMode;
  final String languageCode;
  final bool notificationsEnabled;

  const AppSettings({
    required this.isDarkMode,
    required this.languageCode,
    required this.notificationsEnabled,
  });

  AppSettings copyWith({
    bool? isDarkMode,
    String? languageCode,
    bool? notificationsEnabled,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      languageCode: languageCode ?? this.languageCode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  List<Object?> get props => [isDarkMode, languageCode, notificationsEnabled];
}
