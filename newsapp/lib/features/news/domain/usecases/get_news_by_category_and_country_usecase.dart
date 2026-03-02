import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../entities/article_entity.dart';
import '../repositories/news_repository.dart';
import 'usecase.dart';

class CategoryCountryParams {
  final String category;
  final String country;

  CategoryCountryParams({
    required this.category,
    required this.country,
  });
}

@lazySingleton
class GetNewsByCategoryAndCountryUseCase
    implements UseCase<List<ArticleEntity>, CategoryCountryParams> {
  final NewsRepository repository;

  GetNewsByCategoryAndCountryUseCase(this.repository);

  @override
  Future<Either<Failure, List<ArticleEntity>>> call(
      CategoryCountryParams params) {
    return repository.getNewsByCategoryAndCountry(
      category: params.category,
      country: params.country,
    );
  }
}
