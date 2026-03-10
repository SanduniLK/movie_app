import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieCard({super.key, required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: movie.posterPath.isNotEmpty
            ? Image.network('https://image.tmdb.org/t/p/w200${movie.posterPath}')
            : const SizedBox(width: 50, child: Placeholder()),
        title: Text(movie.title),
        subtitle: Text('Release: ${movie.releaseDate}'),
      ),
    );
  }
}