import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:news_wave/core/error/failure.dart';
import 'package:news_wave/features/news/data/datasources/news_local_datasource.dart';
import 'package:news_wave/features/news/data/datasources/news_remote_data_source.dart';
import 'package:news_wave/features/news/data/models/article_model.dart';
import 'package:news_wave/features/news/data/models/news_response_model.dart';
import 'package:news_wave/features/news/data/models/sources_response_model.dart';
import 'package:news_wave/features/news/data/repositories/news_repository_impl.dart';
import 'package:news_wave/features/news/domain/entities/article_entity.dart';

// ─── Mocks ───────────────────────────────────────────────────────────────────
class MockNewsRemoteDataSource extends Mock implements NewsRemoteDataSource {}

class MockNewsLocalDataSource extends Mock implements NewsLocalDataSource {}

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late NewsRepositoryImpl repository;
  late MockNewsRemoteDataSource mockRemote;
  late MockNewsLocalDataSource mockLocal;
  late MockInternetConnectionChecker mockChecker;

  // ─── Fixtures ────────────────────────────────────────────────────────────
  const tArticleModel = ArticleModel(
    author: 'Author',
    title: 'Test',
    url: 'https://example.com',
    publishedAt: '2024-01-01T00:00:00Z',
  );
  final tArticleModels = [tArticleModel];
  final tResponse = NewsResponseModel(
    status: 'ok',
    totalResults: 1,
    articles: tArticleModels,
  );
  final tEntities = tArticleModels.map((m) => m.toEntity()).toList();

  setUp(() {
    mockRemote = MockNewsRemoteDataSource();
    mockLocal = MockNewsLocalDataSource();
    mockChecker = MockInternetConnectionChecker();

    repository = NewsRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
      connectionChecker: mockChecker,
    );

    // Default: cache op always succeeds (side effect, not tested here)
    when(() => mockLocal.cacheArticles(any()))
        .thenAnswer((_) async {});
  });

  // ─── getTopHeadlines ─────────────────────────────────────────────────────
  group('getTopHeadlines', () {
    group('when device is ONLINE', () {
      setUp(() {
        when(() => mockChecker.hasConnection).thenAnswer((_) async => true);
      });

      test('should fetch data from remote, cache it, and return Right(entities)', () async {
        // Arrange
        when(() => mockRemote.getTopHeadlines())
            .thenAnswer((_) async => tResponse);

        // Act
        final result = await repository.getTopHeadlines();

        // Assert – unfold to avoid Dart List reference-equality pitfall
        expect(result.isRight(), isTrue);
        result.fold((l) => fail('Should be Right'), (r) {
          expect(r.length, tEntities.length);
          expect(r.first.title, tEntities.first.title);
          expect(r.first.url, tEntities.first.url);
          expect(r.first.author, tEntities.first.author);
        });
        verify(() => mockRemote.getTopHeadlines()).called(1);
        verify(() => mockLocal.cacheArticles(tArticleModels)).called(1);
      });

      test('should return Left(ServerFailure) when remote throws exception', () async {
        // Arrange
        when(() => mockRemote.getTopHeadlines()).thenThrow(Exception('Network error'));

        // Act
        final result = await repository.getTopHeadlines();

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (_) => fail('Should be Left'),
        );
        verifyNever(() => mockLocal.cacheArticles(any()));
      });
    });

    group('when device is OFFLINE', () {
      setUp(() {
        when(() => mockChecker.hasConnection).thenAnswer((_) async => false);
      });

      test('should fetch from local cache and return Right(entities)', () async {
        // Arrange
        when(() => mockLocal.getCachedArticles())
            .thenAnswer((_) async => tArticleModels);

        // Act
        final result = await repository.getTopHeadlines();

        // Assert – unfold to avoid Dart List reference-equality pitfall
        expect(result.isRight(), isTrue);
        result.fold((l) => fail('Should be Right'), (r) {
          expect(r.length, tEntities.length);
          expect(r.first.title, tEntities.first.title);
          expect(r.first.url, tEntities.first.url);
        });
        verify(() => mockLocal.getCachedArticles()).called(1);
        verifyNever(() => mockRemote.getTopHeadlines());
      });

      test('should return Left(CacheFailure) when local cache throws exception', () async {
        // Arrange
        when(() => mockLocal.getCachedArticles())
            .thenThrow(Exception('DB error'));

        // Act
        final result = await repository.getTopHeadlines();

        // Assert
        expect(result, const Left(CacheFailure('Database Error')));
      });
    });
  });

  // ─── getNewsByCategory ────────────────────────────────────────────────────
  group('getNewsByCategory', () {
    test('online: should call remote with category and return Right(entities)', () async {
      when(() => mockChecker.hasConnection).thenAnswer((_) async => true);
      when(() => mockRemote.getNewsByCategory(category: 'tech'))
          .thenAnswer((_) async => tResponse);

      final result = await repository.getNewsByCategory('tech');

      expect(result.isRight(), isTrue);
      result.fold((l) => fail('Should be Right'), (r) {
        expect(r.length, tEntities.length);
        expect(r.first.title, tEntities.first.title);
      });
      verify(() => mockRemote.getNewsByCategory(category: 'tech')).called(1);
    });
  });

  // ─── searchNews ───────────────────────────────────────────────────────────
  group('searchNews', () {
    test('online: should call remote with search params and return Right(entities)', () async {
      when(() => mockChecker.hasConnection).thenAnswer((_) async => true);
      when(() => mockRemote.searchNews(
            query: 'flutter',
            from: null,
            to: null,
            sortBy: null,
          )).thenAnswer((_) async => tResponse);

      final result = await repository.searchNews(query: 'flutter');

      expect(result.isRight(), isTrue);
      result.fold((l) => fail('Should be Right'), (r) {
        expect(r.length, tEntities.length);
        expect(r.first.title, tEntities.first.title);
      });
    });
  });

  // ─── getSources ───────────────────────────────────────────────────────────
  group('getSources', () {
    final tSourcesResponse = SourcesResponseModel(status: 'ok', sources: []);

    test('online + success: should return Right(sources)', () async {
      when(() => mockChecker.hasConnection).thenAnswer((_) async => true);
      when(() => mockRemote.getSources())
          .thenAnswer((_) async => tSourcesResponse);

      final result = await repository.getSources();

      expect(result.isRight(), isTrue);
      verify(() => mockRemote.getSources()).called(1);
    });

    test('online + exception: should return Left(ServerFailure)', () async {
      when(() => mockChecker.hasConnection).thenAnswer((_) async => true);
      when(() => mockRemote.getSources()).thenThrow(Exception('API error'));

      final result = await repository.getSources();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should be Left'),
      );
    });

    test('offline: should return Left(CacheFailure)', () async {
      when(() => mockChecker.hasConnection).thenAnswer((_) async => false);

      final result = await repository.getSources();

      expect(result, const Left(CacheFailure('No Internet Connection')));
    });
  });
}
