import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;
  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Movie? detailedMovie;
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    try {
      final movieDetail = await ApiService.fetchMovieDetail(widget.movie.imdbID);
      setState(() {
        detailedMovie = movieDetail;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (error.isNotEmpty) return Scaffold(body: Center(child: Text(error)));

    final movie = detailedMovie!;
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(
              movie.poster,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 100),
            ),
            const SizedBox(height: 16),
            Text(movie.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("Year: ${movie.year}"),
            Text("Rating: ${movie.imdbRating}"),
            const SizedBox(height: 16),
            Text(movie.plot),
          ],
        ),
      ),
    );
  }
}