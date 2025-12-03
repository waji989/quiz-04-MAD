import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/activity_provider.dart';
import 'screens/home_screen.dart';
class SmartTrackerApp extends StatelessWidget {
  const SmartTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1565C0), // deep blue
      brightness: Brightness.light,
    );

    return ChangeNotifierProvider(
      create: (_) => ActivityProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SmartTracker',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: colorScheme,
          scaffoldBackgroundColor: const Color(0xFFEAF3FF), // soft blue background

          appBarTheme: AppBarTheme(
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            centerTitle: false,
            titleTextStyle: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.4,
            ),
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: colorScheme.primary,
              elevation: 0,
              padding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          iconTheme: IconThemeData(
            color: colorScheme.primary,
            size: 26,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
