import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../../domain/repositories/search_history_repository.dart';
import '../datasources/search_history_local_datasource.dart';

@LazySingleton(as: SearchHistoryRepository)
class SearchHistoryRepositoryImpl implements SearchHistoryRepository {
  final SearchHistoryLocalDataSource localDataSource;

  SearchHistoryRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<String>>> getSearchHistory() async {
    try {
      final history = await localDataSource.getSearchHistory();
      return Right(history);
    } catch (e) {
      return const Left(CacheFailure('Cannot read search history'));
    }
  }

  @override
  Future<Either<Failure, void>> saveSearchHistory(String query) async {
    try {
      await localDataSource.saveSearchHistory(query);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Cannot save search history'));
    }
  }

  @override
  Future<Either<Failure, void>> clearSearchHistory() async {
    try {
      await localDataSource.clearSearchHistory();
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Cannot clear search history'));
    }
  }
}
