import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../entities/article_entity.dart';
import '../repositories/news_repository.dart';
import 'usecase.dart';

@lazySingleton
class GetNewsByCategoryUseCase implements UseCase<List<ArticleEntity>, String> {
  final NewsRepository repository;

  GetNewsByCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<ArticleEntity>>> call(String category) {
    return repository.getNewsByCategory(category);
  }
}
