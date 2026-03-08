import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    try {
      final profile = await localDataSource.getUserProfile();
      return Right(profile);
    } on CacheException {
      return const Left(CacheFailure('Cache Failure'));
    } catch (e) {
      return const Left(CacheFailure('Unknown Failure'));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfile(UserProfile profile) async {
    try {
      await localDataSource.cacheUserProfile(profile);
      return const Right(null);
    } on CacheException {
      return const Left(CacheFailure('Cache Failure'));
    } catch (e) {
      return const Left(CacheFailure('Unknown Failure'));
    }
  }
}
