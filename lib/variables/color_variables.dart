import 'package:flutter/material.dart';

class CColor{

  static final Map<int, Color> lightThemeMapColor = {
    //RGB Color Code (0, 194, 162) Hex: 0xff0095B2
    50: const Color.fromRGBO(20,128,0, .1),
    100: const Color.fromRGBO(20,128,0, .2),
    200: const Color.fromRGBO(20,128,0, .3),
    300: const Color.fromRGBO(20,128,0, .4),
    400: const Color.fromRGBO(20,128,0, .5),
    500: const Color.fromRGBO(20,128,0,.6),
    600: const Color.fromRGBO(20,128,0,.7),
    700: const Color.fromRGBO(20,128,0, .8),
    800: const Color.fromRGBO(20,128,0, .9),
    900: const Color.fromRGBO(20,128,0, 1),
  };

  static final Map<int, Color> darkThemeMapColor = {
    //RGB Color Code (0, 194, 162) Hex: 0xff0095B2
    50: const Color.fromRGBO(31, 34, 31, .1),
    100: const Color.fromRGBO(31, 34, 31, .2),
    200: const Color.fromRGBO(31, 34, 31, .3),
    300: const Color.fromRGBO(31, 34, 31, .4),
    400: const Color.fromRGBO(31, 34, 31, .5),
    500: const Color.fromRGBO(31, 34, 31, .6),
    600: const Color.fromRGBO(31, 34, 31, .7),
    700: const Color.fromRGBO(31, 34, 31, .8),
    800: const Color.fromRGBO(31, 34, 31, .9),
    900: const Color.fromRGBO(31, 34, 31, 1),
  };

  static const Color lightThemeColor = Color(0xffFF5C00);
  static const Color darkThemeColor = Color(0xff151A18);
  static const Color greyThemColor = Color(0xff303533);
  static const Color greyThemeColor2 = Color(0xff3a3b3c);

}