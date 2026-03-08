import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/article_entity.dart';
import '../../domain/entities/news_source_entity.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_data_source.dart';
import '../datasources/news_local_datasource.dart';
import '../models/news_response_model.dart';

/// Repository implementation for news operations
/// Follows Single Responsibility Principle - only handles news data
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
    return _getNews(() => remoteDataSource.getTopHeadlines());
  }

  @override
  Future<Either<Failure, List<ArticleEntity>>> getNewsByCategory(
      String category) async {
    return _getNews(() => remoteDataSource.getNewsByCategory(
          category: category,
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
        ));
  }

  @override
  Future<Either<Failure, List<ArticleEntity>>> getTrendingNews() async {
    return _getNews(() => remoteDataSource.getTrendingNews());
  }

  @override
  Future<Either<Failure, List<NewsSourceEntity>>> getSources() async {
    if (await connectionChecker.hasConnection) {
      try {
        final remoteResponse = await remoteDataSource.getSources();
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
}