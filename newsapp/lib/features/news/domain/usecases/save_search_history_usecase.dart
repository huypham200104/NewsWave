import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../repositories/news_repository.dart';
import 'usecase.dart';

@lazySingleton
class SaveSearchHistoryUseCase implements UseCase<void, String> {
  final NewsRepository repository;

  SaveSearchHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String query) {
    return repository.saveSearchHistory(query);
  }
}
