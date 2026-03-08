import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/article_entity.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../datasources/bookmark_local_datasource.dart';
import '../models/article_model.dart';

@LazySingleton(as: BookmarkRepository)
class BookmarkRepositoryImpl implements BookmarkRepository {
  final BookmarkLocalDataSource localDataSource;

  BookmarkRepositoryImpl({required this.localDataSource});

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
      final isBookmarked = await localDataSource.checkBookmark(url);
      return Right(isBookmarked);
    } catch (e) {
      return const Left(CacheFailure('Cannot check bookmark'));
    }
  }
}
