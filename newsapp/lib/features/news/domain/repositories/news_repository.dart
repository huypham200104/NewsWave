import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/article_entity.dart';
import '../entities/news_source_entity.dart';

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

  // Search History
  Future<Either<Failure, List<String>>> getSearchHistory();
  Future<Either<Failure, void>> saveSearchHistory(String query);
  Future<Either<Failure, void>> clearSearchHistory();

  // Bookmarks
  Future<Either<Failure, void>> saveBookmark(ArticleEntity article);
  Future<Either<Failure, void>> removeBookmark(String url);
  Future<Either<Failure, List<ArticleEntity>>> getBookmarks();
  Future<Either<Failure, bool>> checkBookmark(String url);
}
