import 'package:flutter/material.dart';

class BookTheme {
  BookTheme._();

  // Pozadí aplikace
  static const Color background = Color(0xFFD7C2A1);

  // Barva papíru celé knihy
  static const Color paperColor = Color(0xFFF8F2E8);

  // Pokud je budeme někdy potřebovat
  static const Color paperLeft = Color(0xFFF8F2E8);
  static const Color paperRight = Color(0xFFFDF9F2);

  // Hřbet knihy
  static const Color spineDark = Color(0xFFB88A54);
  static const Color spineLight = Color(0xFFD9B37A);

  // Text
  static const Color title = Color(0xFF4A2F20);
  static const Color body = Color(0xFF6A4D35);
  static const Color accent = Color(0xFF8C6A43);

  static const double pagePadding = 36;
  static const double borderRadius = 18;

  static const BoxShadow bookShadow = BoxShadow(
    color: Colors.black26,
    blurRadius: 25,
    offset: Offset(0, 12),
  );
}