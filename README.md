Movie Discovery App

A Flutter application that allows users to browse popular movies, search for movies by title, and view detailed movie information. This project demonstrates API integration, state management, and a responsive UI design.

State Management

This app uses Provider as the state management solution.

MovieProvider manages the list of movies, search results, filters (rating, year), and loading/error states.

Provider ensures that UI widgets rebuild automatically when movie data or filters change, keeping the UI reactive and consistent.

Features

Home Screen: Displays a curated list of popular movies.

Search Functionality: Users can search movies by title.

Movie Details: Tap a movie to view full poster, description, and IMDb rating.

Filters: Filter movies by year or rating.

Recent Searches: Shows a list of recent search queries for convenience.

Error Handling: Handles empty responses, no results found, and loading/error states.

Getting Started
Prerequisites

Flutter SDK installed (Flutter installation guide
)Installation

Clone this repository:

git clone https://github.com/yourusername/movie-discovery-app.git
cd movie-discovery-app

Install dependencies:

flutter pub get

Run the app:

flutter run

The app can be run on an emulator or a physical device.

Optional / Bonus Features

Dark & Light Theme Toggle: Switch between dark and light mode.

Recent Searches: Stores last 5 searches for quick access.

Smooth Animations: Fade and slide animations on home screen content.

Filter Chips: Active filters are displayed with removable chips.

Responsive Layout: Works well on both mobile and tablet screen sizes.

Future Improvements:

Add connectivity check for offline handling.

Add pagination for popular movies and search results.

Integrate favorites or watchlist functionality.

Improve UI design and animations for a more polished look.

API Used

OMDb API
 (API Key required)

An IDE such as VS Code or Android Studio

Internet connection to fetch movie data from the OMDb API
