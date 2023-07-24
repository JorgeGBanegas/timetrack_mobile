import 'package:flutter/material.dart';

class MyColors {

  static MaterialColor themePrimaryColor = MaterialColor(
    primary.value,
    <int, Color>{
50: const Color(0xFFF1FAF7),
      100: const Color(0xFFD0F0E4),
      200: const Color(0xFFA1E5C9),
      300: const Color(0xFF72DBAF),
      400: const Color(0xFF4CDB9B),
      500: Color(primary.value),
      600: const Color(0xFF22CB95),
      700: const Color(0xFF1DB386),
      800: const Color(0xFF19A276),
      900: const Color(0xFF128A5E),
    },
  );

  static const Color primary = Color(0xFF24DCA4);
  static const Color accent = Color(0xFF72F9D0);
  static const Color secondary = Color(0xFF1FC493);
  static const Color background = Color(0xFF040404);
  
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color red = Color(0xFFF52D56);
  static const Color orange = Color(0xFFF5A52D);
}