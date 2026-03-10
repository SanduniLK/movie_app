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

  Future<void> fetchMovies(String query) async {
    if (query.isEmpty) return;

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _movies = await ApiService.fetchMovies(query);
      if (_movies.isEmpty) {
        _error = 'No movies found';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}