import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/models/MovieDetail.dart';
import 'package:movie_app/models/movie.dart';


class ApiService {
  static const String apiKey = "f7781c16";

  // Fetch movie search results
  static Future<List<Movie>> fetchMovies(String query) async {
    final url = Uri.parse(
        "https://www.omdbapi.com/?s=${Uri.encodeComponent(query)}&apikey=$apiKey");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['Response'] == "True") {
        List movies = data['Search'];
        return movies.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception("Failed to load movies");
    }
  }

  // Fetch details by imdbID
  static Future<MovieDetail> fetchMovieDetail(String imdbID) async {
    final url =
        Uri.parse("https://www.omdbapi.com/?i=$imdbID&apikey=$apiKey");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['Response'] == "True") {
        return MovieDetail.fromJson(data);
      } else {
        throw Exception("Movie not found");
      }
    } else {
      throw Exception("Failed to load movie details");
    }
  }
}