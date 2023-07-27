import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

abstract class AppColors {
  static const secondary = Color(0xFF3E1869);
  static const accent = Color(0xFFD6755B);
  static const textDark = Color(0xFF53585A);
  static const textLight = Color(0xFFF5F5F5);
  static const textFaded = Color(0xFF9899A5);
  static const iconLight = Color(0xFFB1B4C0);
  static const iconDark = Color(0xFFB1B3C1);
  static const textHighlight = secondary;
  static const cardLight = Color(0xFFF9FAFE);
  static const cardDark = Color(0xFF303334);
}

abstract class _LightColors {
  static const background = Colors.white;
  // static const card = AppColors.cardLight;
}

abstract class _DarkColors {
  static const background = Color(0xFF1B1E1F);
  // static const card = AppColors.cardDark;
}

/// Reference to the application theme.
class AppTheme {
  static const accentColor = AppColors.accent;
  static final visualDensity = VisualDensity.adaptivePlatformDensity;

  final darkBase = ThemeData.dark();
  final lightBase = ThemeData.light();

  /// Light theme and its settings.
  ThemeData get light => ThemeData(
    primaryColor: AppColors.secondary,
    brightness: Brightness.light,
    colorScheme: lightBase.colorScheme.copyWith(primary: Colors.black, secondary: AppColors.secondary),
    visualDensity: visualDensity,
    textTheme: TextTheme(
    headline1: GoogleFonts.nunito(
      textStyle:  const TextStyle(
        color: Colors.white,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
        fontSize: 20,
    ),),
    headline2: GoogleFonts.nunito(
      textStyle: const TextStyle(
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
        color: AppColors.secondary,
        fontSize: 30
      ),
    ),
      headline3: GoogleFonts.nunito(
        textStyle: const TextStyle(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16
        ),
      ),
    ),
    // GoogleFonts.mulishTextTheme().apply(bodyColor: AppColors.textDark),
    backgroundColor: _LightColors.background,
    appBarTheme: lightBase.appBarTheme.copyWith(
      iconTheme: lightBase.iconTheme,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 17,
        color: AppColors.textDark,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    scaffoldBackgroundColor: _LightColors.background,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
          // primary: AppColors.secondary,
          minimumSize: const Size.fromHeight(50),
          textStyle: GoogleFonts.nunito(
              textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold)))
      ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColors.secondary
    ),

    // cardColor: _LightColors.card,

    iconTheme: const IconThemeData(color: AppColors.iconDark),
  );

  /// Dark theme and its settings.
  ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.white,
    colorScheme: darkBase.colorScheme.copyWith(primary: Colors.white, secondary: Colors.white),
    visualDensity: visualDensity,
    // textTheme:
    // GoogleFonts.interTextTheme().apply(bodyColor: AppColors.textLight),
    textTheme: TextTheme(
      headline1: GoogleFonts.nunito(
        textStyle:  const TextStyle(
          color: Colors.black,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),),
      headline2: GoogleFonts.nunito(
        textStyle: const TextStyle(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 30
        ),
      ),
      headline3: GoogleFonts.nunito(
        textStyle: const TextStyle(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16
        ),
      ),),
    backgroundColor: _DarkColors.background,
    appBarTheme: darkBase.appBarTheme.copyWith(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.nunito(
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    scaffoldBackgroundColor: _DarkColors.background,
    // elevatedButtonTheme: ElevatedButtonThemeData(
    //     style: ElevatedButton.styleFrom(
    //         backgroundColor: Colors.white,
    //         minimumSize: const Size.fromHeight(50),
    //         textStyle: GoogleFonts.nunito(
    //             textStyle: const TextStyle(
    //             color: Colors.black,
    //             fontSize: 20,
    //             fontWeight: FontWeight.bold)))
    // ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            // primary: AppColors.secondary,
            minimumSize: const Size.fromHeight(50),
            textStyle: GoogleFonts.nunito(
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)))
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.white
    ),
    // cardColor: _DarkColors.card,


    iconTheme: const IconThemeData(color: AppColors.iconLight),
  );
}