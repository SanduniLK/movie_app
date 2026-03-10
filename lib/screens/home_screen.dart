import 'package:flutter/material.dart';
import 'package:movie_app/widgets/filter_chip.dart';
import 'package:movie_app/widgets/movie_card.dart';
import 'package:movie_app/widgets/search_bar.dart';
import 'package:movie_app/widgets/sidebar_widget.dart';
import 'package:movie_app/widgets/no_internet_widget.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../providers/connectivity_provider.dart';
import '../models/movie.dart';
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
    
    // Load popular movies on startup with connectivity check
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndLoadMovies();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkAndLoadMovies() async {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context, listen: false);
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    
    await connectivityProvider.checkConnectivity();
    
    if (connectivityProvider.isConnected) {
      movieProvider.fetchPopularMovies();
    }
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
    final connectivityProvider = Provider.of<ConnectivityProvider>(context, listen: false);
    
    if (!connectivityProvider.isConnected) {
      _showNoInternetSnackBar();
      return;
    }
    
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    
    if (filterType == 'rating') {
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
    
    final connectivityProvider = Provider.of<ConnectivityProvider>(context, listen: false);
    
    if (!connectivityProvider.isConnected) {
      _showNoInternetSnackBar();
      return;
    }
    
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

  void _showNoInternetSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.wifi_off, color: Colors.white),
            SizedBox(width: 10),
            Text('No internet connection'),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
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

  void _retryConnection() async {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context, listen: false);
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    
    await connectivityProvider.checkConnectivity();
    
    if (connectivityProvider.isConnected) {
      movieProvider.fetchPopularMovies();
    }
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
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);
    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App Bar with Sidebar Button
              SliverAppBar(
                expandedHeight: 120,
                collapsedHeight: kToolbarHeight, 
                floating: true,
                pinned: true,
                snap: true, 
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
                actions: [
                  // Internet connection indicator
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: connectivityProvider.isConnected
                            ? Colors.green.withValues(alpha: 0.2)
                            : Colors.red.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        connectivityProvider.isConnected
                            ? Icons.wifi
                            : Icons.wifi_off,
                        color: connectivityProvider.isConnected
                            ? Colors.green
                            : Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                ],
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
                            MovieSearchBar(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              isDarkMode: _isDarkMode,
                              onClear: _clearSearch,
                              onSearch: (query) {
                                if (query.isNotEmpty) {
                                  _searchMovies();
                                }
                              },
                            ),
                            const SizedBox(height: 16),
      
                            // Search Button
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: connectivityProvider.isConnected 
                                    ? _searchMovies 
                                    : _showNoInternetSnackBar,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: connectivityProvider.isConnected
                                      ? _accentColor
                                      : Colors.grey,
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
                                          FilterChipWidget(
                                            label: 'Year: ${movieProvider.currentYearFilter}',
                                            onDelete: () async {
                                              if (connectivityProvider.isConnected) {
                                                await movieProvider.applyFilters(year: 'All');
                                              } else {
                                                _showNoInternetSnackBar();
                                              }
                                            },
                                            accentColor: _accentColor,
                                          ),
                                        if (movieProvider.currentRatingFilter != "All")
                                          FilterChipWidget(
                                            label: 'Rating: ${movieProvider.currentRatingFilter}',
                                            onDelete: () async {
                                              if (connectivityProvider.isConnected) {
                                                await movieProvider.applyFilters(rating: 'All');
                                              } else {
                                                _showNoInternetSnackBar();
                                              }
                                            },
                                            accentColor: _accentColor,
                                          ),
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
      
              // Movie Grid or States - Complete with all states
              if (connectivityProvider.isChecking && !connectivityProvider.initialCheckDone)
                // Show checking connection state
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
                          "Checking connection...",
                          style: TextStyle(color: _secondaryTextColor, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                )
              else if (!connectivityProvider.isConnected && connectivityProvider.initialCheckDone)
                // Show no internet screen
                SliverFillRemaining(
                  child: NoInternetWidget(
                    onRetry: _retryConnection,
                  ),
                )
              else if (movieProvider.isLoading)
                // Show loading state
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
                          style: TextStyle(color: _secondaryTextColor, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                )
              else if (movieProvider.error.isNotEmpty)
                // Show error state
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
                          onPressed: connectivityProvider.isConnected
                              ? () => movieProvider.fetchPopularMovies()
                              : _retryConnection,
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
                // Show movie grid
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
                // Show empty state
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

  Widget _buildMovieCard(Movie movie, MovieProvider provider) {
    return MovieCard(
      movie: movie,
      futureDetail: provider.getMovieDetail(movie.imdbID),
      isDarkMode: _isDarkMode,
      accentColor: _accentColor,
      cardColor: _cardColor,
      secondaryTextColor: _secondaryTextColor,
    );
  }
}