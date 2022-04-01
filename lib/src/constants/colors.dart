import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // this basically makes it so you can't instantiate this class

  static const Map<int, Color> orange = const <int, Color>{
    50: const Color(0xFFFCF2E7),
    100: const Color(0xFFF8DEC3),
    200: const Color(0xFFF3C89C),
    300: const Color(0xFFEEB274),
    400: const Color(0xFFEAA256),
    500: const Color(0xFFE69138),
    600: const Color(0xFFE38932),
    700: const Color(0xFFDF7E2B),
    800: const Color(0xFFDB7424),
    900: const Color(0xFFD56217)
  };

  static const Color backgroundColor = Color(0xFF26ABE2);
  static const Color airportPassengerColor = Color(0xFFF85656);
  static const Color travelingColor = Color(0xFF21B137);
  static const Color assignedButtonColor = Color(0xFF5AC96B);
  static const Color buttonColor = Color(0xFF26ABE2);
  static Color titleColor = Color(0xFF434343).withOpacity(.77);
  static const Color dateColor = Color(0xFFD95B00);
  static const Color nextButtonColor = Color(0xFF5AC96B);


}
