class Movie {
  final String title;
  final String year;
  final String imdbID;
  final String type;
  final String poster;
  final String plot;        // for detailed info
  final String imdbRating;  // for rating

  Movie({
    required this.title,
    required this.year,
    required this.imdbID,
    required this.type,
    required this.poster,
    this.plot = "",
    this.imdbRating = "",
  });

  // From search API
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'],
      year: json['Year'],
      imdbID: json['imdbID'],
      type: json['Type'],
      poster: json['Poster'],
    );
  }

  // From detail API
  factory Movie.fromJsonDetail(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'],
      year: json['Year'],
      imdbID: json['imdbID'],
      type: json['Type'],
      poster: json['Poster'],
      plot: json['Plot'] ?? "No description available",
      imdbRating: json['imdbRating'] ?? "N/A",
    );
  }
}