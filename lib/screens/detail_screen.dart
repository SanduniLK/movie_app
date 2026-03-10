import 'package:flutter/material.dart';
import 'package:movie_app/models/MovieDetail.dart';
import '../services/api_service.dart';
import '../utils/colors.dart';

class DetailScreen extends StatefulWidget {
  final String imdbID;
  final String year;
  final bool isDarkMode; 

  const DetailScreen({
    super.key, 
    required this.imdbID, 
    required this.year,
    required this.isDarkMode, 
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isLoading = true;
  MovieDetail? movieDetail;

  @override
  void initState() {
    super.initState();
    loadDetail();
  }

  Future<void> loadDetail() async {
    try {
      final detail = await ApiService.fetchMovieDetail(widget.imdbID);
      setState(() {
        movieDetail = detail;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use the passed theme state instead of detecting from context
    final bool isDarkMode = widget.isDarkMode;
    
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: AppColors.primaryRed,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Loading movie details...",
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            )
          : movieDetail == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColors.primaryRed,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Failed to load details",
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Please try again",
                        style: TextStyle(
                          color: isDarkMode ? Colors.white60 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: loadDetail,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                )
              : CustomScrollView(
                  slivers: [
                  
                    SliverAppBar(
                      expandedHeight: 350,
                      pinned: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDarkMode 
                              ? Colors.black.withValues(alpha: 0.5)
                              : Colors.white.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Poster
                            if (movieDetail!.poster != 'N/A')
                              Image.network(
                                movieDetail!.poster,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: isDarkMode ? Colors.grey[900] : Colors.grey[300],
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 80,
                                      color: isDarkMode ? Colors.white54 : Colors.black54,
                                    ),
                                  );
                                },
                              )
                            else
                              Container(
                                color: isDarkMode ? Colors.grey[900] : Colors.grey[300],
                                child: Icon(
                                  Icons.movie,
                                  size: 80,
                                  color: isDarkMode ? Colors.white54 : Colors.black54,
                                ),
                              ),
                            
                            
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    isDarkMode 
                                        ? Colors.black.withValues(alpha: 0.8)
                                        : Colors.white.withValues(alpha: 0.8),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Movie details
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Title
                          Text(
                            movieDetail!.title,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Year and Rating row
                          Row(
                            children: [
                              // Year chip
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryRed,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  widget.year,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              
                              // Rating
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    movieDetail!.imdbRating != 'N/A' 
                                        ? movieDetail!.imdbRating 
                                        : 'N/A',
                                    style: TextStyle(
                                      color: isDarkMode ? Colors.white : Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Plot section
                          if (movieDetail!.plot != 'N/A') ...[
                            Text(
                              "Storyline",
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDarkMode 
                                    ? Colors.grey[900] 
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDarkMode 
                                      ? Colors.grey[800]! 
                                      : Colors.grey[300]!,
                                ),
                              ),
                              child: Text(
                                movieDetail!.plot,
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white70 : Colors.black87,
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ]),
                      ),
                    ),
                  ],
                ),
    );
  }
}