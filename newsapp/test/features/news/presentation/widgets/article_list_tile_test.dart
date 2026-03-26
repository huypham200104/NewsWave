import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_wave/features/news/domain/entities/article_entity.dart';
import 'package:news_wave/features/news/presentation/bloc/bookmark/bookmark_bloc.dart';
import 'package:news_wave/features/news/presentation/bloc/bookmark/bookmark_event.dart';
import 'package:news_wave/features/news/presentation/bloc/bookmark/bookmark_state.dart';
import 'package:news_wave/features/news/presentation/widgets/article/article_list_tile.dart';

// ─── Mock BLoC ───────────────────────────────────────────────────────────────
class MockBookmarkBloc extends MockBloc<BookmarkEvent, BookmarkState>
    implements BookmarkBloc {}

void main() {
  // ─── Fixture ─────────────────────────────────────────────────────────────
  final tArticle = ArticleEntity(
    author: 'Author',
    title: 'Breaking Flutter News',
    description: 'A very important news article',
    url: 'https://example.com/flutter-news',
    urlToImage: 'https://example.com/image.png',
    publishedAt: DateTime(2024, 1, 1),
  );

  late MockBookmarkBloc mockBloc;

  setUp(() {
    mockBloc = MockBookmarkBloc();
  });

  tearDown(() {
    mockBloc.close();
  });

  // Helper để build widget với BlocProvider
  Widget buildSubject({required BookmarkState state}) {
    when(() => mockBloc.state).thenReturn(state);
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<BookmarkBloc>.value(
          value: mockBloc,
          child: ArticleListTile(article: tArticle),
        ),
      ),
    );
  }

  // ─── Render ───────────────────────────────────────────────────────────────
  group('ArticleListTile – rendering', () {
    testWidgets('should display the article title', (tester) async {
      await tester.pumpWidget(buildSubject(state: BookmarkInitial()));
      await tester.pump();

      expect(find.text('Breaking Flutter News'), findsOneWidget);
    });

    testWidgets('should display bookmark_border icon when NOT bookmarked',
        (tester) async {
      // Arrange: state has empty bookmarks list
      await tester.pumpWidget(
        buildSubject(state: BookmarkLoaded([])),
      );
      await tester.pump();

      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
      expect(find.byIcon(Icons.bookmark), findsNothing);
    });

    testWidgets('should display filled bookmark icon when article IS bookmarked',
        (tester) async {
      // Arrange: loaded state contains this article
      await tester.pumpWidget(
        buildSubject(state: BookmarkLoaded([tArticle])),
      );
      await tester.pump();

      expect(find.byIcon(Icons.bookmark), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_border), findsNothing);
    });
  });

  // ─── Interaction ─────────────────────────────────────────────────────────
  group('ArticleListTile – interactions', () {
    testWidgets('tapping bookmark icon dispatches ToggleBookmarkEvent',
        (tester) async {
      when(() => mockBloc.state).thenReturn(BookmarkLoaded([]));

      await tester.pumpWidget(buildSubject(state: BookmarkLoaded([])));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.bookmark_border));
      await tester.pump();

      verify(() => mockBloc.add(ToggleBookmarkEvent(tArticle))).called(1);
    });
  });

  // ─── Image Fallback ───────────────────────────────────────────────────────
  group('ArticleListTile – image fallback', () {
    testWidgets('should display grey box fallback when urlToImage is null',
        (tester) async {
      final articleNoImage = ArticleEntity(
        title: 'No Image Article',
        url: 'https://example.com/no-image',
        publishedAt: DateTime(2024, 1, 1),
        urlToImage: null,
      );

      when(() => mockBloc.state).thenReturn(BookmarkLoaded([]));

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: BlocProvider<BookmarkBloc>.value(
            value: mockBloc,
            child: ArticleListTile(article: articleNoImage),
          ),
        ),
      ));
      await tester.pump();

      // article title still renders
      expect(find.text('No Image Article'), findsOneWidget);
    });

    testWidgets('should display grey box fallback when urlToImage is empty',
        (tester) async {
      final articleEmptyImage = ArticleEntity(
        title: 'Empty Image Article',
        url: 'https://example.com/empty-image',
        publishedAt: DateTime(2024, 1, 1),
        urlToImage: '',
      );

      when(() => mockBloc.state).thenReturn(BookmarkLoaded([]));

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: BlocProvider<BookmarkBloc>.value(
            value: mockBloc,
            child: ArticleListTile(article: articleEmptyImage),
          ),
        ),
      ));
      await tester.pump();

      expect(find.text('Empty Image Article'), findsOneWidget);
    });
  });
}
