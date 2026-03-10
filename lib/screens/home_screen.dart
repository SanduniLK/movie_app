import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';
import 'detail_screen.dart';
import '../models/movie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';

  @override
  @override
void initState() {
  super.initState();
  // Run after the first frame to avoid setState during build
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<MovieProvider>(context, listen: false).fetchMovies();
  });
}

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovieProvider>(context);
    List<Movie> displayMovies = provider.searchMovies(searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Movies',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.error.isNotEmpty
                    ? Center(child: Text(provider.error))
                    : displayMovies.isEmpty
                        ? const Center(child: Text('No Results Found'))
                        : ListView.builder(
                            itemCount: displayMovies.length,
                            itemBuilder: (context, index) {
                              final movie = displayMovies[index];
                              return MovieCard(
                                movie: movie,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailScreen(movie: movie),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}