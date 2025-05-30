import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color.fromRGBO(103, 58, 183, 1);
  static const Color lightWhite = Color.fromRGBO(252, 247, 255, 1);
  static const Color backgroundWhite = Color.fromRGBO(239, 235, 242, 1);
}

final font = GoogleFonts.nunitoSans(
  textStyle: const TextStyle(
    fontSize: 16,
    color: Colors.black,
    fontWeight: FontWeight.w600,
  ),
);

final brightTheme = ThemeData(
  brightness: Brightness.light,
  textTheme: GoogleFonts.nunitoSansTextTheme(
    const TextTheme(
      displayLarge: TextStyle(
        fontSize: 24,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        fontSize: 12,
        color: Colors.black,
      ),
      bodySmall: TextStyle(
        fontSize: 10,
        color: Colors.black,
      ),
      labelLarge: TextStyle(
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      labelMedium: TextStyle(
        fontSize: 13,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(
        fontSize: 13,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    isDense: true,
    floatingLabelAlignment: FloatingLabelAlignment.center,
    filled: true,
    fillColor: AppColors.lightWhite,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(20),
      ),
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    titleTextStyle: TextStyle(
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(AppColors.primary),
      foregroundColor: WidgetStateProperty.all(AppColors.backgroundWhite),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: Colors.grey[350],
    selectedColor: Colors.deepPurple,
    side: BorderSide.none,
    checkmarkColor: Colors.white,
    labelStyle: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey;
          }
          return Colors.deepPurple;
        },
      ),
      foregroundColor: WidgetStateProperty.all(Colors.white),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey;
          }
          return Colors.white;
        },
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.black;
          }
          return Colors.deepPurple;
        },
      ),
      side: WidgetStateProperty.all(
        const BorderSide(
          color: Colors.deepPurple,
        ),
      ),
      // shape: MaterialStateProperty.all(
      //   RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(14),
      //   ),
      // ),
    ),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    surface: AppColors.backgroundWhite,
  ),
  useMaterial3: true,
  listTileTheme: const ListTileThemeData(
    titleTextStyle: TextStyle(
      fontSize: 16,
      color: Colors.black,
    ),
    subtitleTextStyle: TextStyle(
      fontSize: 13,
      color: Colors.black,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  ),
);

extension Texttheme on BuildContext {
  TextTheme get tt => Theme.of(this).textTheme;
}

extension AppTheme on BuildContext {
  ThemeData get theme => Theme.of(this);
}
