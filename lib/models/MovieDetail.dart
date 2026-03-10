class MovieDetail {
  final String title;
  final String poster;
  final String plot;
  final String imdbRating;

  MovieDetail({
    required this.title,
    required this.poster,
    required this.plot,
    required this.imdbRating,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      title: json['Title'] ?? "No title",
      poster: json['Poster'] ?? "",
      plot: json['Plot'] ?? "No description available",
      imdbRating: json['imdbRating'] ?? "N/A",
    );
  }
}