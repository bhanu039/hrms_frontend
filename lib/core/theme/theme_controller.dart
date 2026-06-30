import 'package:flutter/material.dart';

/// Simple ThemeController using a ValueNotifier so the UI can toggle
/// between light and dark modes. This intentionally keeps persistence
/// out of scope for now.
class ThemeController {
  ThemeController._();

  static final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.system);

  static void toggle() {
    mode.value = mode.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  static void setMode(ThemeMode m) => mode.value = m;
}
