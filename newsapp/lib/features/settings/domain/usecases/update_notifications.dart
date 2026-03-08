import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../repositories/settings_repository.dart';
import 'usecase.dart';

@lazySingleton
class UpdateNotifications implements UseCase<void, bool> {
  final SettingsRepository repository;

  UpdateNotifications(this.repository);

  @override
  Future<Either<Failure, void>> call(bool enabled) async {
    return await repository.updateNotifications(enabled);
  }
}
