import 'package:flutter/material.dart';
import 'package:mukto_dhara/provider/api_provider.dart';
import 'package:mukto_dhara/provider/sqlite_database_helper.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';
import 'package:mukto_dhara/screens/splash_screen.dart';
import 'package:mukto_dhara/variables/theme_data.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref= await SharedPreferences.getInstance();
  final bool isLight = pref.getBool('isLight') ?? true;
  runApp(MyApp(isLight));

}

class MyApp extends StatefulWidget {
  final bool isLight;
  const MyApp(this.isLight, {Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(widget.isLight?SThemeData.lightThemeData:SThemeData.darkThemeData,widget.isLight)),
        ChangeNotifierProvider(create: (_) => ApiProvider()),
        ChangeNotifierProvider(create: (_) => DatabaseHelper())
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'সোহেল মাহরুফ কবিতা সমগ্র',
            theme: themeProvider.themeData,
            home: const SplashScreen(),
          );
        }
      ),
    );
  }
}

