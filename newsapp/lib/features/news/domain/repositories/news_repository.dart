import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/article_entity.dart';
import '../entities/news_source_entity.dart';

/// Repository for news-related operations only
/// Following Single Responsibility Principle
abstract class NewsRepository {
  Future<Either<Failure, List<ArticleEntity>>> getTopHeadlines();
  Future<Either<Failure, List<ArticleEntity>>> getNewsByCategory(String category);
  Future<Either<Failure, List<ArticleEntity>>> searchNews({
    required String query,
    String? from,
    String? to,
    String? sortBy,
  });
  Future<Either<Failure, List<ArticleEntity>>> getTrendingNews();
  Future<Either<Failure, List<NewsSourceEntity>>> getSources();
  Future<Either<Failure, List<ArticleEntity>>> getNewsByCountry(String country);
  Future<Either<Failure, List<ArticleEntity>>> getNewsByCategoryAndCountry({
    required String category,
    required String country,
  });
}
