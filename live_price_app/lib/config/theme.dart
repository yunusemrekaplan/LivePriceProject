import 'package:flutter/material.dart';

class AppTheme {
  // Ana renkler
  static const Color primaryColor = Color(0xFF3F51B5); // İndigo
  static const Color primaryDarkColor = Color(0xFF303F9F); // Koyu İndigo
  static const Color primaryLightColor = Color(0xFFC5CAE9); // Açık İndigo
  static const Color accentColor = Color(0xFFE53935); // Kırmızı

  // Statü renkleri
  static const Color increaseColor = Color(0xFF4CAF50); // Yeşil
  static const Color decreaseColor = Color(0xFFF44336); // Kırmızı
  static const Color neutralColor = Color(0xFF757575); // Gri

  // Arka plan renkleri
  static const Color scaffoldBackgroundColor = Color(0xFFF5F5F5); // Açık Gri
  static const Color cardColor = Colors.white;
  static const Color dividerColor = Color(0xFFD2D2D2); // Çok Açık Gri

  // Metin renkleri
  static const Color textPrimaryColor = Color(0xFF212121); // Neredeyse Siyah
  static const Color textSecondaryColor = Color(0xFF757575); // Gri
  static const Color textLightColor = Colors.white;

  // Bottom Navigation Bar
  static const Color navBarBackgroundColor = Colors.white;
  static const Color navBarSelectedColor = primaryColor;
  static const Color navBarUnselectedColor = Color(0xFF9E9E9E); // Orta Gri

  // Tema oluşturma
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        background: scaffoldBackgroundColor,
        surface: cardColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: textLightColor,
        elevation: 0,
      ),
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      cardTheme: const CardTheme(
        color: cardColor,
        elevation: 2,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: navBarBackgroundColor,
        selectedItemColor: navBarSelectedColor,
        unselectedItemColor: navBarUnselectedColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimaryColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textPrimaryColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textSecondaryColor,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondaryColor,
        ),
      ),
    );
  }
}
