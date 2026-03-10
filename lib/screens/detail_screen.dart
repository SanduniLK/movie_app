import 'package:flutter/material.dart';
import '../models/movie.dart';

class DetailScreen extends StatelessWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            movie.posterPath.isNotEmpty
                ? Image.network('https://image.tmdb.org/t/p/w500${movie.posterPath}')
                : const Placeholder(fallbackHeight: 250),
            const SizedBox(height: 16),
            Text(
              movie.overview,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text('Rating: ${movie.rating} ⭐', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Release Date: ${movie.releaseDate}'),
          ],
        ),
      ),
    );
  }
}