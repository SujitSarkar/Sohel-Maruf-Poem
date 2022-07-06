import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import '../provider/ad_controller.dart';
import '../provider/api_provider.dart';

class RefineScreen extends StatefulWidget {
  static const String text =
      'আবৃতি শিল্পী ও কবিতা প্রেমীদের জন্য ভালো লাগার মতো পরিচিত ও নতুন কবিতা গুলো এক সাথে হাতের নাগালে যেন পেয়ে যাবেন তার জন্যই এই প্রয়াস। '
      'কবিতা গুলোতে সংগ্রহের উপাত্ত ও কম্পোজে কোন কোন ভুল দৃষ্টি এড়িয়েছে, এক্ষেত্রে ক্ষমা প্রার্থনা সহ সহযোগিতা কামনা করছি। যদি কোন ভুল চোখে পরে এবং '
      'পছন্দের নতুন কবিতা মেইল, মুখপঞ্জি বা দূরভাস এর মাধ্যমে অবগত করা হলে যত তাড়াতাড়ি সম্ভব সংশোধন করার প্রতিশ্রুতি দিচ্ছি।';

  static const String email = 'abcd@gmail.com';
  static const String facebookLink = 'facebook.com/abcd';

  const RefineScreen({Key? key}) : super(key: key);

  @override
  State<RefineScreen> createState() => _RefineScreenState();
}

class _RefineScreenState extends State<RefineScreen> {

  final AdController adController = AdController();

  @override
  void initState() {
    super.initState();
    ///Initialize Ad
    final ApiProvider ap = Provider.of<ApiProvider>(context,listen: false);
    if(ap.connected){
      adController.loadInterstitialAd();
      adController.loadBannerAdd();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if(adController.interstitialAd!=null) adController.showInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final Size size = MediaQuery.of(context).size;

    themeProvider.changeStatusBarTheme();

    return Scaffold(
      backgroundColor: themeProvider.screenBackgroundColor(),
      appBar: AppBar(
        backgroundColor: themeProvider.appBarColor(),
        elevation: 0.0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              LineAwesomeIcons.times,
              color: themeProvider.appBarTitleColor(),
            )),
        centerTitle: true,
        title: Text('সমৃদ্ধ ও সংশোধন',
            style: TextStyle(
              color: themeProvider.appBarTitleColor(),
            )),

        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.share_outlined,
                color: themeProvider.appBarTitleColor(),
              )),
        ],
      ),
      body: _bodyUI(size, themeProvider),
      bottomNavigationBar: adController.bannerAd!=null? Container(
        alignment: Alignment.center,
        child: AdWidget(ad: adController.bannerAd!),
        width: MediaQuery.of(context).size.width,
        height: adController.bannerAd!.size.height.toDouble(),
      ):const SizedBox(height: 5),
    );
  }

  Widget _bodyUI(Size size, ThemeProvider themeProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.width * .04, horizontal: size.width * .04),
      child: ListView(
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(vertical: size.width*.03, horizontal: size.width*.04),
            child: Text(
              RefineScreen.text,
              style: TextStyle(
                  color: themeProvider.bodyTextColor(),
                  fontSize: size.width * .04),
            ),
          ),

          _customSelectedText(size, 'Email', RefineScreen.email, themeProvider),
          _customSelectedText(size, 'Facebook', RefineScreen.facebookLink, themeProvider),
        ],
      ),
    );
  }

  /// seletable text desing
 Widget _customSelectedText(Size size, String title, String text, ThemeProvider themeProvider) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: size.width*.03, horizontal: size.width*.04),
      child: Row(
        children: [
          Text(
            '$title:',
            style: TextStyle(
                color: themeProvider.bodyTextColor(),
                fontSize: size.width * .04),
          ),
          SizedBox(width: size.width*.02,),
          SelectableText(
            text,
            style: TextStyle(
                color: themeProvider.bodyTextColor(),
                fontSize: size.width * .04
            ),
          ),
        ],
      ),
    );
 }
}
