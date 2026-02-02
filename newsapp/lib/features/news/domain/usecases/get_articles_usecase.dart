import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/article_entity.dart';
import '../repositories/news_repository.dart';
import 'usecase.dart';

class GetArticlesUseCase implements UseCase<List<ArticleEntity>, NoParams> {
  final NewsRepository repository;

  GetArticlesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ArticleEntity>>> call(NoParams params) {
    return repository.getTopHeadlines();
  }
}
