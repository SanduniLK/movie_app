import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  static const String apiKey = 'YOUR_TMDB_API_KEY';
  static const String baseUrl = 'https://api.themoviedb.org/3';

  static Future<List<Movie>> fetchPopularMovies() async {
    final url = Uri.parse('$baseUrl/movie/popular?api_key=$apiKey&language=en-US&page=1');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List movies = data['results'];
        return movies.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      throw Exception('No Internet Connection or API error');
    }
  }
}