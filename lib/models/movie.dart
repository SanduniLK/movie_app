class Movie {
  final String title;
  final String year;
  final String imdbID;
  final String type;
  final String poster;
  final String plot;       // For detailed info
  final String imdbRating; // For detailed info

  Movie({
    required this.title,
    required this.year,
    required this.imdbID,
    required this.type,
    required this.poster,
    this.plot = '',
    this.imdbRating = '',
  });

  // From search API
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      imdbID: json['imdbID'] ?? '',
      type: json['Type'] ?? '',
      poster: json['Poster'] ?? '',
    );
  }

  // From detail API
  factory Movie.fromDetailJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      imdbID: json['imdbID'] ?? '',
      type: json['Type'] ?? '',
      poster: json['Poster'] ?? '',
      plot: json['Plot'] ?? '',
      imdbRating: json['imdbRating'] ?? '',
    );
  }
}