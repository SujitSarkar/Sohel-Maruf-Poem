import 'package:flutter/material.dart';
import 'package:mukto_dhara/variables/color_variables.dart';

class SThemeData{
  static final ThemeData lightThemeData= ThemeData(
      backgroundColor:  Colors.white,
      primarySwatch: MaterialColor(0xffFF5C00, CColor.lightThemeMapColor),
      canvasColor: Colors.transparent,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.grey,
          selectedItemColor: CColor.lightThemeColor
      )
  );

  static final ThemeData darkThemeData= ThemeData(
      backgroundColor: CColor.darkThemeColor,
      primarySwatch: MaterialColor(0xff1F221F, CColor.darkThemeMapColor),
      canvasColor: Colors.transparent,
      indicatorColor: Colors.grey,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.white
      )
  );
}