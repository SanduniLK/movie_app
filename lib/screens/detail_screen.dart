import 'package:flutter/material.dart';
import '../models/movie.dart';

class DetailScreen extends StatelessWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            movie.poster != 'N/A'
                ? Image.network(movie.poster)
                : const Icon(Icons.movie, size: 100),
            const SizedBox(height: 16),
            Text(
              movie.title,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Year: ${movie.year}'),
            Text('Type: ${movie.type}'),
            const SizedBox(height: 16),
            // Add description if available
            Text('IMDB ID: ${movie.imdbID}'),
          ],
        ),
      ),
    );
  }
}