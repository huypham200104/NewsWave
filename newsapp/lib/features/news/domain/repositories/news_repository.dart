import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/article_entity.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<ArticleEntity>>> getTopHeadlines();
}
