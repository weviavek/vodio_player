import 'package:flutter/material.dart';

class CustomColors {
  int swatchCode = 0xff2f4550;

  int backgroundCode = 0xfff4f4f9;
  MaterialColor get swatchColor {
    return MaterialColor(
      swatchCode,
      <int, Color>{
        50: Color(swatchCode),
        100: Color(swatchCode),
        200: Color(swatchCode),
        300: Color(swatchCode),
        400: Color(swatchCode),
        500: Color(swatchCode),
        600: Color(swatchCode),
        700: Color(swatchCode),
        800: Color(swatchCode),
        900: Color(swatchCode),
      },
    );
  }

  MaterialColor get backgroundColor {
    return MaterialColor(
      backgroundCode,
      <int, Color>{
        50: Color(backgroundCode),
        100: Color(backgroundCode),
        200: Color(backgroundCode),
        300: Color(backgroundCode),
        400: Color(backgroundCode),
        500: Color(backgroundCode),
        600: Color(backgroundCode),
        700: Color(backgroundCode),
        800: Color(backgroundCode),
        900: Color(backgroundCode),
      },
    );
  }
}
