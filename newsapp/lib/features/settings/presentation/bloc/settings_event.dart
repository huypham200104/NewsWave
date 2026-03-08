import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class ThemeChanged extends SettingsEvent {
  final bool isDarkMode;
  const ThemeChanged(this.isDarkMode);

  @override
  List<Object> get props => [isDarkMode];
}

class LanguageChanged extends SettingsEvent {
  final String languageCode;
  const LanguageChanged(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}

class NotificationsToggled extends SettingsEvent {
  final bool enabled;
  const NotificationsToggled(this.enabled);

  @override
  List<Object> get props => [enabled];
}
