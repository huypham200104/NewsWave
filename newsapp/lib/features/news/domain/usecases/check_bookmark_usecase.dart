import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../repositories/news_repository.dart';
import 'usecase.dart';

@injectable
class CheckBookmarkUseCase implements UseCase<bool, String> {
  final NewsRepository repository;

  CheckBookmarkUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(String params) async {
    return await repository.checkBookmark(params);
  }
}
