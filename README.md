# 🎬 Movie Discovery App

A **Flutter movie browsing application** that allows users to explore popular movies, search by title, and view detailed movie information.

This project demonstrates **API integration, Provider state management, and responsive UI design**.

---

## 🚀 Features

✨ **Popular Movies**
Browse a curated list of popular movies on the home screen.

🔎 **Search Movies**
Search movies easily by entering a movie title.

🎥 **Movie Details**
Tap a movie card to view full details including poster, description, and IMDb rating.

🎛 **Filters**
Filter movies by:

* ⭐ Rating
* 📅 Release Year

🕘 **Recent Searches**
Displays the last **5 searches** for quick access.

⚠ **Error Handling**
Handles situations such as:

* No results found
* API errors
* Loading states

---

## 🧠 State Management

This application uses **Provider** for state management.

**MovieProvider** manages:

* Movie list
* Search results
* Filters (rating & year)
* Loading and error states

Provider automatically **rebuilds UI widgets when data changes**, ensuring a reactive and consistent interface.

---

## 🛠 Getting Started

### Prerequisites

* Flutter SDK installed
* Android Studio / VS Code
* Internet connection

---

### 📥 Installation

Clone the repository:

```bash
git clone https://github.com/SanduniLK/movie_app
cd movie_app
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

You can run the app on **an emulator or a physical device**.

---

## 🌟 Bonus Features

🌙 **Dark / Light Theme Toggle**
Switch between dark and light mode.

🎞 **Smooth Animations**
Fade and slide animations on home screen content.

🏷 **Filter Chips**
Active filters appear as removable chips.

📱 **Responsive Layout**
Optimized for both **mobile and tablet screens**.

---

## 🔮 Future Improvements


* Implement **pagination for movie lists**
* Add **Favorites / Watchlist**
* Improve **UI polish and animations**

---

## 🌐 API Used

**OMDb API**
An online movie database API used to fetch movie data.

API Key required.

---

## 💻 Built With

* Flutter
* Dart
* Provider
* OMDb API - follow-> https://www.omdbapi.com/apikey.aspx

---

## 👩‍💻 Author

Developed by **Reshika Sanduni**
Bachelor of Information Technology – University of Moratuwa
