import 'package:flutter/material.dart';
import 'screens/movie_list_screen.dart';
import 'screens/favorites_screen.dart';

void main() {
  runApp(MovieApp());
}

class MovieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MovieListScreen(),
        '/favorites': (context) => FavoritesScreen(),
      },
    );
  }
}