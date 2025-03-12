import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixabay/feature/search/search_page.dart';

import 'feature/favourite/favorite_bloc.dart';
import 'feature/favourite/favorite_screen.dart';
import 'feature/search/search_bloc.dart';
import 'feature/search/search_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SearchBloc(SearchRepository()),
        ),
        BlocProvider(
          create: (context) => FavoriteBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Pixabay Search',
        debugShowCheckedModeBanner: false,
        home: const SearchPage(),
        routes: {
          '/favorites': (context) => const FavoriteScreen(),
        },
      ),
    );
  }
}
