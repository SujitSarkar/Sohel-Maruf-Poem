import 'package:flutter/material.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';
import 'package:mukto_dhara/screens/change_theme.dart';
import 'package:mukto_dhara/screens/help_screen.dart';
import 'package:mukto_dhara/screens/pase_settings.dart';
import 'package:mukto_dhara/screens/refine_screen.dart';
import 'package:provider/provider.dart';

class AppBarMenu extends StatelessWidget {
  final Color iconColor;
  const AppBarMenu({Key? key, required this.iconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return PopupMenuButton(
        icon: Icon(
          Icons.more_vert,
          color: iconColor
        ),
        color: themeProvider.appBarMenuColor(),
        onSelected: (value) {
          if (value == 0) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HelpScreen()));
          }
          else if (value == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const RefineScreen()));
          }
          else if (value == 2) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChangeThemePage()));
          }else if(value==3||value==4||value==5){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context)=>PageSettings(pageValue: value)));
          }
        },
        itemBuilder: (context) => [
          _customAppBarMenuItem(themeProvider, 'সহায়িকা', 0),
          _customAppBarMenuItem(themeProvider, 'সমৃদ্ধ ও সংশোধনা', 1),
          _customAppBarMenuItem(themeProvider, 'থিম পরিবর্তন করুন', 2),
          _customAppBarMenuItem(themeProvider, 'গোপনীয়তা নীতি', 3),
          _customAppBarMenuItem(themeProvider, 'সাধারণ নিয়ম ও শর্তাবলী', 4),
          _customAppBarMenuItem(themeProvider, 'কপিরাইট',5),
        ]);
  }


  PopupMenuItem _customAppBarMenuItem(
      ThemeProvider themeProvider, String title, int value) {
    return PopupMenuItem(
      value: value,
      child: Text(
        title,
        style: TextStyle(
          color: themeProvider.appBarMenuItemColor(),
        ),
      ),
    );
  }
}
