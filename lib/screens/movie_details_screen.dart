import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import './services/api_service.dart';

class MovieDetailsScreen extends StatelessWidget {
  final int movieId;
  final ApiService apiService = ApiService();

  MovieDetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles de la Película')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: apiService.fetchMovieDetails(movieId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final movie = snapshot.data!;
            return Stack(
              children: [
                Image.network(
                  'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Container(
                  color: Colors.black.withOpacity(0.5),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        movie['title'],
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    RatingBarIndicator(
                      rating: movie['vote_average'] / 2,
                      itemCount: 5,
                      itemSize: 30.0,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        movie['overview'],
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
