import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../repositories/settings_repository.dart';
import 'usecase.dart';

@lazySingleton
class UpdateTheme implements UseCase<void, bool> {
  final SettingsRepository repository;

  UpdateTheme(this.repository);

  @override
  Future<Either<Failure, void>> call(bool isDarkMode) async {
    return await repository.updateTheme(isDarkMode);
  }
}
