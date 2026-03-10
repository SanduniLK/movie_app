import 'package:flutter/material.dart';
import 'package:movie_app/models/MovieDetail.dart';
import 'package:movie_app/widgets/sidebar_widget.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../models/movie.dart';
import 'detail_screen.dart';
import '../utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final List<String> recentSearches = [];
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final FocusNode _searchFocusNode = FocusNode();
  bool _isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _animationController.forward();
    
    // Load popular movies on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final movieProvider = Provider.of<MovieProvider>(context, listen: false);
      movieProvider.fetchPopularMovies();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
  }

  void _openSidebar() {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: AppColors.getSurfaceColor(_isDarkMode),
        ),
        child: SidebarWidget(
          onFilterSelected: _handleFilterSelection,
          isDarkMode: _isDarkMode,
          onThemeToggle: _toggleTheme,
          selectedRating: movieProvider.currentRatingFilter,
          selectedYear: movieProvider.currentYearFilter,
        ),
      ),
    );
  }

  void _handleFilterSelection(String filterType, String value) async {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    
    if (filterType == 'rating') {
      // Apply rating filter while keeping current year filter
      await movieProvider.applyFilters(rating: value);
    } else if (filterType == 'year') {
      if (value == 'All') {
        await movieProvider.fetchPopularMovies();
      } else {
        await movieProvider.fetchMoviesByYear(value);
      }
    } else if (filterType == 'reset') {
      await movieProvider.resetFilters();
    }
  }

  void _searchMovies() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a movie name'),
          backgroundColor: AppColors.primaryRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    if (!recentSearches.contains(query)) {
      setState(() {
        recentSearches.insert(0, query);
        if (recentSearches.length > 5) {
          recentSearches.removeLast();
        }
      });
    }

    _searchFocusNode.unfocus();

    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    await movieProvider.fetchMovies(query);
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
    });
  }

  void _removeRecentSearch(int index) {
    setState(() {
      recentSearches.removeAt(index);
    });
  }

  Color get _backgroundColor => AppColors.getBackgroundColor(_isDarkMode);
  Color get _textColor => AppColors.getTextColor(_isDarkMode);
  Color get _secondaryTextColor => AppColors.getSecondaryTextColor(_isDarkMode);
  Color get _accentColor => AppColors.primaryRed;
  Color get _cardColor => AppColors.getCardColor(_isDarkMode);
  Color get _inputColor => AppColors.getInputColor(_isDarkMode);

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App Bar with Sidebar Button
              // Replace your existing SliverAppBar with this fixed version
