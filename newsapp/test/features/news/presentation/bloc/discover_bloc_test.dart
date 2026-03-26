import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_wave/core/error/failure.dart';
import 'package:news_wave/features/news/domain/entities/article_entity.dart';
import 'package:news_wave/features/news/domain/entities/news_source_entity.dart';
import 'package:news_wave/features/news/domain/usecases/clear_search_history_usecase.dart';
import 'package:news_wave/features/news/domain/usecases/get_search_history_usecase.dart';
import 'package:news_wave/features/news/domain/usecases/get_sources_usecase.dart';
import 'package:news_wave/features/news/domain/usecases/get_trending_news_usecase.dart';
import 'package:news_wave/features/news/domain/usecases/save_search_history_usecase.dart';
import 'package:news_wave/features/news/domain/usecases/search_news_usecase.dart';
import 'package:news_wave/features/news/domain/usecases/usecase.dart';
import 'package:news_wave/features/news/presentation/bloc/discover/discover_bloc.dart';
import 'package:news_wave/features/news/presentation/bloc/discover/discover_event.dart';
import 'package:news_wave/features/news/presentation/bloc/discover/discover_state.dart';

// ─── Mocks ───────────────────────────────────────────────────────────────────
class MockGetTrendingNewsUseCase extends Mock
    implements GetTrendingNewsUseCase {}

class MockGetSourcesUseCase extends Mock implements GetSourcesUseCase {}

class MockSearchNewsUseCase extends Mock implements SearchNewsUseCase {}

class MockGetSearchHistoryUseCase extends Mock
    implements GetSearchHistoryUseCase {}

class MockSaveSearchHistoryUseCase extends Mock
    implements SaveSearchHistoryUseCase {}

class MockClearSearchHistoryUseCase extends Mock
    implements ClearSearchHistoryUseCase {}

