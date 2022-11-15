import 'package:flutter/material.dart';

class ColorUtil {
  static bool isLightMode(ThemeData theme) {
    return theme.brightness == Brightness.light;
  }

  static bool isDarkMode(ThemeData theme) {
    return theme.brightness == Brightness.dark;
  }

  static Color blackOrWhiteForegroundColor(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}
