class MovieDetail {
  final String title;
  final String year;
  final String rated;
  final String released;
  final String runtime;
  final String genre;
  final String director;
  final String actors;
  final String plot;
  final String poster;
  final String imdbRating;

  MovieDetail({
    required this.title,
    required this.year,
    required this.rated,
    required this.released,
    required this.runtime,
    required this.genre,
    required this.director,
    required this.actors,
    required this.plot,
    required this.poster,
    required this.imdbRating,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      title: json['Title'] ?? 'N/A',
      year: json['Year'] ?? 'N/A',
      rated: json['Rated'] ?? 'N/A',
      released: json['Released'] ?? 'N/A',
      runtime: json['Runtime'] ?? 'N/A',
      genre: json['Genre'] ?? 'N/A',
      director: json['Director'] ?? 'N/A',
      actors: json['Actors'] ?? 'N/A',
      plot: json['Plot'] ?? 'N/A',
      poster: json['Poster'] ?? 'N/A',
      imdbRating: json['imdbRating'] ?? 'N/A',
    );
  }
}