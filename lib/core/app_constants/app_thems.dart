import 'package:flutter/material.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class AppTheme {
  /// App main color
  static const Color primaryColor = AppColors.primaryColor;
  static const Color secondaryColor = AppColors.secondaryColor;
  static const Color backgroundColor = AppColors.backgroundColor;
  static const Color textColor = AppColors.textColor;
  static const Color textSecondaryColor = AppColors.textSecondaryColor;
  static const Color borderColor = AppColors.borderColor;
  static const Color pastelOrange = AppColors.pastelOrange;
  static Color primaryVariant = primaryColor.withValues(alpha: 0.8);
  static Color secondaryVariant = secondaryColor.withValues(alpha: 0.8);
  static Color lightBlue = Color(0xFF89C4F4);

  static Color lightFontColor = Colors.black;
  static Color darkFontColor = Colors.white;

  /// Light Theme Colors
  static const Color mainLightBackgroundColor = Colors.white;
  static Color mainLightBackgroundColor2 = Colors.grey.shade200;
  static const Color mainLightContainerBgColor = Color(0xFFF7FAFC);
  static const Color lightSecondary = Color(0xFFE0E0E0);
  static const Color lightTertiary = Color(0xFF0D1117);
  static Color lightProductCardColor = Colors.grey.shade100;
  static const Color lightSubCategoryCardColor = Color(0xFFE5FBFF);
  static Color lightOutline = Colors.grey.shade200;
  static Color lightOutlineVariant = Colors.grey.shade300;

  /// Dark Theme Colors
  // static const Color darkBackground = Color(0XFF080808);
  static const Color mainDarkBackgroundColor = Color(0xFF0D1117);
  static const Color mainDarkContainerBgColor = Color(0xFF151515);
  static const Color darkSubCategoryCardColor = Color(0xFF161B22);
  static const Color darkExtraCardColor = Color(0xFF30363D);
  static const Color darkTertiary = Color(0xFFCCCBCB);

  static Color darkProductCardColor = Color(0xFF161B22);
  static Color darkOutline = Colors.grey.shade700;
  static Color darkOutlineVariant = Colors.grey.withValues(alpha: 0.5);

  /// Typography
  static const String? fontFamily = null;

  /// Messages Color
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;
  static const Color warningColor = Colors.orangeAccent;

  /// Rating Star color
  static const Color ratingStarColor = Color(0xFFEEAB18);
  static const IconData ratingStarIcon = Icons.star_border_outlined;
  static const IconData ratingStarIconFilled = Icons.star;
  static const IconData ratingStarIconHalfFilled = Icons.star_half;

  /// Delivery Time Widget Color
  static const Color deliveryTimeWidgetColor = Color(0xFFC2FBFF);

  /// Discount Card Color
  static const Color discountCardColor = Color(0xFF256533);

  ///Coupon Card Colors
  static Color couponShadeColor = Colors.blue.shade50;
  static Color couponCollectBgColor = primaryColor.withValues(alpha: 0.1);

  static TextTheme _textTheme(Color textColor, Color textSecondaryColor) {
    return TextTheme(
      headlineSmall: TextStyle(
        color: primaryColor,
        fontSize: 26,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        color: primaryColor,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: textColor, fontSize: 16),
      bodyMedium: TextStyle(color: textColor, fontSize: 14),
      bodySmall: TextStyle(color: textSecondaryColor, fontSize: 12),
      labelLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
    );
  }

  static InputDecorationTheme _inputDecorationTheme({
    required Color fillColor,
    required Color borderColor,
    required Color focusedBorderColor,
    required Color hintColor,
  }) {
    final borderRadius = BorderRadius.circular(8);

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      hintStyle: TextStyle(color: hintColor),
      labelStyle: TextStyle(color: hintColor),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: focusedBorderColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: errorColor),
      ),
    );
  }

  /// Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.white,
      surface: backgroundColor,
      onSurface: textColor,
      surfaceContainer: mainLightContainerBgColor,
      tertiary: pastelOrange,
      outline: borderColor,
      outlineVariant: lightOutlineVariant,
      error: AppColors.errorColor,
      onSecondaryContainer: textSecondaryColor,
    ),
    fontFamily: AppTheme.fontFamily,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: textColor,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
    ),
    textTheme: _textTheme(textColor, textSecondaryColor),
    inputDecorationTheme: _inputDecorationTheme(
      fillColor: const Color(0xFFF2F4F7),
      borderColor: const Color(0xFFD0D5DD),
      focusedBorderColor: primaryColor,
      hintColor: textSecondaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(primaryColor),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: secondaryColor,
      linearTrackColor: AppColors.darkTextSecondaryColor,
    ),
  );

  /// Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.darkPrimaryColor,
      onPrimary: AppColors.darkTextColor,
      secondary: AppColors.darkSecondaryColor,
      onSecondary: AppColors.darkTextColor,
      surface: AppColors.darkBackgroundColor,
      onSurface: AppColors.darkTextColor,
      surfaceContainer: mainDarkContainerBgColor,
      tertiary: darkExtraCardColor,
      outline: AppColors.darkBorderColor,
      outlineVariant: darkOutlineVariant,
      error: AppColors.darkErrorColor,
      onSecondaryContainer: AppColors.darkTextSecondaryColor,
    ),
    fontFamily: AppTheme.fontFamily,
    scaffoldBackgroundColor: AppColors.darkBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackgroundColor,
      foregroundColor: AppColors.darkTextColor,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
    ),
    textTheme: _textTheme(
      AppColors.darkTextColor,
      AppColors.darkTextSecondaryColor,
    ),
    inputDecorationTheme: _inputDecorationTheme(
      fillColor: AppColors.darkCardColor,
      borderColor: AppColors.darkBorderColor,
      focusedBorderColor: AppColors.darkPrimaryColor,
      hintColor: AppColors.darkTextSecondaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColors.darkPrimaryColor),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: secondaryColor,
      linearTrackColor: AppColors.darkTextSecondaryColor,
    ),
  );
}
