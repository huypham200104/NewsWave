import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/app_settings.dart';

abstract class SettingsRepository {
  Future<Either<Failure, AppSettings>> getSettings();
  Future<Either<Failure, void>> updateTheme(bool isDarkMode);
  Future<Either<Failure, void>> updateLanguage(String languageCode);
  Future<Either<Failure, void>> updateNotifications(bool enabled);
}
