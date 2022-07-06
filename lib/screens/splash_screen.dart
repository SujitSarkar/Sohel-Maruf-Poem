import 'package:flutter/material.dart';
import 'package:mukto_dhara/provider/api_provider.dart';
import 'package:mukto_dhara/provider/sqlite_database_helper.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';
import 'package:mukto_dhara/screens/book_list_page.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    final ApiProvider apiProvider = Provider.of<ApiProvider>(context, listen: false);
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final DatabaseHelper databaseHelper = Provider.of<DatabaseHelper>(context, listen: false);

    _initialize(apiProvider, themeProvider, databaseHelper);
  }

  _initialize(ApiProvider apiProvider,ThemeProvider themeProvider,DatabaseHelper databaseHelper)async{
    await apiProvider.checkConnectivity();
    apiProvider.connected? apiProvider.getBookList(themeProvider):null;
    databaseHelper.getOfflineBookList();

    Future.delayed(const Duration(milliseconds: 2000)).then((value){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const BookListPage()), (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: size.width,
            height: size.height,
            child: Image.asset('assets/splash_screen_image.jpeg', fit: BoxFit.cover,)),
      ),
    );
  }
}
