import 'package:flutter/material.dart';
import 'package:movie_app/models/MovieDetail.dart';
import '../models/movie.dart';

import '../services/api_service.dart';

class MovieProvider with ChangeNotifier {
  List<Movie> _movies = [];
  List<Movie> _allMovies = [];
  Map<String, MovieDetail> _movieDetails = {};
  bool _isLoading = false;
  String _error = '';
  String _currentCategory = '';
  String _currentYearFilter = 'All';
  String _currentRatingFilter = 'All';

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get currentCategory => _currentCategory;
  String get currentYearFilter => _currentYearFilter;
  String get currentRatingFilter => _currentRatingFilter;

  // Fetch popular movies
  Future<void> fetchPopularMovies() async {
    _isLoading = true;
    _error = '';
    _currentCategory = 'Popular Movies';
    _currentYearFilter = 'All';
    _currentRatingFilter = 'All';
    notifyListeners();

    try {
      _allMovies = await ApiService.fetchPopularMovies();
      _movies = List.from(_allMovies);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Fetch movies by search
  Future<void> fetchMovies(String query) async {
    _isLoading = true;
    _error = '';
    _currentCategory = 'Search: $query';
    _currentYearFilter = 'All';
    _currentRatingFilter = 'All';
    notifyListeners();

    try {
      _allMovies = await ApiService.fetchMovies(query);
      _movies = List.from(_allMovies);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Fetch movies by year
  Future<void> fetchMoviesByYear(String year) async {
    _isLoading = true;
    _error = '';
    _currentCategory = 'Year: $year';
    _currentYearFilter = year;
    _currentRatingFilter = 'All';
    notifyListeners();

    try {
      if (year.contains('-')) {
        _allMovies = await ApiService.fetchMoviesByYearRange(year);
      } else {
        _allMovies = await ApiService.fetchMoviesByYear(year);
      }
      _movies = List.from(_allMovies);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Apply filters
  Future<void> applyFilters({String? year, String? rating}) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (year != null) _currentYearFilter = year;
      if (rating != null) _currentRatingFilter = rating;

      List<Movie> filteredMovies = List.from(_allMovies);

      // Apply year filter
      if (_currentYearFilter != 'All') {
        filteredMovies = filteredMovies.where((movie) {
          int movieYear = int.tryParse(movie.year) ?? 0;
          
          if (_currentYearFilter.contains('-')) {
            List<String> range = _currentYearFilter.split('-');
            int start = int.parse(range[0]);
            int end = int.parse(range[1]);
            return movieYear >= start && movieYear <= end;
          } else {
            return movie.year == _currentYearFilter;
          }
        }).toList();
      }

      _movies = filteredMovies;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Reset filters
  Future<void> resetFilters() async {
    _currentYearFilter = 'All';
    _currentRatingFilter = 'All';
    _movies = List.from(_allMovies);
    notifyListeners();
  }
void clearMovies() {
  _movies = [];
  _allMovies = [];
  _movieDetails = {};
  _currentCategory = '';
  _currentYearFilter = 'All';
  _currentRatingFilter = 'All';
  notifyListeners();
}
  // Get movie detail
  Future<MovieDetail?> getMovieDetail(String imdbID) async {
    if (_movieDetails.containsKey(imdbID)) {
      return _movieDetails[imdbID];
    }
    
    try {
      final detail = await ApiService.fetchMovieDetail(imdbID);
      _movieDetails[imdbID] = detail;
      return detail;
    } catch (e) {
      return null;
    }
  }
}