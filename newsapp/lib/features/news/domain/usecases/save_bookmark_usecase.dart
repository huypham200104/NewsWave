import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../entities/article_entity.dart';
import '../repositories/news_repository.dart';
import 'usecase.dart';

@injectable
class SaveBookmarkUseCase implements UseCase<void, ArticleEntity> {
  final NewsRepository repository;

  SaveBookmarkUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ArticleEntity params) async {
    return await repository.saveBookmark(params);
  }
}
