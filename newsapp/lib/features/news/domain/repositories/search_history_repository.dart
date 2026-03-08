import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';

abstract class SearchHistoryRepository {
  Future<Either<Failure, List<String>>> getSearchHistory();
  Future<Either<Failure, void>> saveSearchHistory(String query);
  Future<Either<Failure, void>> clearSearchHistory();
}
