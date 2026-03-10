import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/search_bar.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Movie App")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SearchBar(),
            const SizedBox(height: 12),
            if (movieProvider.isLoading)
              const CircularProgressIndicator(),
            if (movieProvider.error.isNotEmpty)
              Text(movieProvider.error),
            if (!movieProvider.isLoading && movieProvider.movies.isEmpty)
              const Text("No movies found"),
            Expanded(
              child: ListView.builder(
                itemCount: movieProvider.movies.length,
                itemBuilder: (context, index) {
                  final movie = movieProvider.movies[index];
                  return MovieCard(movie: movie);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}