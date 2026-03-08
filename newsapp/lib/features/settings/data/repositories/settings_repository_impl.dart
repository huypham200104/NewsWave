import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, AppSettings>> getSettings() async {
    try {
      final settings = await localDataSource.getSettings();
      return Right(settings);
    } on CacheException {
      return const Left(CacheFailure('Cache Failure'));
    } catch (e) {
      return const Left(CacheFailure('Unknown Failure'));
    }
  }

  @override
  Future<Either<Failure, void>> updateTheme(bool isDarkMode) async {
    try {
      await localDataSource.cacheTheme(isDarkMode);
      return const Right(null);
    } on CacheException {
      return const Left(CacheFailure('Cache Failure'));
    } catch (e) {
      return const Left(CacheFailure('Unknown Failure'));
    }
  }

  @override
  Future<Either<Failure, void>> updateLanguage(String languageCode) async {
    try {
      await localDataSource.cacheLanguage(languageCode);
      return const Right(null);
    } on CacheException {
      return const Left(CacheFailure('Cache Failure'));
    } catch (e) {
      return const Left(CacheFailure('Unknown Failure'));
    }
  }

  @override
  Future<Either<Failure, void>> updateNotifications(bool enabled) async {
    try {
      await localDataSource.cacheNotifications(enabled);
      return const Right(null);
    } on CacheException {
      return const Left(CacheFailure('Cache Failure'));
    } catch (e) {
      return const Left(CacheFailure('Unknown Failure'));
    }
  }
}
