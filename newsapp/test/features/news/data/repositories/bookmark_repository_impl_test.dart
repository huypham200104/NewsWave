import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_wave/core/error/failure.dart';
import 'package:news_wave/features/news/data/datasources/bookmark_local_datasource.dart';
import 'package:news_wave/features/news/data/models/article_model.dart';
import 'package:news_wave/features/news/data/repositories/bookmark_repository_impl.dart';
import 'package:news_wave/features/news/domain/entities/article_entity.dart';

// ─── Mock ────────────────────────────────────────────────────────────────────
class MockBookmarkLocalDataSource extends Mock
    implements BookmarkLocalDataSource {}

void main() {
  late BookmarkRepositoryImpl repository;
  late MockBookmarkLocalDataSource mockLocalDataSource;

  // ─── Fixtures ────────────────────────────────────────────────────────────
  final tArticle = ArticleEntity(
    author: 'Author',
    title: 'Test Article',
    description: 'Description',
    url: 'https://example.com',
    urlToImage: 'https://example.com/img.png',
    publishedAt: DateTime(2024, 1, 1),
    content: 'Content',
  );

  const tExpectedModel = ArticleModel(
    author: 'Author',
    title: 'Test Article',
    description: 'Description',
    url: 'https://example.com',
    urlToImage: 'https://example.com/img.png',
    publishedAt: '2024-01-01T00:00:00.000',
    content: 'Content',
  );

  const tUrl = 'https://example.com';

  setUpAll(() {
    // Required by mocktail when using any() for ArticleModel parameters
    registerFallbackValue(const ArticleModel());
  });

  setUp(() {
    mockLocalDataSource = MockBookmarkLocalDataSource();
    repository = BookmarkRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  // ─── saveBookmark ─────────────────────────────────────────────────────────
  group('saveBookmark', () {
    test('should call localDataSource.saveBookmark and return Right(null)', () async {
      // Arrange – accept any ArticleModel (entity→model conversion is internal)
      when(() => mockLocalDataSource.saveBookmark(any()))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.saveBookmark(tArticle);

      // Assert
      expect(result, const Right(null));
      verify(() => mockLocalDataSource.saveBookmark(any())).called(1);
    });

    test('should map entity fields correctly to ArticleModel before saving', () async {
      ArticleModel? capturedModel;
      when(() => mockLocalDataSource.saveBookmark(any()))
          .thenAnswer((invocation) async {
        capturedModel = invocation.positionalArguments[0] as ArticleModel;
      });

      await repository.saveBookmark(tArticle);

      expect(capturedModel?.title, tArticle.title);
      expect(capturedModel?.url, tArticle.url);
      expect(capturedModel?.author, tArticle.author);
    });

    test('should return Left(CacheFailure) when localDataSource throws', () async {
      when(() => mockLocalDataSource.saveBookmark(any()))
          .thenThrow(Exception('Storage error'));

      final result = await repository.saveBookmark(tArticle);

      expect(result, const Left(CacheFailure('Cannot save bookmark')));
    });
  });

  // ─── removeBookmark ───────────────────────────────────────────────────────
  group('removeBookmark', () {
    test('should call localDataSource.removeBookmark and return Right(null)', () async {
      when(() => mockLocalDataSource.removeBookmark(tUrl))
          .thenAnswer((_) async {});

      final result = await repository.removeBookmark(tUrl);

      expect(result, const Right(null));
      verify(() => mockLocalDataSource.removeBookmark(tUrl)).called(1);
    });

    test('should return Left(CacheFailure) when localDataSource throws', () async {
      when(() => mockLocalDataSource.removeBookmark(any()))
          .thenThrow(Exception('Delete error'));

      final result = await repository.removeBookmark(tUrl);

      expect(result, const Left(CacheFailure('Cannot remove bookmark')));
    });
  });

  // ─── getBookmarks ─────────────────────────────────────────────────────────
  group('getBookmarks', () {
    final tModels = [tExpectedModel];

    test('should return Right(list of entities) from local cache', () async {
      when(() => mockLocalDataSource.getBookmarks())
          .thenAnswer((_) async => tModels);

      final result = await repository.getBookmarks();

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should not be Left'),
        (r) {
          expect(r.length, 1);
          expect(r.first.title, 'Test Article');
          expect(r.first.url, 'https://example.com');
        },
      );
    });

    test('should return Right([]) when local cache is empty', () async {
      when(() => mockLocalDataSource.getBookmarks())
          .thenAnswer((_) async => []);

      final result = await repository.getBookmarks();

      result.fold(
        (l) => fail('Should not be Left'),
        (r) => expect(r, isEmpty),
      );
    });

    test('should return Left(CacheFailure) when localDataSource throws', () async {
      when(() => mockLocalDataSource.getBookmarks())
          .thenThrow(Exception('Read error'));

      final result = await repository.getBookmarks();

      expect(result, const Left(CacheFailure('Cannot get bookmarks')));
    });
  });

  // ─── checkBookmark ────────────────────────────────────────────────────────
  group('checkBookmark', () {
    test('should return Right(true) when article is bookmarked', () async {
      when(() => mockLocalDataSource.checkBookmark(tUrl))
          .thenAnswer((_) async => true);

      final result = await repository.checkBookmark(tUrl);

      expect(result, const Right(true));
    });

    test('should return Right(false) when article is NOT bookmarked', () async {
      when(() => mockLocalDataSource.checkBookmark(tUrl))
          .thenAnswer((_) async => false);

      final result = await repository.checkBookmark(tUrl);

      expect(result, const Right(false));
    });

    test('should return Left(CacheFailure) when localDataSource throws', () async {
      when(() => mockLocalDataSource.checkBookmark(any()))
          .thenThrow(Exception('Check error'));

      final result = await repository.checkBookmark(tUrl);

      expect(result, const Left(CacheFailure('Cannot check bookmark')));
    });
  });
}
