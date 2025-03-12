import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pixabay/feature/favourite/favorite_bloc.dart';
import 'package:pixabay/feature/search/search_bloc.dart';
import 'package:pixabay/feature/search/search_page.dart';

class MockSearchBloc extends Mock implements SearchBloc {}

class MockFavoriteBloc extends Mock implements FavoriteBloc {}

class FakeSearchEvent extends Fake implements SearchEvent {}

void main() {
  late MockSearchBloc mockSearchBloc;
  late MockFavoriteBloc mockFavoriteBloc;

  setUpAll(() {
    registerFallbackValue(FakeSearchEvent());
  });

  setUp(() {
    mockSearchBloc = MockSearchBloc();
    mockFavoriteBloc = MockFavoriteBloc();
  });

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
    when(() => mockSearchBloc.state).thenReturn(SearchInitial());

    await tester.pumpWidget(wrapWithProviders(const SearchPage()));

    expect(find.text('Search Image'), findsOneWidget);
    expect(find.text('Start searching for image!'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}
