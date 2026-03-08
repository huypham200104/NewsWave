import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';
import 'usecase.dart';

@lazySingleton
class GetSettings implements UseCase<AppSettings, NoParams> {
  final SettingsRepository repository;

  GetSettings(this.repository);

  @override
  Future<Either<Failure, AppSettings>> call(NoParams params) async {
    return await repository.getSettings();
  }
}
