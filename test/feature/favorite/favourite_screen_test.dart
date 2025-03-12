import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pixabay/feature/favourite/favorite_bloc.dart';
import 'package:pixabay/feature/favourite/favorite_screen.dart';

class MockFavoriteBloc extends Mock implements FavoriteBloc {}

void main() {
  late MockFavoriteBloc mockFavoriteBloc;

  setUp(() {
    mockFavoriteBloc = MockFavoriteBloc();

    when(() => mockFavoriteBloc.stream).thenAnswer((_) => Stream.value(FavoriteInitial()));
    when(() => mockFavoriteBloc.state).thenReturn(FavoriteInitial());
    when(() => mockFavoriteBloc.favorites).thenReturn([]);
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: BlocProvider<FavoriteBloc>.value(
        value: mockFavoriteBloc,
        child: const FavoriteScreen(),
      ),
    );
  }

  group('FavoriteScreen UI Tests', () {
    testWidgets('displays "No favorites yet!" when favorites list is empty', (WidgetTester tester) async {
      when(() => mockFavoriteBloc.state).thenReturn(FavoritesUpdated([]));
      when(() => mockFavoriteBloc.favorites).thenReturn([]);

      await tester.pumpWidget(createTestWidget());

      expect(find.text('No favorites yet!'), findsOneWidget);
    });
  });
}
