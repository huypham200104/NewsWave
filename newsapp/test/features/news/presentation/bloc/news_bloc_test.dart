import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_wave/core/error/failure.dart';
import 'package:news_wave/features/news/domain/entities/article_entity.dart';
import 'package:news_wave/features/news/domain/usecases/get_articles_usecase.dart';
import 'package:news_wave/features/news/domain/usecases/get_news_by_category_usecase.dart';
import 'package:news_wave/features/news/domain/usecases/search_news_usecase.dart';
import 'package:news_wave/features/news/domain/usecases/usecase.dart';
import 'package:news_wave/features/news/presentation/bloc/news_bloc.dart';

// ─── Mocks ───────────────────────────────────────────────────────────────────
class MockGetArticlesUseCase extends Mock implements GetArticlesUseCase {}

class MockGetNewsByCategoryUseCase extends Mock
    implements GetNewsByCategoryUseCase {}

class MockSearchNewsUseCase extends Mock implements SearchNewsUseCase {}

void main() {
  late NewsBloc bloc;
  late MockGetArticlesUseCase mockGetArticles;
  late MockGetNewsByCategoryUseCase mockGetByCategory;
  late MockSearchNewsUseCase mockSearchNews;

  // ─── Fixtures ────────────────────────────────────────────────────────────
  final tArticles = [
    ArticleEntity(
      title: 'Article 1',
      url: 'https://example.com/1',
      publishedAt: DateTime(2024, 1, 1),
    ),
  ];

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(SearchParams(query: ''));
  });

  setUp(() {
    mockGetArticles = MockGetArticlesUseCase();
    mockGetByCategory = MockGetNewsByCategoryUseCase();
    mockSearchNews = MockSearchNewsUseCase();

    bloc = NewsBloc(mockGetArticles, mockGetByCategory, mockSearchNews);
  });

  tearDown(() => bloc.close());

  group('Initial state', () {
    test('should be NewsInitial', () {
      expect(bloc.state, isA<NewsInitial>());
    });
  });

  // ─── GetTopHeadlinesEvent (no topics) ────────────────────────────────────
  group('GetTopHeadlinesEvent – without topics', () {
    blocTest<NewsBloc, NewsState>(
      'emits [NewsLoading, NewsLoaded] on success',
      build: () {
        when(() => mockGetArticles(any()))
            .thenAnswer((_) async => Right(tArticles));
        return bloc;
      },
      act: (b) => b.add(GetTopHeadlinesEvent()),
      expect: () => [isA<NewsLoading>(), isA<NewsLoaded>()],
      verify: (_) => verify(() => mockGetArticles(any())).called(1),
    );

    blocTest<NewsBloc, NewsState>(
      'emits [NewsLoading, NewsError] when repository fails',
      build: () {
        when(() => mockGetArticles(any()))
            .thenAnswer((_) async => const Left(ServerFailure('Server down')));
        return bloc;
      },
      act: (b) => b.add(GetTopHeadlinesEvent()),
      expect: () => [isA<NewsLoading>(), isA<NewsError>()],
    );

    blocTest<NewsBloc, NewsState>(
      'emits [NewsLoading, NewsLoaded([])] when returned list is empty',
      build: () {
        when(() => mockGetArticles(any()))
            .thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (b) => b.add(GetTopHeadlinesEvent()),
      expect: () => [
        isA<NewsLoading>(),
        predicate<NewsState>((s) => s is NewsLoaded && s.articles.isEmpty),
      ],
    );
  });

  // ─── GetTopHeadlinesEvent (with topics) ──────────────────────────────────
  group('GetTopHeadlinesEvent – with topics (uses searchNewsUseCase)', () {
    blocTest<NewsBloc, NewsState>(
      'emits [NewsLoading, NewsLoaded] using searchNewsUseCase when topics provided',
      build: () {
        when(() => mockSearchNews(any()))
            .thenAnswer((_) async => Right(tArticles));
        return bloc;
      },
      act: (b) => b.add(GetTopHeadlinesEvent(topics: ['tech', 'sports'])),
      expect: () => [isA<NewsLoading>(), isA<NewsLoaded>()],
      verify: (_) {
        verifyNever(() => mockGetArticles(any()));
        verify(() => mockSearchNews(any())).called(1);
      },
    );
  });

  // ─── GetNewsByCategoryEvent ───────────────────────────────────────────────
  group('GetNewsByCategoryEvent', () {
    blocTest<NewsBloc, NewsState>(
      'emits [NewsLoading, NewsLoaded] on success',
      build: () {
        when(() => mockGetByCategory(any()))
            .thenAnswer((_) async => Right(tArticles));
        return bloc;
      },
      act: (b) => b.add(GetNewsByCategoryEvent('tech')),
      expect: () => [isA<NewsLoading>(), isA<NewsLoaded>()],
      verify: (_) => verify(() => mockGetByCategory(any())).called(1),
    );

    blocTest<NewsBloc, NewsState>(
      'emits [NewsLoading, NewsError] on failure',
      build: () {
        when(() => mockGetByCategory(any()))
            .thenAnswer((_) async => const Left(NetworkFailure('No internet')));
        return bloc;
      },
      act: (b) => b.add(GetNewsByCategoryEvent('business')),
      expect: () => [isA<NewsLoading>(), isA<NewsError>()],
    );
  });

  // ─── SearchNewsEvent ──────────────────────────────────────────────────────
  group('SearchNewsEvent', () {
    blocTest<NewsBloc, NewsState>(
      'emits nothing when query is empty',
      build: () => bloc,
      act: (b) => b.add(SearchNewsEvent('')),
      expect: () => [],
      verify: (_) => verifyNever(() => mockSearchNews(any())),
    );

    blocTest<NewsBloc, NewsState>(
      'emits [NewsLoading, NewsLoaded] when query is non-empty and succeeds',
      build: () {
        when(() => mockSearchNews(any()))
            .thenAnswer((_) async => Right(tArticles));
        return bloc;
      },
      act: (b) => b.add(SearchNewsEvent('flutter')),
      expect: () => [isA<NewsLoading>(), isA<NewsLoaded>()],
    );

    blocTest<NewsBloc, NewsState>(
      'emits [NewsLoading, NewsError] with "Server Error..." on ServerFailure',
      build: () {
        when(() => mockSearchNews(any()))
            .thenAnswer((_) async => const Left(ServerFailure('err')));
        return bloc;
      },
      act: (b) => b.add(SearchNewsEvent('query')),
      expect: () => [
        isA<NewsLoading>(),
        predicate<NewsState>(
          (s) => s is NewsError && s.message.contains('Server Error'),
        ),
      ],
    );

    blocTest<NewsBloc, NewsState>(
      'emits [NewsLoading, NewsError] with "Cache Error..." on CacheFailure',
      build: () {
        when(() => mockSearchNews(any()))
            .thenAnswer((_) async => const Left(CacheFailure('err')));
        return bloc;
      },
      act: (b) => b.add(SearchNewsEvent('query')),
      expect: () => [
        isA<NewsLoading>(),
        predicate<NewsState>(
          (s) => s is NewsError && s.message.contains('Cache Error'),
        ),
      ],
    );

    blocTest<NewsBloc, NewsState>(
      'emits [NewsLoading, NewsError] with "Network Error..." on NetworkFailure',
      build: () {
        when(() => mockSearchNews(any()))
            .thenAnswer((_) async => const Left(NetworkFailure('err')));
        return bloc;
      },
      act: (b) => b.add(SearchNewsEvent('query')),
      expect: () => [
        isA<NewsLoading>(),
        predicate<NewsState>(
          (s) => s is NewsError && s.message.contains('Network Error'),
        ),
      ],
    );
  });
}
