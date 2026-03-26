import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_wave/core/error/failure.dart';
import 'package:news_wave/features/news/domain/entities/article_entity.dart';
import 'package:news_wave/features/news/domain/usecases/check_bookmark_usecase.dart';
import 'package:news_wave/features/news/domain/usecases/get_bookmarks_usecase.dart';
import 'package:news_wave/features/news/domain/usecases/remove_bookmark_usecase.dart';
import 'package:news_wave/features/news/domain/usecases/save_bookmark_usecase.dart';
import 'package:news_wave/features/news/domain/usecases/usecase.dart';
import 'package:news_wave/features/news/presentation/bloc/bookmark/bookmark_bloc.dart';
import 'package:news_wave/features/news/presentation/bloc/bookmark/bookmark_event.dart';
import 'package:news_wave/features/news/presentation/bloc/bookmark/bookmark_state.dart';

// ─── Mocks ───────────────────────────────────────────────────────────────────
class MockGetBookmarksUseCase extends Mock implements GetBookmarksUseCase {}

class MockSaveBookmarkUseCase extends Mock implements SaveBookmarkUseCase {}

class MockRemoveBookmarkUseCase extends Mock implements RemoveBookmarkUseCase {}

class MockCheckBookmarkUseCase extends Mock implements CheckBookmarkUseCase {}

void main() {
  late BookmarkBloc bloc;
  late MockGetBookmarksUseCase mockGetBookmarks;
  late MockSaveBookmarkUseCase mockSaveBookmark;
  late MockRemoveBookmarkUseCase mockRemoveBookmark;
  late MockCheckBookmarkUseCase mockCheckBookmark;

  // ─── Fixtures ────────────────────────────────────────────────────────────
  final tArticle = ArticleEntity(
    title: 'Test Article',
    url: 'https://example.com',
    publishedAt: DateTime(2024, 1, 1),
  );
  final tBookmarks = [tArticle];

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(tArticle);
  });

  setUp(() {
    mockGetBookmarks = MockGetBookmarksUseCase();
    mockSaveBookmark = MockSaveBookmarkUseCase();
    mockRemoveBookmark = MockRemoveBookmarkUseCase();
    mockCheckBookmark = MockCheckBookmarkUseCase();

    bloc = BookmarkBloc(
      mockGetBookmarks,
      mockSaveBookmark,
      mockRemoveBookmark,
      mockCheckBookmark,
    );
  });

  tearDown(() => bloc.close());

  group('Initial state', () {
    test('should be BookmarkInitial', () {
      expect(bloc.state, isA<BookmarkInitial>());
    });
  });

  // ─── LoadBookmarksEvent ───────────────────────────────────────────────────
  group('LoadBookmarksEvent', () {
    blocTest<BookmarkBloc, BookmarkState>(
      'emits [BookmarkLoading, BookmarkLoaded] on success',
      build: () {
        when(() => mockGetBookmarks(any()))
            .thenAnswer((_) async => Right(tBookmarks));
        return bloc;
      },
      act: (b) => b.add(LoadBookmarksEvent()),
      expect: () => [
        isA<BookmarkLoading>(),
        predicate<BookmarkState>(
          (s) => s is BookmarkLoaded && s.bookmarks.length == 1,
        ),
      ],
      verify: (_) => verify(() => mockGetBookmarks(any())).called(1),
    );

    blocTest<BookmarkBloc, BookmarkState>(
      'emits [BookmarkLoading, BookmarkLoaded([])] when bookmark list is empty',
      build: () {
        when(() => mockGetBookmarks(any()))
            .thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (b) => b.add(LoadBookmarksEvent()),
      expect: () => [
        isA<BookmarkLoading>(),
        predicate<BookmarkState>(
          (s) => s is BookmarkLoaded && s.bookmarks.isEmpty,
        ),
      ],
    );

    blocTest<BookmarkBloc, BookmarkState>(
      'emits [BookmarkLoading, BookmarkError] when use case fails',
      build: () {
        when(() => mockGetBookmarks(any()))
            .thenAnswer((_) async => const Left(CacheFailure('DB Error')));
        return bloc;
      },
      act: (b) => b.add(LoadBookmarksEvent()),
      expect: () => [
        isA<BookmarkLoading>(),
        predicate<BookmarkState>(
          (s) => s is BookmarkError && s.message == 'Failed to load bookmarks',
        ),
      ],
    );
  });

  // ─── ToggleBookmarkEvent ──────────────────────────────────────────────────
  group('ToggleBookmarkEvent', () {
    blocTest<BookmarkBloc, BookmarkState>(
      'should SAVE bookmark and reload when article is NOT bookmarked',
      build: () {
        // check returns false → not bookmarked → save
        when(() => mockCheckBookmark(any()))
            .thenAnswer((_) async => const Right(false));
        when(() => mockSaveBookmark(any()))
            .thenAnswer((_) async => const Right(null));
        // For the triggered LoadBookmarksEvent
        when(() => mockGetBookmarks(any()))
            .thenAnswer((_) async => Right(tBookmarks));
        return bloc;
      },
      act: (b) => b.add(ToggleBookmarkEvent(tArticle)),
      wait: const Duration(milliseconds: 100),
      verify: (_) {
        verify(() => mockCheckBookmark(tArticle.url)).called(1);
        verify(() => mockSaveBookmark(any())).called(1);
        verifyNever(() => mockRemoveBookmark(any()));
      },
    );

    blocTest<BookmarkBloc, BookmarkState>(
      'should REMOVE bookmark and reload when article IS bookmarked',
      build: () {
        // check returns true → bookmarked → remove
        when(() => mockCheckBookmark(any()))
            .thenAnswer((_) async => const Right(true));
        when(() => mockRemoveBookmark(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockGetBookmarks(any()))
            .thenAnswer((_) async => Right(tBookmarks));
        return bloc;
      },
      act: (b) => b.add(ToggleBookmarkEvent(tArticle)),
      wait: const Duration(milliseconds: 100),
      verify: (_) {
        verify(() => mockCheckBookmark(tArticle.url)).called(1);
        verify(() => mockRemoveBookmark(any())).called(1);
        verifyNever(() => mockSaveBookmark(any()));
      },
    );
  });

  // ─── RemoveBookmarkEvent ──────────────────────────────────────────────────
  group('RemoveBookmarkEvent', () {
    blocTest<BookmarkBloc, BookmarkState>(
      'should call removeBookmark and then trigger LoadBookmarksEvent',
      build: () {
        when(() => mockRemoveBookmark(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockGetBookmarks(any()))
            .thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (b) => b.add(RemoveBookmarkEvent(tArticle.url)),
      wait: const Duration(milliseconds: 100),
      verify: (_) {
        verify(() => mockRemoveBookmark(tArticle.url)).called(1);
        verify(() => mockGetBookmarks(any())).called(1);
      },
    );
  });
}
