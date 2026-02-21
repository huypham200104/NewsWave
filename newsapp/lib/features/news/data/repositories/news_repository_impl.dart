import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/article_entity.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_data_source.dart';
import '../datasources/news_local_datasource.dart';

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
    if (await connectionChecker.hasConnection) {
      try {
        // Lấy API Key từ file .env
        final apiKey = dotenv.env['NEWS_API_KEY'] ?? ''; 
        final remoteNews = await remoteDataSource.getTopHeadlines(apiKey: apiKey);
        await localDataSource.cacheArticles(remoteNews.articles);
        return Right(remoteNews.articles.map((model) => model.toEntity()).toList());
      } catch (e) {
        return const Left(ServerFailure('API Error'));
      }
    } else {
      try {
        final localNews = await localDataSource.getCachedArticles();
        return Right(localNews.map((model) => model.toEntity()).toList());
      } catch (e) {
        return const Left(CacheFailure('Database Error'));
      }
    }
  }
}