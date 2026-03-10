import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  static const String apiKey = "f7781c16";

  static Future<List<Movie>> fetchMovies(String query) async {
    if (query.isEmpty) return [];

    final url = Uri.parse("https://www.omdbapi.com/?s=$query&apikey=$apiKey");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['Response'] == 'True') {
        List movies = data["Search"];
        return movies.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception("Failed to load movies");
    }
  }
}