SliverAppBar(
  expandedHeight: 120,
  collapsedHeight: kToolbarHeight, // Add this line
  floating: true,
  pinned: true,
  snap: true, // Add this line for better snapping
  backgroundColor: Colors.transparent,
  elevation: 0,
  leading: Padding(
    padding: const EdgeInsets.only(left: 8.0),
    child: IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _accentColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.menu,
          color: Colors.white60,
          size: 24,
        ),
      ),
      onPressed: _openSidebar,
    ),
  ),
  
  flexibleSpace: FlexibleSpaceBar(
    titlePadding: EdgeInsets.zero, 
    title: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min, 
        children: [
          Text(
            "MOVIE HUB",
            textAlign: TextAlign.center, 
            style: TextStyle(
              color: _textColor,
              fontWeight: FontWeight.bold,
              fontSize: screenSize.width * 0.06, 
              letterSpacing: 2,
              shadows: [
                Shadow(
                  color: _accentColor.withValues(alpha: 0.3),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          const SizedBox(height: 2), 
          Text(
            "Discover • Explore • Enjoy",
            textAlign: TextAlign.center, 
            style: TextStyle(
              color: _secondaryTextColor,
              fontSize: screenSize.width * 0.025, 
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8), 
        ],
      ),
    ),
    centerTitle: true,
    background: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _accentColor,
            _backgroundColor,
          ],
          stops: const [0.3, 1.0],
        ),
      ),
    ),
  ),
),
      
              // Main Content
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Search Bar
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: _accentColor.withValues(alpha: 0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _searchController,
                                focusNode: _searchFocusNode,
                                style: TextStyle(
                                  color: _textColor,
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search movies...',
                                  hintStyle: TextStyle(
                                    color: _secondaryTextColor,
                                  ),
                                  filled: true,
                                  fillColor: _inputColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: _accentColor,
                                  ),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.clear,
                                            color: _secondaryTextColor,
                                          ),
                                          onPressed: _clearSearch,
                                        )
                                      : null,
                                ),
                                onChanged: (value) => setState(() {}),
                                onSubmitted: (_) => _searchMovies(),
                              ),
                            ),
                            const SizedBox(height: 16),
      
                            // Search Button
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: _searchMovies,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _accentColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 5,
                                ),
                                child: const Text(
                                  'SEARCH',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
      
                            // Active Filters Display
                            if (movieProvider.currentYearFilter != "All" || 
                                movieProvider.currentRatingFilter != "All") ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _accentColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: _accentColor.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.filter_alt,
                                          color: _accentColor,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Active Filters:",
                                          style: TextStyle(
                                            color: _textColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        if (movieProvider.currentYearFilter != "All")
                                          _buildFilterChip('Year: ${movieProvider.currentYearFilter}', () async {
                                            await movieProvider.applyFilters(year: 'All');
                                          }),
                                        if (movieProvider.currentRatingFilter != "All")
                                          _buildFilterChip('Rating: ${movieProvider.currentRatingFilter}', () async {
                                            await movieProvider.applyFilters(rating: 'All');
                                          }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
      
                            // Category and Filter Info
                            if (movieProvider.currentCategory.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  movieProvider.currentCategory,
                                  style: TextStyle(
                                    color: _accentColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
      
                            // Recent Searches
                            if (recentSearches.isNotEmpty) ...[
                              Text(
                                "Recent Searches",
                                style: TextStyle(
                                  color: _textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 45,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: recentSearches.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Chip(
                                        label: Text(
                                          recentSearches[index],
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: _accentColor,
                                        onDeleted: () => _removeRecentSearch(index),
                                        deleteIcon: const Icon(
                                          Icons.close,
                                          size: 18,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 25),
                            ],
      
                            // Results Header
                            if (movieProvider.movies.isNotEmpty) ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Results",
                                    style: TextStyle(
                                      color: _textColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _accentColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "${movieProvider.movies.length} movies",
                                      style: TextStyle(
                                        color: _accentColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
      
              // Movie Grid or States
              if (movieProvider.isLoading)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: AppColors.primaryRed,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          movieProvider.currentRatingFilter != 'All'
                              ? "Filtering by rating..."
                              : "Searching...",
                          style: TextStyle(color: _secondaryTextColor),
                        ),
                      ],
                    ),
                  ),
                )
              else if (movieProvider.error.isNotEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: _accentColor,
                          size: 60,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Something went wrong",
                          style: TextStyle(
                            color: _textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          movieProvider.error,
                          style: TextStyle(
                            color: _secondaryTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => movieProvider.fetchPopularMovies(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accentColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text("Try Again"),
                        ),
                      ],
                    ),
                  ),
                )
              else if (movieProvider.movies.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenSize.width > 600 ? 3 : 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final movie = movieProvider.movies[index];
                        return _buildMovieCard(movie, movieProvider);
                      },
                      childCount: movieProvider.movies.length,
                    ),
                  ),
                )
              else
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.movie_filter,
                          size: 80,
                          color: _secondaryTextColor,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "No movies found",
                          style: TextStyle(
                            color: _secondaryTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          movieProvider.currentRatingFilter != 'All'
                              ? "No movies with rating ${movieProvider.currentRatingFilter}"
                              : "Try searching or applying filters",
                          style: TextStyle(
                            color: _secondaryTextColor.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onDelete) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _accentColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _accentColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: _accentColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: _accentColor.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                color: _accentColor,
                size: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(Movie movie, MovieProvider provider) {
    return FutureBuilder<MovieDetail?>(
      future: provider.getMovieDetail(movie.imdbID),
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
                    DetailScreen(imdbID: movie.imdbID, year: movie.year,isDarkMode: _isDarkMode,),
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
                                color: _cardColor,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: _accentColor,
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: _cardColor,
                                child: Icon(
                                  Icons.broken_image,
                                  color: _secondaryTextColor,
                                  size: 40,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: _cardColor,
                            child: Icon(
                              Icons.movie,
                              color: _secondaryTextColor,
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