import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  static const String apiKey = "f7781c16";

  // Fetch popular/search movies
  static Future<List<Movie>> fetchMovies({String query = "batman"}) async {
    final url = Uri.parse("https://www.omdbapi.com/?s=$query&apikey=$apiKey");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['Response'] == "True") {
        List movies = data['Search'];
        return movies.map((m) => Movie.fromJson(m)).toList();
      } else {
        return []; // No results
      }
    } else {
      throw Exception("Failed to load movies");
    }
  }

  // Fetch detailed movie info
  static Future<Movie> fetchMovieDetail(String imdbID) async {
    final url = Uri.parse("https://www.omdbapi.com/?i=$imdbID&apikey=$apiKey");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['Response'] == "True") {
        return Movie.fromDetailJson(data);
      } else {
        throw Exception("Movie not found");
      }
    } else {
      throw Exception("Failed to load movie details");
    }
  }
}