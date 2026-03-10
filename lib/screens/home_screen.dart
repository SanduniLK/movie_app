import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../models/movie.dart';
import 'detail_screen.dart'; // Make sure this imports DetailScreen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Movie Search")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Movies',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    final query = _searchController.text.trim();
                    movieProvider.fetchMovies(query);
                  },
                ),
              ),
              onSubmitted: (query) {
                movieProvider.fetchMovies(query.trim());
              },
            ),
            const SizedBox(height: 20),
            if (movieProvider.isLoading)
              const CircularProgressIndicator(),
            if (movieProvider.error.isNotEmpty)
              Text(movieProvider.error),
            if (!movieProvider.isLoading && movieProvider.movies.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: movieProvider.movies.length,
                  itemBuilder: (context, index) {
                    final Movie movie = movieProvider.movies[index]; // Explicit type
                    return ListTile(
                      leading: movie.poster != 'N/A'
                          ? Image.network(movie.poster, width: 50)
                          : const Icon(Icons.movie),
                      title: Text(movie.title),
                      subtitle: Text("${movie.year} | ${movie.type}"),
                      onTap: () {
                        // Navigate and pass movie
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(imdbID: movie.imdbID),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}