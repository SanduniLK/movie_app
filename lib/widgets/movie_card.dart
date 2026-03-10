import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieCard({super.key, required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        leading: Image.network(
          movie.poster,
          width: 50,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image),
        ),
        title: Text(movie.title),
        subtitle: Text(movie.year),
        onTap: onTap,
      ),
    );
  }
}