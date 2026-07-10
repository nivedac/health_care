import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- DASHBOARD (BLUE) PALETTE ---
  static const Color dashPrimary = Color(0xFF0058bc);
  static const Color dashOnPrimary = Color(0xFFffffff);
  static const Color dashPrimaryContainer = Color(0xFF0070eb);
  static const Color dashOnPrimaryContainer = Color(0xFFfefcff);
  static const Color dashSecondary = Color(0xFF505f76);
  static const Color dashOnSecondary = Color(0xFFffffff);
  static const Color dashSecondaryContainer = Color(0xFFd0e1fb);
  static const Color dashOnSecondaryContainer = Color(0xFF54647a);
  static const Color dashSurface = Color(0xFFf7f9fb);
  static const Color dashOnSurface = Color(0xFF191c1e);

  // --- PATIENT (GREEN) PALETTE ---
  static const Color patPrimary = Color(0xFF006a3b);
  static const Color patOnPrimary = Color(0xFFffffff);
  static const Color patPrimaryContainer = Color(0xFF268451);
  static const Color patOnPrimaryContainer = Color(0xFFf6fff4);
  static const Color patSecondary = Color(0xFF56615c);
  static const Color patOnSecondary = Color(0xFFffffff);
  static const Color patSecondaryContainer = Color(0xFFdae5df);
  static const Color patOnSecondaryContainer = Color(0xFF5c6762);
  static const Color patSurface = Color(0xFFf8f9fa);
  static const Color patOnSurface = Color(0xFF191c1d);
  
  // Shared
  static const Color error = Color(0xFFba1a1a);
  static const Color onError = Color(0xFFffffff);

  static ThemeData get dashboardTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: dashPrimary,
        onPrimary: dashOnPrimary,
        primaryContainer: dashPrimaryContainer,
        onPrimaryContainer: dashOnPrimaryContainer,
        secondary: dashSecondary,
        onSecondary: dashOnSecondary,
        secondaryContainer: dashSecondaryContainer,
        onSecondaryContainer: dashOnSecondaryContainer,
        error: error,
        onError: onError,
        surface: dashSurface,
        onSurface: dashOnSurface,
      ),
      textTheme: GoogleFonts.interTextTheme(),
      scaffoldBackgroundColor: dashSurface,
    );
  }

  static ThemeData get patientTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: patPrimary,
        onPrimary: patOnPrimary,
        primaryContainer: patPrimaryContainer,
        onPrimaryContainer: patOnPrimaryContainer,
        secondary: patSecondary,
        onSecondary: patOnSecondary,
        secondaryContainer: patSecondaryContainer,
        onSecondaryContainer: patOnSecondaryContainer,
        error: error,
        onError: onError,
        surface: patSurface,
        onSurface: patOnSurface,
      ),
      textTheme: GoogleFonts.interTextTheme(),
      scaffoldBackgroundColor: patSurface,
    );
  }
}
