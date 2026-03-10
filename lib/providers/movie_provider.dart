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

  // Fetch movies by search query
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
    _currentCategory = year.contains('-') ? 'Year: $year' : 'Year: $year';
    _currentYearFilter = year;
    _currentRatingFilter = 'All';
    notifyListeners();

    try {
      if (year == 'All') {
        await fetchPopularMovies();
        return;
      }
      
      if (year.contains('-')) {
        _allMovies = await ApiService.fetchMoviesByYearRange(year);
      } else if (year == 'Older') {
        _allMovies = await ApiService.fetchMoviesByYearRange('1900-1949');
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

  // Apply filters (year and rating)
  Future<void> applyFilters({String? year, String? rating}) async {
    _isLoading = true;
    notifyListeners();

    try {
      
      if (year != null) _currentYearFilter = year;
      if (rating != null) _currentRatingFilter = rating;

      // Start with all movies
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
          } else if (_currentYearFilter == 'Older') {
            return movieYear < 1950;
          } else {
            return movie.year == _currentYearFilter;
          }
        }).toList();
      }

      // Apply rating filter
      if (_currentRatingFilter != 'All') {
       
        List<Movie> moviesWithRatings = [];
        
        for (var movie in filteredMovies) {
          if (!_movieDetails.containsKey(movie.imdbID)) {
            try {
              final detail = await ApiService.fetchMovieDetail(movie.imdbID);
              _movieDetails[movie.imdbID] = detail;
              await Future.delayed(const Duration(milliseconds: 50)); 
            } catch (e) {
              continue;
            }
          }
          
          final detail = _movieDetails[movie.imdbID];
          if (detail != null && _movieMatchesRating(detail, _currentRatingFilter)) {
            moviesWithRatings.add(movie);
          }
        }
        
        filteredMovies = moviesWithRatings;
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

  // Helper method to check if movie matches rating
  bool _movieMatchesRating(MovieDetail detail, String ratingRange) {
    if (detail.imdbRating == 'N/A') return false;
    
    try {
      double rating = double.parse(detail.imdbRating);
      
      switch (ratingRange) {
        case '9+':
          return rating >= 9.0;
        case '8+':
          return rating >= 8.0;
        case '7+':
          return rating >= 7.0;
        case '6+':
          return rating >= 6.0;
        case '5+':
          return rating >= 5.0;
        case 'Below 5':
          return rating < 5.0 && rating > 0;
        default:
          return true;
      }
    } catch (e) {
      return false;
    }
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

  // Reset all filters
  Future<void> resetFilters() async {
    _currentYearFilter = 'All';
    _currentRatingFilter = 'All';
    _movies = List.from(_allMovies);
    notifyListeners();
  }

  // Clear 
  void clearMovies() {
    _movies = [];
    _allMovies = [];
    _movieDetails = {};
    _currentCategory = '';
    _currentYearFilter = 'All';
    _currentRatingFilter = 'All';
    notifyListeners();
  }
}