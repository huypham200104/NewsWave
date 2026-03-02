import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../entities/article_entity.dart';
import '../repositories/news_repository.dart';
import 'usecase.dart';

@lazySingleton
class GetNewsByCountryUseCase implements UseCase<List<ArticleEntity>, String> {
  final NewsRepository repository;

  GetNewsByCountryUseCase(this.repository);

  @override
  Future<Either<Failure, List<ArticleEntity>>> call(String country) {
    return repository.getNewsByCountry(country);
  }
}
