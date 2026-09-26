import 'package:google_fonts/google_fonts.dart';
import 'package:bitacoras_app/shared/exports.dart';


class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColores.primary,
        onPrimary: AppColores.surface,
        secondary: AppColores.secondary,
        onSecondary: AppColores.surface,
        error: AppColores.error,
        onError: AppColores.surface,
        surface: AppColores.surface,
        onSurface: AppColores.textPrimary,
      ),
      scaffoldBackgroundColor: AppColores.background,
      dividerColor: AppColores.divider,
      fontFamily: GoogleFonts.poppins().fontFamily,
      textTheme: TextTheme(
        headlineLarge: AppEstiloTexto.heading,
        headlineMedium: AppEstiloTexto.title,
        titleLarge: AppEstiloTexto.title,
        bodyLarge: AppEstiloTexto.body,
        bodyMedium: AppEstiloTexto.body,
        labelLarge: AppEstiloTexto.button,
        bodySmall: AppEstiloTexto.caption,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColores.primary,
        foregroundColor: AppColores.surface,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColores.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTamanos.md,
          vertical: 15,
        ),
        labelStyle: const TextStyle(color: AppColores.textSecondary),
        floatingLabelStyle: const TextStyle(color: AppColores.primary),
        hintStyle: const TextStyle(
          color: AppColores.textHint,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
          borderSide: const BorderSide(
            color: AppColores.outline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
          borderSide: const BorderSide(
            color: AppColores.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
          borderSide: const BorderSide(
            color: AppColores.primary,
            width: 2,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          backgroundColor: AppColores.primary,
          foregroundColor: AppColores.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 54),
          backgroundColor: AppColores.primary,
          foregroundColor: AppColores.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
          ),
          textStyle: AppEstiloTexto.button,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColores.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTamanos.radiusLg),
        ),
      ),
    );
  }
}