import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../../../news/domain/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

@lazySingleton
class UpdateUserProfile implements UseCase<void, UserProfile> {
  final ProfileRepository repository;

  UpdateUserProfile(this.repository);

  @override
  Future<Either<Failure, void>> call(UserProfile profile) async {
    return await repository.updateUserProfile(profile);
  }
}
