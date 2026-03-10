import 'package:flutter/material.dart';
import 'package:movie_app/models/MovieDetail.dart';

import '../services/api_service.dart';

class DetailScreen extends StatefulWidget {
  final String imdbID;
  const DetailScreen({super.key, required this.imdbID});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<MovieDetail> movieDetail;

  @override
  void initState() {
    super.initState();
    movieDetail = ApiService.fetchMovieDetail(widget.imdbID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Movie Details"),
        backgroundColor: Colors.red[900],
      ),
      body: FutureBuilder<MovieDetail>(
        future: movieDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.red));
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              snapshot.error.toString(),
              style: const TextStyle(color: Colors.red),
            ));
          } else if (!snapshot.hasData) {
            return const Center(
                child: Text("No Data Found", style: TextStyle(color: Colors.white)));
          }

          final movie = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: movie.poster != 'N/A'
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(movie.poster, height: 300),
                        )
                      : const Icon(Icons.movie, size: 150, color: Colors.red),
                ),
                const SizedBox(height: 12),
                Text(
                  movie.title,
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Year: ${movie.year}", style: const TextStyle(color: Colors.grey)),
                    Text("IMDB: ${movie.imdbRating}", style: const TextStyle(color: Colors.red)),
                  ],
                ),
                const SizedBox(height: 8),
                Text("Genre: ${movie.genre}", style: const TextStyle(color: Colors.grey)),
                Text("Director: ${movie.director}", style: const TextStyle(color: Colors.grey)),
                Text("Actors: ${movie.actors}", style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 12),
                const Text(
                  "Plot",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(movie.plot, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}