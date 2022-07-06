import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mukto_dhara/variables/color_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;
  bool _isLight;
  Color? _statusBarColor;

  ThemeProvider(this._themeData, this._isLight);

  get themeData => _themeData;

  get isLight => _isLight;

  get statusBarColor => _statusBarColor;

  Future<void> toggleThemeData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _isLight = !_isLight;
    changeStatusBarTheme();
    if (_isLight) {
      _themeData = ThemeData(
          backgroundColor: Colors.white,
          primarySwatch: MaterialColor(0xffFF5C00, CColor.lightThemeMapColor),
          canvasColor: Colors.transparent,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              unselectedItemColor: Colors.grey,
              selectedItemColor: CColor.lightThemeColor));
      notifyListeners();
      pref.setBool('isLight', true);
    } else {
      _themeData = ThemeData(
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
              selectedItemColor: Colors.white));
      //_isLight=false;
      notifyListeners();
      pref.setBool('isLight', false);
    }
  }

  Color appBarColor() => _isLight ? Colors.grey.shade50 : CColor.darkThemeColor;
  Color screenBackgroundColor() => _isLight ? Colors.grey.shade50 : CColor.darkThemeColor;
  Color cardBackgroundColor() => _isLight ? Colors.grey.shade50 : Colors.grey.shade700;
  Color appBarMenuColor() => _isLight ? CColor.darkThemeColor : Colors.white;
  Color appBarMenuItemColor() => _isLight ? Colors.white : CColor.darkThemeColor;
  Color appBarTitleColor() => _isLight ? CColor.darkThemeColor : Colors.white;
  Color appBarIconColor() => _isLight ? CColor.darkThemeColor : Colors.white;
  Color bodyTextColor() => _isLight ? Colors.black : Colors.white;
  Color bodyIconColor() => _isLight ? Colors.black : Colors.white;
  Color? toggleTextColor() => _isLight ? Colors.grey[800] : Colors.grey[300];
  Color whiteBlackToggleColor() => _isLight ? Colors.white : CColor.darkThemeColor;
  Color searchBarHintColor() => _isLight ? CColor.darkThemeColor : Colors.white70;
  Color changeStatusBar() => _isLight ? Colors.white : CColor.darkThemeColor;
  Color poemCardColor() => _isLight? Colors.white : CColor.greyThemColor;
  Color poemNameColorOnCard() => _isLight? CColor.greyThemColor : Colors.white;
  Color bottomNavigationBackgroundColor() => _isLight? Colors.amberAccent : CColor.greyThemeColor2;
  Color bottomNavigationTitleColor() => _isLight? Colors.black : Colors.white;
  Color bottomNavSelectItemBgColor() => _isLight? Colors.green.shade700 : Colors.grey;
  Color poemNameColor() => _isLight? Colors.black : Colors.white;
  Color poetListDialogBgColor() => _isLight? Colors.white : CColor.greyThemeColor2;
  Color poetListDialogTitleColor() => _isLight? Colors.black : Colors.white;
  Color dialogDividerColor() => _isLight? Colors.grey.shade200 : Colors.grey.shade700;
  Color bookNameColor() => _isLight? Colors.black : Colors.white;
  Color spinKitColor() => _isLight? Colors.blue.shade700 : Colors.amberAccent;
  Color toastBgColor() => _isLight? Colors.black54 : Colors.white54;
  Color toastTextColor() => _isLight? Colors.white : Colors.black;

  changeStatusBarTheme() {
    if (_isLight) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark));
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: CColor.darkThemeColor,
          statusBarIconBrightness: Brightness.light));
    }
  }

  ThemeColor themeMode() {
    return ThemeColor(
      gradient: [
        if (isLight) ...[const Color(0xDDFF0080), const Color(0xDDFF8C00)],
        if (!isLight) ...[const Color(0xFF8983F7), const Color(0xFFA3DAFB)]
      ],
      textColor: isLight ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
      toggleButtonColor:
          isLight ? const Color(0xFFFFFFFF) : const Color(0xFf34323d),
      toggleBackgroundColor:
          isLight ? const Color(0xFFe7e7e8) : const Color(0xFF222029),
      shadow: [
        if (isLight)
          const BoxShadow(
              color: Color(0xFFd8d7da),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 5)),
        if (!isLight)
          const BoxShadow(
              color: Color(0x66000000),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 5))
      ],
    );
  }
}

class ThemeColor {
  List<Color> gradient;
  Color? backgroundColor;
  Color? toggleButtonColor;
  Color? toggleBackgroundColor;
  Color? textColor;
  List<BoxShadow>? shadow;

  ThemeColor({
    required this.gradient,
    this.backgroundColor,
    this.toggleBackgroundColor,
    this.toggleButtonColor,
    this.textColor,
    this.shadow,
  });
}
