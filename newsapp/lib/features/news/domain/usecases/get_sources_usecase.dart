import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../entities/news_source_entity.dart';
import '../repositories/news_repository.dart';
import 'usecase.dart';

@lazySingleton
class GetSourcesUseCase implements UseCase<List<NewsSourceEntity>, NoParams> {
  final NewsRepository repository;

  GetSourcesUseCase(this.repository);

  @override
  Future<Either<Failure, List<NewsSourceEntity>>> call(NoParams params) {
    return repository.getSources();
  }
}
