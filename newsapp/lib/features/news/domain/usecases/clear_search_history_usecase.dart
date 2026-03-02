import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../repositories/news_repository.dart';
import 'usecase.dart';

@lazySingleton
class ClearSearchHistoryUseCase implements UseCase<void, NoParams> {
  final NewsRepository repository;

  ClearSearchHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.clearSearchHistory();
  }
}
