import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_wave/core/error/failure.dart';
import 'package:news_wave/features/news/domain/entities/article_entity.dart';
import 'package:news_wave/features/news/domain/repositories/news_repository.dart';
import 'package:news_wave/features/news/domain/usecases/get_articles_usecase.dart';
import 'package:news_wave/features/news/domain/usecases/usecase.dart';

// ─── Mock ────────────────────────────────────────────────────────────────────
class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  late GetArticlesUseCase useCase;
  late MockNewsRepository mockRepository;

  // ─── Fixtures ────────────────────────────────────────────────────────────
  final tArticles = [
    ArticleEntity(
      title: 'Test Article',
      url: 'https://example.com',
      publishedAt: DateTime(2024, 1, 1),
    ),
  ];

  setUp(() {
    mockRepository = MockNewsRepository();
    useCase = GetArticlesUseCase(mockRepository);
  });

  group('GetArticlesUseCase', () {
    test('should delegate to repository.getTopHeadlines()', () async {
      // Arrange
      when(() => mockRepository.getTopHeadlines())
          .thenAnswer((_) async => Right(tArticles));

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, Right(tArticles));
      verify(() => mockRepository.getTopHeadlines()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should forward ServerFailure when repository fails', () async {
      // Arrange
      const failure = ServerFailure('Server Error');
      when(() => mockRepository.getTopHeadlines())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, const Left(ServerFailure('Server Error')));
      verify(() => mockRepository.getTopHeadlines()).called(1);
    });

    test('should forward CacheFailure when no internet connection', () async {
      // Arrange
      const failure = CacheFailure('No internet');
      when(() => mockRepository.getTopHeadlines())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, const Left(CacheFailure('No internet')));
    });

    test('should return empty list when repository returns empty', () async {
      // Arrange
      when(() => mockRepository.getTopHeadlines())
          .thenAnswer((_) async => const Right([]));

      // Act
      final result = await useCase(NoParams());

      // Assert
      result.fold(
        (l) => fail('Should not be Left'),
        (r) => expect(r, isEmpty),
      );
    });
  });
}
