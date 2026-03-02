import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/article_entity.dart';
import '../../domain/entities/news_source_entity.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_data_source.dart';
import '../datasources/news_local_datasource.dart';

import 'package:flutter/foundation.dart';
import '../models/news_response_model.dart';
import '../models/article_model.dart';
@LazySingleton(as: NewsRepository)
class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;
  final InternetConnectionChecker connectionChecker;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, List<ArticleEntity>>> getTopHeadlines() async {
    return _getNews(() => remoteDataSource.getTopHeadlines(
          apiKey: dotenv.env['NEWS_API_KEY'] ?? '',
        ));
  }

  @override
  Future<Either<Failure, List<ArticleEntity>>> getNewsByCategory(
      String category) async {
    return _getNews(() => remoteDataSource.getNewsByCategory(
          category: category,
          apiKey: dotenv.env['NEWS_API_KEY'] ?? '',
        ));
  }

  @override
  Future<Either<Failure, List<ArticleEntity>>> searchNews({
    required String query,
    String? from,
    String? to,
    String? sortBy,
  }) async {
    return _getNews(() => remoteDataSource.searchNews(
          query: query,
          from: from,
          to: to,
          sortBy: sortBy,
          apiKey: dotenv.env['NEWS_API_KEY'] ?? '',
        ));
  }

  @override
  Future<Either<Failure, List<ArticleEntity>>> getTrendingNews() async {
    return _getNews(() => remoteDataSource.getTrendingNews(
          apiKey: dotenv.env['NEWS_API_KEY'] ?? '',
        ));
  }

  @override
  Future<Either<Failure, List<NewsSourceEntity>>> getSources() async {
    if (await connectionChecker.hasConnection) {
      try {
        final remoteResponse = await remoteDataSource.getSources(
          apiKey: dotenv.env['NEWS_API_KEY'] ?? '',
        );
        // Có thể cache source ở đây nếu muốn, nhưng tạm thời lấy trực tiếp
        return Right(remoteResponse.sources
            .map<NewsSourceEntity>((model) => model.toEntity())
            .toList());
      } catch (e) {
        debugPrint('Repository Error (sources): $e');
        return Left(ServerFailure('API Error: $e'));
      }
    } else {
      return const Left(CacheFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<ArticleEntity>>> getNewsByCountry(
      String country) async {
    return _getNews(() => remoteDataSource.getNewsByCountry(
          country: country,
          apiKey: dotenv.env['NEWS_API_KEY'] ?? '',
        ));
  }

  @override
  Future<Either<Failure, List<ArticleEntity>>> getNewsByCategoryAndCountry({
    required String category,
    required String country,
  }) async {
    return _getNews(() => remoteDataSource.getNewsByCategoryAndCountry(
          category: category,
          country: country,
          apiKey: dotenv.env['NEWS_API_KEY'] ?? '',
        ));
  }

  Future<Either<Failure, List<ArticleEntity>>> _getNews(
    Future<NewsResponseModel> Function() getRemoteNews,
  ) async {
    if (await connectionChecker.hasConnection) {
      try {
        final remoteResponse = await getRemoteNews();
        await localDataSource.cacheArticles(remoteResponse.articles);
        return Right(remoteResponse.articles
            .map<ArticleEntity>((model) => model.toEntity())
            .toList());
      } catch (e) {
        debugPrint('Repository Error: $e');
        return Left(ServerFailure('API Error: $e'));
      }
    } else {
      try {
        final localNews = await localDataSource.getCachedArticles();
        return Right(localNews
            .map<ArticleEntity>((model) => model.toEntity())
            .toList());
      } catch (e) {
        return const Left(CacheFailure('Database Error'));
      }
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSearchHistory() async {
    try {
      final history = await localDataSource.getSearchHistory();
      return Right(history);
    } catch (e) {
      return const Left(CacheFailure('Cannot read search history'));
    }
  }

  @override
  Future<Either<Failure, void>> saveSearchHistory(String query) async {
    try {
      await localDataSource.saveSearchHistory(query);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Cannot save search history'));
    }
  }

  @override
  Future<Either<Failure, void>> clearSearchHistory() async {
    try {
      await localDataSource.clearSearchHistory();
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Cannot clear search history'));
    }
  }

  @override
  Future<Either<Failure, void>> saveBookmark(ArticleEntity article) async {
    try {
      final model = ArticleModel(
        author: article.author,
        title: article.title,
        description: article.description,
        url: article.url,
        urlToImage: article.urlToImage,
        publishedAt: article.publishedAt.toIso8601String(),
        content: article.content,
      );
      await localDataSource.saveBookmark(model);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Cannot save bookmark'));
    }
  }

  @override
  Future<Either<Failure, void>> removeBookmark(String url) async {
    try {
      await localDataSource.removeBookmark(url);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Cannot remove bookmark'));
    }
  }

  @override
  Future<Either<Failure, List<ArticleEntity>>> getBookmarks() async {
    try {
      final models = await localDataSource.getBookmarks();
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (e) {
      return const Left(CacheFailure('Cannot get bookmarks'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkBookmark(String url) async {
    try {
      final result = await localDataSource.checkBookmark(url);
      return Right(result);
    } catch (e) {
      return const Left(CacheFailure('Cannot check bookmark'));
    }
  }
}