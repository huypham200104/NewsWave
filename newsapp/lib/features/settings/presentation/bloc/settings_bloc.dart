import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_settings.dart';
import '../../domain/usecases/update_theme.dart';
import '../../domain/usecases/update_language.dart';
import '../../domain/usecases/update_notifications.dart';
import '../../domain/usecases/usecase.dart';
import 'settings_event.dart';
import 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettings getSettings;
  final UpdateTheme updateThemeUseCase;
  final UpdateLanguage updateLanguageUseCase;
  final UpdateNotifications updateNotificationsUseCase;

  SettingsBloc({
    required this.getSettings,
    required this.updateThemeUseCase,
    required this.updateLanguageUseCase,
    required this.updateNotificationsUseCase,
  }) : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<ThemeChanged>(_onThemeChanged);
    on<LanguageChanged>(_onLanguageChanged);
    on<NotificationsToggled>(_onNotificationsToggled);
  }

  Future<void> _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    final result = await getSettings(NoParams());
    result.fold(
      (failure) => emit(const SettingsError('Failed to load settings')),
      (settings) => emit(SettingsLoaded(settings)),
    );
  }

  Future<void> _onThemeChanged(ThemeChanged event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final newSettings = currentSettings.copyWith(isDarkMode: event.isDarkMode);
      
      emit(SettingsLoaded(newSettings)); // Optimitic update
      
      final result = await updateThemeUseCase(event.isDarkMode);
      result.fold(
        (failure) {
          emit(const SettingsError('Failed to update theme'));
          emit(SettingsLoaded(currentSettings)); // Revert on failure
        },
        (_) {},
      );
    }
  }

  Future<void> _onLanguageChanged(LanguageChanged event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final newSettings = currentSettings.copyWith(languageCode: event.languageCode);
      
      emit(SettingsLoaded(newSettings));
      
      final result = await updateLanguageUseCase(event.languageCode);
      result.fold(
        (failure) {
          emit(const SettingsError('Failed to update language'));
          emit(SettingsLoaded(currentSettings));
        },
        (_) {},
      );
    }
  }

  Future<void> _onNotificationsToggled(NotificationsToggled event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final newSettings = currentSettings.copyWith(notificationsEnabled: event.enabled);
      
      emit(SettingsLoaded(newSettings));
      
      final result = await updateNotificationsUseCase(event.enabled);
      result.fold(
        (failure) {
          emit(const SettingsError('Failed to update notifications'));
          emit(SettingsLoaded(currentSettings));
        },
        (_) {},
      );
    }
  }
}
