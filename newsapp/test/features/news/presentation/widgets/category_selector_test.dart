import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_wave/features/news/presentation/bloc/news_bloc.dart';
import 'package:news_wave/features/news/presentation/widgets/home/category_selector.dart';

// ─── Mock BLoC ───────────────────────────────────────────────────────────────
class MockNewsBloc extends MockBloc<NewsEvent, NewsState>
    implements NewsBloc {}

void main() {
  late MockNewsBloc mockBloc;

  setUpAll(() {
    // Fake SharedPreferences so the widget can call SharedPreferences.getInstance()
    SharedPreferences.setMockInitialValues({});
  });

  setUp(() {
    mockBloc = MockNewsBloc();
    when(() => mockBloc.state).thenReturn(NewsInitial());
  });

  tearDown(() {
    mockBloc.close();
  });

  // Helper to build the widget under test
  Widget buildSubject() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<NewsBloc>.value(
          value: mockBloc,
          child: const CategorySelector(),
        ),
      ),
    );
  }

  // ─── Rendering ────────────────────────────────────────────────────────────
  group('CategorySelector – rendering', () {
    testWidgets('should render all 5 category labels', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.text('For You'), findsOneWidget);
      expect(find.text('World'), findsOneWidget);
      expect(find.text('Tech'), findsOneWidget);
      expect(find.text('Business'), findsOneWidget);
      expect(find.text('Sports'), findsOneWidget);
    });
  });

  // ─── Selection behavior ───────────────────────────────────────────────────
  group('CategorySelector – selection', () {
    testWidgets(
        'tapping "Tech" (index 2) should dispatch GetNewsByCategoryEvent with "tech"',
        (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.tap(find.text('Tech'));
      await tester.pump();

      verify(
        () => mockBloc.add(GetNewsByCategoryEvent('tech')),
      ).called(1);
    });

    testWidgets(
        'tapping "Business" (index 3) should dispatch GetNewsByCategoryEvent with "business"',
        (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.tap(find.text('Business'));
      await tester.pump();

      verify(
        () => mockBloc.add(GetNewsByCategoryEvent('business')),
      ).called(1);
    });

    testWidgets(
        'tapping "World" (index 1) should dispatch GetNewsByCategoryEvent with "world"',
        (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      await tester.tap(find.text('World'));
      await tester.pump();

      verify(
        () => mockBloc.add(GetNewsByCategoryEvent('world')),
      ).called(1);
    });

    testWidgets(
        'tapping "For You" (index 0) should dispatch GetTopHeadlinesEvent',
        (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // Tap 'For You' (already visible at index 0)
      await tester.tap(find.text('For You'));
      await tester.pump();

      // GetTopHeadlinesEvent should have been dispatched at least once
      final callCount = verify(() => mockBloc.add(GetTopHeadlinesEvent()))
          .callCount;
      expect(callCount, greaterThanOrEqualTo(1));
    });
  });
}
