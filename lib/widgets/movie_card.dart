import 'package:flutter/material.dart';
import 'package:movie_app/models/MovieDetail.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/screens/detail_screen.dart';


class MovieCard extends StatelessWidget {
  final Movie movie;
  final Future<MovieDetail?> futureDetail;
  final bool isDarkMode;
  final Color accentColor;
  final Color cardColor;
  final Color secondaryTextColor;

  const MovieCard({
    super.key,
    required this.movie,
    required this.futureDetail,
    required this.isDarkMode,
    required this.accentColor,
    required this.cardColor,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MovieDetail?>(
      future: futureDetail,
      builder: (context, snapshot) {
        String rating = 'N/A';
        if (snapshot.hasData && snapshot.data != null && snapshot.data!.imdbRating != 'N/A') {
          rating = snapshot.data!.imdbRating;
        }
        
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => 
                    DetailScreen(
                      imdbID: movie.imdbID, 
                      year: movie.year,
                      isDarkMode: isDarkMode,
                    ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  // Poster
                  Positioned.fill(
                    child: movie.poster != 'N/A'
                        ? Image.network(
                            movie.poster,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: cardColor,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: accentColor,
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: cardColor,
                                child: Icon(
                                  Icons.broken_image,
                                  color: secondaryTextColor,
                                  size: 40,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: cardColor,
                            child: Icon(
                              Icons.movie,
                              color: secondaryTextColor,
                              size: 40,
                            ),
                          ),
                  ),
                  
                  // Gradient Overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                movie.year,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (rating != 'N/A')
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: double.tryParse(rating) != null && double.parse(rating) >= 7.0
                                        ? Colors.amber
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.black,
                                        size: 10,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        rating,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Loading indicator for rating
                  if (snapshot.connectionState == ConnectionState.waiting)
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}