import 'package:flutter/material.dart';

extension AppColorShadesExtension on Color {
  Color get shade50 => _shade(50);
  Color get shade100 => _shade(100);
  Color get shade200 => _shade(200);
  Color get shade300 => _shade(300);
  Color get shade400 => _shade(400);
  Color get shade500 => _shade(500);
  Color get shade600 => _shade(600);
  Color get shade700 => _shade(700);
  Color get shade800 => _shade(800);
  Color get shade900 => _shade(900);

  Color _shade(int shade) {
    final amount = switch (shade) {
      50 => 0.86,
      100 => 0.72,
      200 => 0.56,
      300 => 0.40,
      400 => 0.24,
      500 => 0.0,
      600 => -0.10,
      700 => -0.22,
      800 => -0.34,
      900 => -0.48,
      _ => 0.0,
    };

    if (amount >= 0) {
      return Color.alphaBlend(Colors.white.withValues(alpha: amount), this);
    }

    return Color.alphaBlend(
      Colors.black.withValues(alpha: -amount * 0.65),
      this,
    );
  }
}

class AppColors {
  AppColors._();

  //═══════════════════════════════════════════════
  // BRAND COLORS
  //═══════════════════════════════════════════════

  static const Color primary = Color(0xFF044071);
  static const Color secondary = Color(0xFFFF460C);

  //═══════════════════════════════════════════════
  // PRIMARY SHADES
  //═══════════════════════════════════════════════

  static const Color primary50 = Color(0xFFEAF4FB);
  static const Color primary100 = Color(0xFFD5E8F5);
  static const Color primary200 = Color(0xFFA8D0EB);
  static const Color primary300 = Color(0xFF7BB8E1);
  static const Color primary400 = Color(0xFF4E9FD7);
  static const Color primary500 = primary;
  static const Color primary600 = Color(0xFF033862);
  static const Color primary700 = Color(0xFF022E52);
  static const Color primary800 = Color(0xFF022541);
  static const Color primary900 = Color(0xFF011A2E);

  //═══════════════════════════════════════════════
  // SECONDARY SHADES
  //═══════════════════════════════════════════════

  static const Color secondary50 = Color(0xFFFFF2EC);
  static const Color secondary100 = Color(0xFFFFE1D5);
  static const Color secondary200 = Color(0xFFFFC3AB);
  static const Color secondary300 = Color(0xFFFFA581);
  static const Color secondary400 = Color(0xFFFF8757);
  static const Color secondary500 = secondary;
  static const Color secondary600 = Color(0xFFE63E0B);
  static const Color secondary700 = Color(0xFFCC370A);
  static const Color secondary800 = Color(0xFFB33008);
  static const Color secondary900 = Color(0xFF992907);

  //═══════════════════════════════════════════════
  // BACKGROUND
  //═══════════════════════════════════════════════

  static const Color background = Color(0xFFF8FAFC);
  static const Color scaffold = Color(0xFFF5F7FA);
  static const Color surface = Colors.white;
  static const Color card = Colors.white;
  static const Color dialog = Colors.white;
  static const Color field = Color(0xFFF1F5F9);

