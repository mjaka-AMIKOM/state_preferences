import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/user_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    // Latihan 4: Gunakan ChangeNotifierProvider
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Latihan 4: Consumer untuk mendengarkan perubahan state
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return MaterialApp(
          title: 'State & Preferences',
          debugShowCheckedModeBanner: false,
          
          // Latihan 1: Terapkan tema sesuai preferensi
          themeMode: userProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          
          home: const HomeScreen(),
        );
      },
    );
  }
}