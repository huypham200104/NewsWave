import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_wave/core/error/failure.dart';
import 'package:news_wave/features/news/domain/entities/article_entity.dart';
import 'package:news_wave/features/news/domain/repositories/bookmark_repository.dart';
import 'package:news_wave/features/news/domain/usecases/get_bookmarks_usecase.dart';
import 'package:news_wave/features/news/domain/usecases/save_bookmark_usecase.dart';
import 'package:news_wave/features/news/domain/usecases/remove_bookmark_usecase.dart';
import 'package:news_wave/features/news/domain/usecases/check_bookmark_usecase.dart';
import 'package:news_wave/features/news/domain/usecases/usecase.dart';

// ─── Mock ────────────────────────────────────────────────────────────────────
class MockBookmarkRepository extends Mock implements BookmarkRepository {}

void main() {
  late MockBookmarkRepository mockRepo;
  late GetBookmarksUseCase getBookmarksUseCase;
  late SaveBookmarkUseCase saveBookmarkUseCase;
  late RemoveBookmarkUseCase removeBookmarkUseCase;
  late CheckBookmarkUseCase checkBookmarkUseCase;

  // ─── Fixtures ───────────────────────────────────────────────────────
  final tArticle = ArticleEntity(
    author: 'Author',
    title: 'Test Article',
    url: 'https://example.com/article-1',
    publishedAt: DateTime(2024, 1, 15),
  );

  final tBookmarks = [tArticle];
  const tUrl = 'https://example.com/article-1';

  setUpAll(() {
    // Required by mocktail when using any() for these parameter types
    registerFallbackValue(NoParams());
    registerFallbackValue(ArticleEntity(
      title: 'fallback',
      url: 'https://fallback.com',
      publishedAt: DateTime(2024),
    ));
  });

  setUp(() {
    mockRepo = MockBookmarkRepository();
    getBookmarksUseCase = GetBookmarksUseCase(mockRepo);
    saveBookmarkUseCase = SaveBookmarkUseCase(mockRepo);
    removeBookmarkUseCase = RemoveBookmarkUseCase(mockRepo);
    checkBookmarkUseCase = CheckBookmarkUseCase(mockRepo);
  });

  // ─── GetBookmarksUseCase ─────────────────────────────────────────────
  group('GetBookmarksUseCase', () {
    test('should return list of bookmarked articles on success', () async {
      when(() => mockRepo.getBookmarks())
          .thenAnswer((_) async => Right(tBookmarks));

      final result = await getBookmarksUseCase(NoParams());

      expect(result, Right(tBookmarks));
      verify(() => mockRepo.getBookmarks()).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should return CacheFailure when local storage fails', () async {
      when(() => mockRepo.getBookmarks())
          .thenAnswer((_) async => const Left(CacheFailure('Cannot get bookmarks')));

      final result = await getBookmarksUseCase(NoParams());

      expect(result, const Left(CacheFailure('Cannot get bookmarks')));
    });

    test('should return empty list when no bookmarks exist', () async {
      when(() => mockRepo.getBookmarks())
          .thenAnswer((_) async => const Right([]));

      final result = await getBookmarksUseCase(NoParams());

      result.fold(
        (l) => fail('Should not be Left'),
        (r) => expect(r, isEmpty),
      );
    });
  });

  // ─── SaveBookmarkUseCase ─────────────────────────────────────────────
  group('SaveBookmarkUseCase', () {
    test('should call repository.saveBookmark with the article', () async {
      when(() => mockRepo.saveBookmark(tArticle))
          .thenAnswer((_) async => const Right(null));

      final result = await saveBookmarkUseCase(tArticle);

      expect(result, const Right(null));
      verify(() => mockRepo.saveBookmark(tArticle)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should return CacheFailure when saving fails', () async {
      when(() => mockRepo.saveBookmark(any()))
          .thenAnswer((_) async => const Left(CacheFailure('Cannot save bookmark')));

      final result = await saveBookmarkUseCase(tArticle);

      expect(result, const Left(CacheFailure('Cannot save bookmark')));
    });
  });

  // ─── RemoveBookmarkUseCase ───────────────────────────────────────────
  group('RemoveBookmarkUseCase', () {
    test('should call repository.removeBookmark with the url', () async {
      when(() => mockRepo.removeBookmark(tUrl))
          .thenAnswer((_) async => const Right(null));

      final result = await removeBookmarkUseCase(tUrl);

      expect(result, const Right(null));
      verify(() => mockRepo.removeBookmark(tUrl)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should return CacheFailure when removal fails', () async {
      when(() => mockRepo.removeBookmark(any()))
          .thenAnswer((_) async => const Left(CacheFailure('Cannot remove bookmark')));

      final result = await removeBookmarkUseCase(tUrl);

      expect(result, const Left(CacheFailure('Cannot remove bookmark')));
    });
  });

  // ─── CheckBookmarkUseCase ────────────────────────────────────────────
  group('CheckBookmarkUseCase', () {
    test('should return true when article is bookmarked', () async {
      when(() => mockRepo.checkBookmark(tUrl))
          .thenAnswer((_) async => const Right(true));

      final result = await checkBookmarkUseCase(tUrl);

      expect(result, const Right(true));
    });

    test('should return false when article is NOT bookmarked', () async {
      when(() => mockRepo.checkBookmark(tUrl))
          .thenAnswer((_) async => const Right(false));

      final result = await checkBookmarkUseCase(tUrl);

      expect(result, const Right(false));
    });

    test('should return CacheFailure when check fails', () async {
      when(() => mockRepo.checkBookmark(any()))
          .thenAnswer((_) async => const Left(CacheFailure('Cannot check bookmark')));

      final result = await checkBookmarkUseCase(tUrl);

      expect(result, const Left(CacheFailure('Cannot check bookmark')));
    });
  });
}
