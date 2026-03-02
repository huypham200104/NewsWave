import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../entities/article_entity.dart';
import '../repositories/news_repository.dart';
import 'usecase.dart';

class SearchParams {
  final String query;
  final String? from;
  final String? to;
  final String? sortBy;

  SearchParams({
    required this.query,
    this.from,
    this.to,
    this.sortBy,
  });
}

@lazySingleton
class SearchNewsUseCase implements UseCase<List<ArticleEntity>, SearchParams> {
  final NewsRepository repository;

  SearchNewsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ArticleEntity>>> call(SearchParams params) {
    return repository.searchNews(
      query: params.query,
      from: params.from,
      to: params.to,
      sortBy: params.sortBy,
    );
  }
}
