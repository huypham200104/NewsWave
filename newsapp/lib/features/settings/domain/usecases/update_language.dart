import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../repositories/settings_repository.dart';
import 'usecase.dart';

@lazySingleton
class UpdateLanguage implements UseCase<void, String> {
  final SettingsRepository repository;

  UpdateLanguage(this.repository);

  @override
  Future<Either<Failure, void>> call(String languageCode) async {
    return await repository.updateLanguage(languageCode);
  }
}
