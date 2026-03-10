import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/movie_provider.dart';
import 'providers/connectivity_provider.dart'; // Add this
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()), 
      ],
      child: MaterialApp(
        title: 'Movie App',
        theme: ThemeData.dark(),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}