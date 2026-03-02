import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../repositories/news_repository.dart';
import 'usecase.dart';

@injectable
class RemoveBookmarkUseCase implements UseCase<void, String> {
  final NewsRepository repository;

  RemoveBookmarkUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.removeBookmark(params);
  }
}
