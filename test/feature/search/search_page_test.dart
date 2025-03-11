import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pixabay/feature/favourite/favourite_bloc.dart';
import 'package:pixabay/feature/search/search_bloc.dart';
import 'package:pixabay/feature/search/search_page.dart';

// Mock SearchBloc
class MockSearchBloc extends Mock implements SearchBloc {}

// Mock FavoriteBloc
class MockFavoriteBloc extends Mock implements FavoriteBloc {}

// Fake SearchEvent
class FakeSearchEvent extends Fake implements SearchEvent {}

void main() {
  late MockSearchBloc mockSearchBloc;
  late MockFavoriteBloc mockFavoriteBloc;

  setUpAll(() {
    // Register fallback values for SearchEvent
    registerFallbackValue(FakeSearchEvent());
  });

  setUp(() {
    mockSearchBloc = MockSearchBloc();
    mockFavoriteBloc = MockFavoriteBloc();
  });

  // Helper function to wrap the widget with necessary providers
  Widget wrapWithProviders(Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchBloc>.value(value: mockSearchBloc),
        BlocProvider<FavoriteBloc>.value(value: mockFavoriteBloc),
      ],
      child: MaterialApp(home: child),
    );
  }

  testWidgets('SearchPage displays initial state correctly', (WidgetTester tester) async {
    // Arrange: Set up initial state
    when(() => mockSearchBloc.state).thenReturn(SearchInitial());

    // Act: Build the widget
    await tester.pumpWidget(wrapWithProviders(const SearchPage()));

    // Assert: Verify initial UI
    expect(find.text('Search Image'), findsOneWidget); // AppBar title
    expect(find.text('Start searching for image!'), findsOneWidget); // Initial message
    expect(find.byType(TextField), findsOneWidget); // Search bar
    expect(find.byIcon(Icons.favorite), findsOneWidget); // Favorite button
  });

  // testWidgets('Typing in search bar triggers FetchSearchEvent', (WidgetTester tester) async {
  //   Widget makeTestableWidget(Widget child) {
  //     return MaterialApp(
  //       home: child,
  //     );
  //   }
  //
  //   when(() => mockSearchBloc.add(any())).thenAnswer((_) async {});
  //
  //   await tester.pumpWidget(makeTestableWidget(SearchPage()));
  //
  //   final searchField = find.byType(TextField);
  //   expect(searchField, findsOneWidget);
  //
  //   await tester.enterText(searchField, 'Flutter');
  //   await tester.pumpAndSettle(); // Ensure UI updates
  //
  //   verify(() => mockSearchBloc.add(FetchSearchEvent('Flutter'))).called(1);
  // });
  //
  // testWidgets('Clear icon resets search state', (WidgetTester tester) async {
  //   // Arrange: Set up initial state
  //   when(() => mockSearchBloc.state).thenReturn(SearchInitial());
  //   when(() => mockSearchBloc.add(any())).thenReturn(null);
  //
  //   // Act: Build the widget, enter text, and clear it
  //   await tester.pumpWidget(wrapWithProviders(const SearchPage()));
  //   await tester.enterText(find.byType(TextField), 'flowers');
  //   await tester.tap(find.byIcon(Icons.clear));
  //   await tester.pump();
  //
  //   // Assert: Verify that FetchSearchEvent with empty query is added
  //   verify(() => mockSearchBloc.add(FetchSearchEvent(''))).called(1);
  // });
  //
  // testWidgets('Scrolling to bottom triggers LoadMoreSearchEvent', (WidgetTester tester) async {
  //   // Arrange: Set up loaded state
  //   final testImages = [
  //     ImageModel(
  //       id: 1,
  //       tags: 'flower',
  //       ownerName: 'Ravikant 1',
  //       imageUrl: 'http://example.com/image1.jpg',
  //       imageSize: 1234,
  //     ),
  //     ImageModel(
  //       id: 2,
  //       tags: 'flower',
  //       ownerName: 'Ravikant 2',
  //       imageUrl: 'http://example.com/image2.jpg',
  //       imageSize: 5678,
  //     ),
  //   ];
  //   when(() => mockSearchBloc.state).thenReturn(SearchLoaded(
  //     images: testImages,
  //     hasMore: true,
  //     page: 1,
  //     isLoadingMore: false,
  //   ));
  //   when(() => mockSearchBloc.add(any())).thenReturn(null);
  //
  //   // Act: Build the widget and scroll to bottom
  //   await tester.pumpWidget(wrapWithProviders(const SearchPage()));
  //   await tester.drag(find.byType(GridView), const Offset(0, -500));
  //   await tester.pump();
  //
  //   // Assert: Verify that LoadMoreSearchEvent is added
  //   verify(() => mockSearchBloc.add(LoadMoreSearchEvent())).called(1);
  // });
  //
  // testWidgets('Error state displays error message', (WidgetTester tester) async {
  //   // Arrange: Set up error state
  //   when(() => mockSearchBloc.state).thenReturn(SearchError('Failed to load images'));
  //
  //   // Act: Build the widget
  //   await tester.pumpWidget(wrapWithProviders(const SearchPage()));
  //
  //   // Assert: Verify error message
  //   expect(find.text('Failed to load images'), findsOneWidget);
  // });
}
