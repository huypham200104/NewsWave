import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/article_entity.dart';

abstract class BookmarkRepository {
  Future<Either<Failure, void>> saveBookmark(ArticleEntity article);
  Future<Either<Failure, void>> removeBookmark(String url);
  Future<Either<Failure, List<ArticleEntity>>> getBookmarks();
  Future<Either<Failure, bool>> checkBookmark(String url);
}
