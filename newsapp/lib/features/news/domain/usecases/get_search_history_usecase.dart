import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../repositories/search_history_repository.dart';
import 'usecase.dart';

@lazySingleton
class GetSearchHistoryUseCase implements UseCase<List<String>, NoParams> {
  final SearchHistoryRepository repository;

  GetSearchHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getSearchHistory();
  }
}
