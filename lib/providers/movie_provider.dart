import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';

class MovieProvider extends ChangeNotifier {
  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _error = '';
  String get error => _error;

  Future<void> fetchMovies() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _movies = await ApiService.fetchPopularMovies();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Movie> searchMovies(String query) {
    if (query.isEmpty) return _movies;
    return _movies.where((movie) => movie.title.toLowerCase().contains(query.toLowerCase())).toList();
  }
}