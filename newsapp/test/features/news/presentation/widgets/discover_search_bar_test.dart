import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_wave/features/news/presentation/bloc/discover/discover_bloc.dart';
import 'package:news_wave/features/news/presentation/bloc/discover/discover_event.dart';
import 'package:news_wave/features/news/presentation/bloc/discover/discover_state.dart';
import 'package:news_wave/features/news/presentation/widgets/discover/discover_search_bar.dart';

// ─── Mock BLoC ───────────────────────────────────────────────────────────────
class MockDiscoverBloc extends MockBloc<DiscoverEvent, DiscoverState>
    implements DiscoverBloc {}

void main() {
  late MockDiscoverBloc mockBloc;

  setUp(() {
    mockBloc = MockDiscoverBloc();
    when(() => mockBloc.state).thenReturn(DiscoverInitial());
  });

  tearDown(() {
    mockBloc.close();
  });

  // Helper to build the widget under test
  Widget buildSubject() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<DiscoverBloc>.value(
          value: mockBloc,
          child: const DiscoverSearchBar(),
        ),
      ),
    );
  }

  // ─── Render ───────────────────────────────────────────────────────────────
  group('DiscoverSearchBar – rendering', () {
    testWidgets('should display a TextField hint text', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search news, topics...'), findsOneWidget);
    });

    testWidgets('should display search prefix icon', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should display clear suffix icon button', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.byIcon(Icons.clear), findsOneWidget);
    });
  });

  // ─── Interaction: onSubmitted ─────────────────────────────────────────────
  group('DiscoverSearchBar – onSubmitted', () {
    testWidgets(
        'should dispatch SearchDiscoverEvent when submitting non-empty query',
        (tester) async {
      await tester.pumpWidget(buildSubject());

      await tester.enterText(find.byType(TextField), 'flutter');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      verify(
        () => mockBloc.add(const SearchDiscoverEvent(query: 'flutter')),
      ).called(1);
    });

    testWidgets(
        'should dispatch LoadDiscoverDataEvent when submitting empty query',
        (tester) async {
      await tester.pumpWidget(buildSubject());

      // Clear field first, then submit
      await tester.enterText(find.byType(TextField), '');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      verify(() => mockBloc.add(LoadDiscoverDataEvent())).called(1);
    });
  });

  // ─── Interaction: clear button ────────────────────────────────────────────
  group('DiscoverSearchBar – clear button', () {
    testWidgets(
        'tapping clear button should clear text and dispatch LoadDiscoverDataEvent',
        (tester) async {
      await tester.pumpWidget(buildSubject());

      // Type something first
      await tester.enterText(find.byType(TextField), 'some query');
      await tester.pump();

      // Tap the clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      // Text should be cleared
      expect(find.text('some query'), findsNothing);

      // Bloc should have received LoadDiscoverDataEvent
      verify(() => mockBloc.add(LoadDiscoverDataEvent())).called(1);
    });
  });
}
