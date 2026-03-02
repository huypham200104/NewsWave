import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../entities/article_entity.dart';
import '../repositories/news_repository.dart';
import 'usecase.dart';

@injectable
class GetBookmarksUseCase implements UseCase<List<ArticleEntity>, NoParams> {
  final NewsRepository repository;

  GetBookmarksUseCase(this.repository);

  @override
  Future<Either<Failure, List<ArticleEntity>>> call(NoParams params) async {
    return await repository.getBookmarks();
  }
}
