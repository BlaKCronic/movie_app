import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
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
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.network(
                        'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 250,
                      ),
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        height: 250,
                      ),
                      Positioned(
                        bottom: 16.0,
                        left: 16.0,
                        child: Text(
                          movie['title'],
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      movie['overview'],
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  RatingBarIndicator(
                    rating: movie['vote_average'] / 2,
                    itemCount: 5,
                    itemSize: 30.0,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Trailers',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  FutureBuilder<List<dynamic>>(
                    future: apiService.fetchMovieVideos(movieId),
                    builder: (context, videoSnapshot) {
                      if (videoSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (videoSnapshot.hasError) {
                        return Center(child: Text('Error: ${videoSnapshot.error}'));
                      } else {
                        final videos = videoSnapshot.data!;
                        return videos.isEmpty
                            ? const Center(child: Text('No hay trailers disponibles.'))
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: videos.length,
                                itemBuilder: (context, index) {
                                  final video = videos[index];
                                  if (video['site'] == 'YouTube') {
                                    final videoId = video['key'];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                      child: YoutubePlayer(
                                        controller: YoutubePlayerController(
                                          initialVideoId: videoId,
                                          flags: const YoutubePlayerFlags(
                                            autoPlay: false,
                                            mute: false,
                                          ),
                                        ),
                                        showVideoProgressIndicator: true,
                                      ),
                                    );
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                },
                              );
                      }
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