void main() {
  late DiscoverBloc bloc;
  late MockGetTrendingNewsUseCase mockGetTrending;
  late MockGetSourcesUseCase mockGetSources;
  late MockSearchNewsUseCase mockSearchNews;
  late MockGetSearchHistoryUseCase mockGetHistory;
  late MockSaveSearchHistoryUseCase mockSaveHistory;
  late MockClearSearchHistoryUseCase mockClearHistory;

  // ─── Fixtures ────────────────────────────────────────────────────────────
  final tArticles = [
    ArticleEntity(
      title: 'Trending News',
      url: 'https://example.com/trending',
      publishedAt: DateTime(2024, 6, 1),
    ),
  ];
  final tSources = [
    const NewsSourceEntity(
      id: 'bbc',
      name: 'BBC',
      description: 'British Broadcasting Corporation',
      url: 'https://bbc.com',
      category: 'general',
    ),
  ];
  const tHistory = ['flutter', 'dart'];

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(SearchParams(query: ''));
    registerFallbackValue('');
  });

  setUp(() {
    mockGetTrending = MockGetTrendingNewsUseCase();
    mockGetSources = MockGetSourcesUseCase();
    mockSearchNews = MockSearchNewsUseCase();
    mockGetHistory = MockGetSearchHistoryUseCase();
    mockSaveHistory = MockSaveSearchHistoryUseCase();
    mockClearHistory = MockClearSearchHistoryUseCase();

    bloc = DiscoverBloc(
      mockGetTrending,
      mockGetSources,
      mockSearchNews,
      mockGetHistory,
      mockSaveHistory,
      mockClearHistory,
    );
  });

  tearDown(() => bloc.close());

  group('Initial state', () {
    test('should be DiscoverInitial', () {
      expect(bloc.state, isA<DiscoverInitial>());
    });
  });

  // ─── LoadDiscoverDataEvent ────────────────────────────────────────────────
  group('LoadDiscoverDataEvent', () {
    blocTest<DiscoverBloc, DiscoverState>(
      'emits [DiscoverLoading, DiscoverLoaded] when all use cases succeed',
      build: () {
        when(() => mockGetTrending(any()))
            .thenAnswer((_) async => Right(tArticles));
        when(() => mockGetSources(any()))
            .thenAnswer((_) async => Right(tSources));
        when(() => mockGetHistory(any()))
            .thenAnswer((_) async => const Right(tHistory));
        return bloc;
      },
      act: (b) => b.add(LoadDiscoverDataEvent()),
      expect: () => [
        isA<DiscoverLoading>(),
        predicate<DiscoverState>((s) =>
            s is DiscoverLoaded &&
            s.trendingNews.length == 1 &&
            s.sources.length == 1 &&
            s.searchHistory.length == 2),
      ],
    );

    blocTest<DiscoverBloc, DiscoverState>(
      'emits [DiscoverLoading, DiscoverError] when trending news fails',
      build: () {
        when(() => mockGetTrending(any()))
            .thenAnswer((_) async => const Left(ServerFailure('err')));
        when(() => mockGetSources(any()))
            .thenAnswer((_) async => Right(tSources));
        when(() => mockGetHistory(any()))
            .thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (b) => b.add(LoadDiscoverDataEvent()),
      expect: () => [
        isA<DiscoverLoading>(),
        predicate<DiscoverState>(
          (s) =>
              s is DiscoverError && s.message.contains('Server Error'),
        ),
      ],
    );

    blocTest<DiscoverBloc, DiscoverState>(
      'emits [DiscoverLoading, DiscoverError] when sources fail',
      build: () {
        when(() => mockGetTrending(any()))
            .thenAnswer((_) async => Right(tArticles));
        when(() => mockGetSources(any()))
            .thenAnswer((_) async => const Left(CacheFailure('err')));
        when(() => mockGetHistory(any()))
            .thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (b) => b.add(LoadDiscoverDataEvent()),
      expect: () => [
        isA<DiscoverLoading>(),
        isA<DiscoverError>(),
      ],
    );
  });

  // ─── SearchDiscoverEvent ──────────────────────────────────────────────────
  group('SearchDiscoverEvent', () {
    blocTest<DiscoverBloc, DiscoverState>(
      'when query is empty: triggers LoadDiscoverDataEvent (does not search)',
      build: () {
        when(() => mockGetTrending(any()))
            .thenAnswer((_) async => Right(tArticles));
        when(() => mockGetSources(any()))
            .thenAnswer((_) async => Right(tSources));
        when(() => mockGetHistory(any()))
            .thenAnswer((_) async => const Right(tHistory));
        return bloc;
      },
      act: (b) => b.add(const SearchDiscoverEvent(query: '')),
      wait: const Duration(milliseconds: 50),
      verify: (_) => verifyNever(() => mockSearchNews(any())),
    );

    blocTest<DiscoverBloc, DiscoverState>(
      'emits [DiscoverLoading, DiscoverSearchLoaded] when search succeeds',
      build: () {
        when(() => mockSaveHistory(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockSearchNews(any()))
            .thenAnswer((_) async => Right(tArticles));
        return bloc;
      },
      act: (b) => b.add(const SearchDiscoverEvent(query: 'flutter')),
      expect: () => [
        isA<DiscoverLoading>(),
        predicate<DiscoverState>(
          (s) =>
              s is DiscoverSearchLoaded && s.searchResults.length == 1,
        ),
      ],
      verify: (_) {
        verify(() => mockSaveHistory(any())).called(1);
        verify(() => mockSearchNews(any())).called(1);
      },
    );

    blocTest<DiscoverBloc, DiscoverState>(
      'emits [DiscoverLoading, DiscoverError] when search fails',
      build: () {
        when(() => mockSaveHistory(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockSearchNews(any()))
            .thenAnswer((_) async =>
                const Left(NetworkFailure('No connection')));
        return bloc;
      },
      act: (b) => b.add(const SearchDiscoverEvent(query: 'flutter')),
      expect: () => [
        isA<DiscoverLoading>(),
        predicate<DiscoverState>(
          (s) =>
              s is DiscoverError && s.message.contains('Network Error'),
        ),
      ],
    );
  });

  // ─── ClearSearchHistoryEvent ──────────────────────────────────────────────
  group('ClearSearchHistoryEvent', () {
    blocTest<DiscoverBloc, DiscoverState>(
      'calls clearSearchHistoryUseCase and triggers LoadDiscoverDataEvent',
      build: () {
        when(() => mockClearHistory(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockGetTrending(any()))
            .thenAnswer((_) async => Right(tArticles));
        when(() => mockGetSources(any()))
            .thenAnswer((_) async => Right(tSources));
        when(() => mockGetHistory(any()))
            .thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (b) => b.add(ClearSearchHistoryEvent()),
      wait: const Duration(milliseconds: 100),
      verify: (_) {
        verify(() => mockClearHistory(any())).called(1);
        verify(() => mockGetTrending(any())).called(1);
      },
    );
  });

  // ─── _mapFailureToMessage ─────────────────────────────────────────────────
  group('_mapFailureToMessage', () {
    final failureToMessage = {
      const ServerFailure('x'): 'Server Error',
      const CacheFailure('x'): 'Cache Error',
      const NetworkFailure('x'): 'Network Error',
      const UnknownFailure('x'): 'Unexpected Error',
    };

    for (final entry in failureToMessage.entries) {
      final failure = entry.key;
      final expectedMsg = entry.value;

      blocTest<DiscoverBloc, DiscoverState>(
        'maps ${failure.runtimeType} → "$expectedMsg..."',
        build: () {
          when(() => mockGetTrending(any()))
              .thenAnswer((_) async => Left(failure));
          when(() => mockGetSources(any()))
              .thenAnswer((_) async => Right(tSources));
          when(() => mockGetHistory(any()))
              .thenAnswer((_) async => const Right([]));
          return bloc;
        },
        act: (b) => b.add(LoadDiscoverDataEvent()),
        expect: () => [
          isA<DiscoverLoading>(),
          predicate<DiscoverState>(
            (s) => s is DiscoverError && s.message.contains(expectedMsg),
          ),
        ],
      );
    }
  });
}
