import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';

class MovieSearchBar extends StatelessWidget {
  const MovieSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Search movies...',
        border: OutlineInputBorder(),
      ),
      onSubmitted: (value) {
        Provider.of<MovieProvider>(context, listen: false).fetchMovies(value);
      },
    );
  }
}