  //═══════════════════════════════════════════════
  // TEXT
  //═══════════════════════════════════════════════

  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFCBD5E1);
  static const Color textWhite = Colors.white;

  //═══════════════════════════════════════════════
  // BORDER
  //═══════════════════════════════════════════════

  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color outline = Color(0xFFCBD5E1);

  //═══════════════════════════════════════════════
  // STATUS COLORS
  //═══════════════════════════════════════════════

  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);

  //═══════════════════════════════════════════════
  // EXTRA COLORS
  //═══════════════════════════════════════════════

  static const Color blue = Color(0xFF2563EB);
  static const Color cyan = Color(0xFF06B6D4);
  static const Color green = Color(0xFF22C55E);
  static const Color orange = Color(0xFFF97316);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color red = Color(0xFFEF4444);

  //═══════════════════════════════════════════════
  // GREY COLORS
  //═══════════════════════════════════════════════

  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  //═══════════════════════════════════════════════
  // DARK THEME
  //═══════════════════════════════════════════════

  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCard = Color(0xFF273549);

  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkBorder = Color(0xFF334155);

  //═══════════════════════════════════════════════
  // ICON COLORS
  //═══════════════════════════════════════════════

  static const Color iconPrimary = primary;
  static const Color iconSecondary = secondary;
  static const Color iconInactive = Color(0xFF94A3B8);

  //═══════════════════════════════════════════════
  // COMMON
  //═══════════════════════════════════════════════

  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;

  //═══════════════════════════════════════════════
  // COMPATIBILITY ALIASES
  //═══════════════════════════════════════════════

  static const Color pastelOrange = Color(0xFFFFE0C2);
  static const Color accentPurple = purple;
  static const Color accentBlue = blue;
  static const Color accentGreen = green;
  static const Color accentOrange = orange;
  static const Color cardLightColor = grey50;
  static const Color blueTint = Color(0xFFDBEAFE);
  static const Color successTint = Color(0xFFDCFCE7);
  static const Color warningTint = Color(0xFFFFF3CD);
  static const Color dangerTint = Color(0xFFFEE2E2);
  static const Color danger = error;
  static const Color dangerDark = Color(0xFFB91C1C);
  static const Color redAccent = error;
  static const Color amberDark = Color(0xFFB45309);
  static const Color amberDarker = Color(0xFF92400E);
  static const Color emeraldLight = Color(0xFFD1FAE5);
  static const Color screenBg = scaffold;
  static const Color surfaceElevated = Color(0xFFFFFFFF);
  static const Color textDark = textPrimary;
  static const Color textMuted = textSecondary;
  static const Color greyLight = grey300;
  static const Color lightBg = background;
  static const Color slate700 = Color(0xFF334155);
  static const Color primaryGradient = primary;
  static const Color cyanAccent = cyan;
  static const Color sky = Color(0xFF38BDF8);
  static const Color skyLight = Color(0xFF93C5FD);
  static const Color blueLight = Color(0xFF60A5FA);
  static const Color skyPale = Color(0xFFF8FAFC);
  static const Color fieldBg = background;
  static const Color white70 = Color(0xB3FFFFFF);
  static const Color redStrong = Color(0xFFDC2626);
  static const Color amber = Color(0xFFF59E0B);
  static const Color darkNavy = Color(0xFF0F172A);
  static const Color adminSoftBg = Color(0xFFF8FAFC);
  static const Color black12 = Color(0x1F000000);
  static const Color textSecondaryColor = textSecondary;
  static const Color brandBlue = blue;
  static const Color indigoBrand = Color(0xFF4F46E5);
  static const Color tealBrand = cyan;
  static const Color teal = cyan;
  static const MaterialColor indigo = MaterialColor(0xFF4F46E5, <int, Color>{
    50: Color(0xFFE0E7FF),
    100: Color(0xFFC7D2FE),
    200: Color(0xFFA5B4FC),
    300: Color(0xFF818CF8),
    400: Color(0xFF6366F1),
    500: Color(0xFF4F46E5),
    600: Color(0xFF4338CA),
    700: Color(0xFF3730A3),
    800: Color(0xFF312E81),
    900: Color(0xFF1E1B4B),
  });
  static const Color black54 = Color(0x8A000000);
  static const Color black26 = Color(0x42000000);
  static const Color black87 = Color(0xDD000000);
  static const Color white38 = Color(0x61FFFFFF);
  static const Color surfaceMuted = grey100;
  static const Color shadowSoft = Color(0x0F000000);

  static const MaterialColor grey = MaterialColor(0xFF6B7280, <int, Color>{
    50: Color(0xFFF9FAFB),
    100: Color(0xFFF3F4F6),
    200: Color(0xFFE5E7EB),
    300: Color(0xFFD1D5DB),
    400: Color(0xFF9CA3AF),
    500: Color(0xFF6B7280),
    600: Color(0xFF4B5563),
    700: Color(0xFF374151),
    800: Color(0xFF1F2937),
    900: Color(0xFF111827),
  });

  static const MaterialColor indigoSwatch =
      MaterialColor(0xFF4F46E5, <int, Color>{
        50: Color(0xFFE0E7FF),
        100: Color(0xFFC7D2FE),
        200: Color(0xFFA5B4FC),
        300: Color(0xFF818CF8),
        400: Color(0xFF6366F1),
        500: Color(0xFF4F46E5),
        600: Color(0xFF4338CA),
        700: Color(0xFF3730A3),
        800: Color(0xFF312E81),
        900: Color(0xFF1E1B4B),
      });

  static const Color darkPrimaryColor = primary;
  static const Color darkSecondaryColor = secondary;
  static const Color darkBackgroundColor = darkBackground;
  static const Color darkTextColor = darkTextPrimary;
  static const Color darkTextSecondaryColor = darkTextSecondary;
  static const Color darkBorderColor = darkBorder;
  static const Color darkErrorColor = error;
  static const Color darkCardColor = darkCard;

  //═══════════════════════════════════════════════
  // LEGACY SUPPORT
  //═══════════════════════════════════════════════

  static const Color primaryColor = primary;
  static const Color secondaryColor = secondary;

  static const Color backgroundColor = background;
  static const Color cardColor = card;
  static const Color textColor = textPrimary;
  static const Color borderColor = border;

  static const Color successColor = success;
  static const Color warningColor = warning;
  static const Color errorColor = error;
}
