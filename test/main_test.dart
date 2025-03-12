import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pixabay/feature/favourite/favorite_bloc.dart';
import 'package:pixabay/feature/search/search_bloc.dart';
import 'package:pixabay/feature/search/search_page.dart';

class MockSearchBloc extends Mock implements SearchBloc {}

class MockFavoriteBloc extends Mock implements FavoriteBloc {}

class FakeFavoriteState extends Fake implements FavoriteState {}

void main() {
  late MockSearchBloc mockSearchBloc;
  late MockFavoriteBloc mockFavoriteBloc;

  setUpAll(() {
    registerFallbackValue(FakeFavoriteState());
  });

  setUp(() {
    mockSearchBloc = MockSearchBloc();
    mockFavoriteBloc = MockFavoriteBloc();

    when(() => mockFavoriteBloc.stream).thenAnswer((_) => Stream<FavoriteState>.empty());
    when(() => mockFavoriteBloc.state).thenReturn(FavoriteInitial());
  });

  testWidgets('App loads and shows SearchPage', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<SearchBloc>.value(value: mockSearchBloc),
          BlocProvider<FavoriteBloc>.value(value: mockFavoriteBloc),
        ],
        child: const MaterialApp(
          home: SearchPage(),
        ),
      ),
    );

    expect(find.byType(SearchPage), findsOneWidget);
  });

  // testWidgets('Navigates to FavoriteScreen when clicking on route', (WidgetTester tester) async {
  //   await tester.pumpWidget(
  //     MultiBlocProvider(
  //       providers: [
  //         BlocProvider<SearchBloc>.value(value: mockSearchBloc),
  //         BlocProvider<FavoriteBloc>.value(value: mockFavoriteBloc),
  //       ],
  //       child: MaterialApp(
  //         home: SearchPage(),
  //         routes: {
  //           '/favorites': (context) => const FavoriteScreen(),
  //         },
  //       ),
  //     ),
  //   );
  //
  //   Navigator.of(tester.element(find.byType(SearchPage))).pushNamed('/favorites');
  //   await tester.pumpAndSettle();
  //
  //   expect(find.byType(FavoriteScreen), findsOneWidget);
  // });
}
