import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../../../news/domain/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

@lazySingleton
class GetUserProfile implements UseCase<UserProfile, NoParams> {
  final ProfileRepository repository;

  GetUserProfile(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(NoParams params) async {
    return await repository.getUserProfile();
  }
}
