import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_wave/core/error/failure.dart';
import 'package:news_wave/features/news/domain/entities/article_entity.dart';
import 'package:news_wave/features/news/domain/repositories/news_repository.dart';
import 'package:news_wave/features/news/domain/usecases/search_news_usecase.dart';

// ─── Mock ────────────────────────────────────────────────────────────────────
class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  late SearchNewsUseCase useCase;
  late MockNewsRepository mockRepository;

  // ─── Fixtures ────────────────────────────────────────────────────────────
  final tArticles = [
    ArticleEntity(
      title: 'Flutter 3',
      url: 'https://flutter.dev',
      publishedAt: DateTime(2024, 3, 1),
    ),
  ];

  setUp(() {
    mockRepository = MockNewsRepository();
    useCase = SearchNewsUseCase(mockRepository);
  });

  group('SearchNewsUseCase', () {
    test('should call repository.searchNews with all params', () async {
      // Arrange
      when(() => mockRepository.searchNews(
            query: 'flutter',
            from: '2024-01-01',
            to: '2024-12-31',
            sortBy: 'popularity',
          )).thenAnswer((_) async => Right(tArticles));

      // Act
      final result = await useCase(SearchParams(
        query: 'flutter',
        from: '2024-01-01',
        to: '2024-12-31',
        sortBy: 'popularity',
      ));

      // Assert
      expect(result, Right(tArticles));
      verify(() => mockRepository.searchNews(
            query: 'flutter',
            from: '2024-01-01',
            to: '2024-12-31',
            sortBy: 'popularity',
          )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should call repository.searchNews with only required query param', () async {
      // Arrange
      when(() => mockRepository.searchNews(
            query: 'dart',
            from: null,
            to: null,
            sortBy: null,
          )).thenAnswer((_) async => Right(tArticles));

      // Act
      final result = await useCase(SearchParams(query: 'dart'));

      // Assert
      expect(result, Right(tArticles));
      verify(() => mockRepository.searchNews(
            query: 'dart',
            from: null,
            to: null,
            sortBy: null,
          )).called(1);
    });

    test('should forward ServerFailure when search fails', () async {
      // Arrange
      const failure = ServerFailure('API limit reached');
      when(() => mockRepository.searchNews(
            query: any(named: 'query'),
            from: any(named: 'from'),
            to: any(named: 'to'),
            sortBy: any(named: 'sortBy'),
          )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(SearchParams(query: 'any'));

      // Assert
      expect(result, const Left(ServerFailure('API limit reached')));
    });

    test('should return empty list when search yields no results', () async {
      // Arrange
      when(() => mockRepository.searchNews(
            query: any(named: 'query'),
            from: any(named: 'from'),
            to: any(named: 'to'),
            sortBy: any(named: 'sortBy'),
          )).thenAnswer((_) async => const Right([]));

      // Act
      final result = await useCase(SearchParams(query: 'obscure-topic'));

      // Assert
      result.fold(
        (l) => fail('Should not be Left'),
        (r) => expect(r, isEmpty),
      );
    });
  });
}
