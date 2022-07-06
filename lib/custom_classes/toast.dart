import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';

void showToast(String message, ThemeProvider themeProvider){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: themeProvider.toastBgColor(),
      textColor: themeProvider.toastTextColor(),
      fontSize: 16.0
  );
}