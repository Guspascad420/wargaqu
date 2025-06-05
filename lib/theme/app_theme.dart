import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_text_theme.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primary400,
  scaffoldBackgroundColor: Colors.white,
  tabBarTheme: TabBarThemeData(
    dividerHeight: 0.0,
  ),
  appBarTheme: AppBarTheme(
      backgroundColor: Colors.white
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.grey.shade600, // Adjusted color for better visibility
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5), // Grey border
    ),
    // Border when the field is focused (being typed in)
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: AppColors.primary400, width: 2.0), // Blue border
    ),
    // Border when there is a validation error
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: Colors.redAccent, width: 1.5), // Red border for error
    ),
    // Border when there is a validation error and the field is focused
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: Colors.redAccent, width: 2.0), // Red border for focused error
    ),
    filled: true,
    errorStyle: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.normal), // Made font weight normal for a cleaner look
  ),
  colorScheme: ColorScheme.light(
    primary: AppColors.primary400,
    secondary: AppColors.secondary100,
  ),
  textTheme: AppTextTheme.lightTextTheme,
  useMaterial3: true
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  tabBarTheme: TabBarThemeData(
    indicatorColor: AppColors.primary200,
    labelColor: AppColors.primary200,
    dividerHeight: 0.0,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.grey.shade600, // Adjusted color for better visibility
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5), // Grey border
    ),
    // Border when the field is focused (being typed in)
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: AppColors.primary400, width: 2.0), // Blue border
    ),
    // Border when there is a validation error
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: Colors.redAccent, width: 1.5), // Red border for error
    ),
    // Border when there is a validation error and the field is focused
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: Colors.redAccent, width: 2.0), // Red border for focused error
    ),
    filled: true,
    fillColor: Colors.grey[100],
    errorStyle: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.normal), // Made font weight normal for a cleaner look
  ),
  colorScheme: ColorScheme.dark(
    primary: AppColors.primary400,
    secondary: AppColors.secondary100,
  ),
  textTheme: AppTextTheme.darkTextTheme,
  useMaterial3: true
);
