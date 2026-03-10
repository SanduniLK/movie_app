import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/models/MovieDetail.dart';
import '../models/movie.dart';

class ApiService {
  static const String apiKey = "f7781c16";
  static const String baseUrl = "https://www.omdbapi.com/";

  // Fetch movies by search query
  static Future<List<Movie>> fetchMovies(String query) async {
    final url = Uri.parse(
      "$baseUrl?s=${Uri.encodeComponent(query)}&apikey=$apiKey"
    );

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

  // Fetch movies by year
  static Future<List<Movie>> fetchMoviesByYear(String year) async {
    final url = Uri.parse(
      "$baseUrl?s=movie&y=$year&apikey=$apiKey"
    );

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

  // Fetch movies by year range
  static Future<List<Movie>> fetchMoviesByYearRange(String yearRange) async {
    List<String> range = yearRange.split('-');
    int startYear = int.parse(range[0]);
    int endYear = int.parse(range[1]);
    
    List<Movie> allMovies = [];
    Set<String> seenIds = {};
    
    for (int year = startYear; year <= endYear; year += 2) {
      try {
        final movies = await fetchMoviesByYear(year.toString());
        
        for (var movie in movies) {
          if (!seenIds.contains(movie.imdbID)) {
            seenIds.add(movie.imdbID);
            allMovies.add(movie);
          }
        }
        
        await Future.delayed(const Duration(milliseconds: 100));
      } catch (e) {
        continue;
      }
    }
    
    return allMovies;
  }

  // Fetch popular movies
  static Future<List<Movie>> fetchPopularMovies() async {
    List<Movie> allMovies = [];
    Set<String> seenIds = {};
    
    final List<String> popularQueries = [
      'avengers', 'star wars', 'harry potter', 'inception', 
      'matrix', 'titanic', 'avatar', 'joker', 'dark knight',
      'spider-man', 'batman', 'superman'
    ];

    for (String query in popularQueries) {
      try {
        final url = Uri.parse(
          "$baseUrl?s=${Uri.encodeComponent(query)}&apikey=$apiKey"
        );

        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['Response'] == "True") {
            List movies = data['Search'];
            for (var movieJson in movies) {
              String imdbID = movieJson['imdbID'];
              if (!seenIds.contains(imdbID)) {
                seenIds.add(imdbID);
                allMovies.add(Movie.fromJson(movieJson));
              }
            }
          }
        }
        
        await Future.delayed(const Duration(milliseconds: 100));
      } catch (e) {
        continue;
      }
    }
    
    return allMovies;
  }

  // Fetch full details for a movie
  static Future<MovieDetail> fetchMovieDetail(String imdbID) async {
    final url = Uri.parse(
      "$baseUrl?i=$imdbID&apikey=$apiKey&plot=full"
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['Response'] == "True") {
        return MovieDetail.fromJson(data);
      } else {
        throw Exception("Movie not found");
      }
    } else {
      throw Exception("Failed to load movie detail");
    }
  }
}