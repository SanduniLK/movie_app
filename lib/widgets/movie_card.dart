import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: movie.poster != 'N/A'
            ? Image.network(movie.poster, width: 50, fit: BoxFit.cover)
            : const SizedBox(width: 50),
        title: Text(movie.title),
        subtitle: Text('${movie.year} • ${movie.type}'),
      ),
    );
  }
}