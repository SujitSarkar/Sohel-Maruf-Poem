import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mukto_dhara/custom_widgets/toggle_button.dart';
import 'package:mukto_dhara/provider/ad_controller.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';
import 'package:provider/provider.dart';

import '../provider/api_provider.dart';

class ChangeThemePage extends StatefulWidget{
  const ChangeThemePage({Key? key}) : super(key: key);

  @override
  _ChangeThemePageState createState() => _ChangeThemePageState();
}

class _ChangeThemePageState extends State<ChangeThemePage> with SingleTickerProviderStateMixin{
  late AnimationController _animationController;
  final List<String> values= ['Light', 'Dark'];
  final AdController adController = AdController();

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    super.initState();
    adController.loadInterstitialAd();
  }
  // function to toggle circle animation
  changeThemeMode(bool theme) {
    if (!theme) {
      _animationController.forward(from: 0.0);
    } else {
      _animationController.reverse(from: 1.0);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if(adController.interstitialAd!=null) adController.showInterstitialAd();
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    themeProvider.changeStatusBarTheme();

    return  Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: themeProvider.screenBackgroundColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.appBarColor(),
        elevation: 0.0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon:  Icon(
              LineAwesomeIcons.times,
              color: themeProvider.appBarTitleColor(),
            )),
        centerTitle: true,
        title: Text('থিম পরিবর্তন',
            style: TextStyle(
              color: themeProvider.appBarTitleColor(),
            )),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: height * 0.1),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: width * 0.35,
                  height: width * 0.35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        colors: themeProvider.themeMode().gradient,
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(40, 0),
                  child: ScaleTransition(
                    scale: _animationController.drive(
                      Tween<double>(begin: 0.0, end: 1.0).chain(
                        CurveTween(curve: Curves.decelerate),
                      ),
                    ),
                    alignment: Alignment.topRight,
                    child: Container(
                      width: width * .26,
                      height: width * .26,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: themeProvider.whiteBlackToggleColor()),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: height * 0.05),
            Text(
              'পছন্দের থিম নির্বাচন করুন',
              style: TextStyle(
                  fontSize: width * .06, fontWeight: FontWeight.bold,color: themeProvider.toggleTextColor()),
            ),
            SizedBox(height: height * 0.03),
            SizedBox(
              width: width * .6,
              child: Text(
                'দিন বা রাত, আপনার ইন্টারফেস কাস্টমাইজ করুন',
                textAlign: TextAlign.center,
                style: TextStyle(color: themeProvider.toggleTextColor()),
              ),
            ),
            SizedBox(height: height * 0.05),
            ZAnimatedToggle(
              values: const ['Light', 'Dark'],
              onToggleCallback: (v) async {
                await themeProvider.toggleThemeData();
                setState(() {});
                changeThemeMode(themeProvider.isLight);
              },
            ),
            SizedBox(
              height: height * .05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildDot(
                  width: width * 0.022,
                  height: width * 0.022,
                  color: const Color(0xFFd9d9d9),
                ),
                buildDot(
                  width: width * 0.055,
                  height: width * 0.022,
                  color: themeProvider.isLight
                      ? const Color(0xFF26242e)
                      : Colors.white,
                ),
                buildDot(
                  width: width * 0.022,
                  height: width * 0.022,
                  color: const Color(0xFFd9d9d9),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // for drawing the dots
  Container buildDot({required double width, required double height, required Color color}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: width,
      height: height,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: color,
      ),
    );
  }
}
