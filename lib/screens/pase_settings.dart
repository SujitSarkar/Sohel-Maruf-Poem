import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mukto_dhara/provider/ad_controller.dart';
import 'package:mukto_dhara/provider/api_provider.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageSettings extends StatefulWidget {
  const PageSettings({Key? key, required this.pageValue}) : super(key: key);
  final dynamic pageValue;

  @override
  _PageSettingsState createState() => _PageSettingsState();
}

class _PageSettingsState extends State<PageSettings> {
  String pageTitle = '';
  bool _isLoading = true;
  SharedPreferences? preferences;
  String bodyData = '';
  final AdController adController = AdController();

  @override
  void initState() {
    super.initState();
    final ApiProvider apiProvider =
        Provider.of<ApiProvider>(context, listen: false);
    if (widget.pageValue == 3) {
      pageTitle = 'গোপনীয়তা নীতি';
    } else if (widget.pageValue == 4) {
      pageTitle = 'সাধারণ নিয়ম ও শর্তাবলী';
    } else {
      pageTitle = 'কপিরাইট';
    }
    _initializeData(apiProvider);

    ///Initialize Ad
    final ApiProvider ap = Provider.of<ApiProvider>(context,listen: false);
    if(ap.connected){
      adController.loadInterstitialAd();
      adController.loadBannerAdd();
    }
  }

  Future<void> _initializeData(ApiProvider apiProvider) async {
    preferences = await SharedPreferences.getInstance();
    //await apiProvider.checkConnectivity();

    if (apiProvider.connected) {
      var result = await apiProvider.getPageSettingResponse(widget.pageValue);
      if (result != null) {
        setState(() {
          bodyData = result;
          if (widget.pageValue == 3) {
            preferences!.setString('privacy', result);
          } else if (widget.pageValue == 4) {
            preferences!.setString('terms', result);
          } else {
            preferences!.setString('copyright', result);
          }
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        if (widget.pageValue == 3) {
          bodyData = preferences!.getString('privacy') ?? '';
        } else if (widget.pageValue == 4) {
          bodyData = preferences!.getString('terms') ?? '';
        } else {
          bodyData = preferences!.getString('copyright') ?? '';
        }
        _isLoading = false;
      });
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
    final ApiProvider apiProvider= Provider.of<ApiProvider>(context);
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
        title: Text(pageTitle,
            style: TextStyle(
              color: themeProvider.appBarTitleColor(),
            )),
      ),
      body: _isLoading
          ? SpinKitDualRing(
              color: themeProvider.spinKitColor(), lineWidth: 4, size: 40)
          : _bodyUI(size, themeProvider),
      bottomNavigationBar:adController.bannerAd!=null? Container(
        alignment: Alignment.center,
        child: AdWidget(ad: adController.bannerAd!),
        width: MediaQuery.of(context).size.width,
        height: adController.bannerAd!.size.height.toDouble(),
      ): const SizedBox(height: 5),
    );
  }

  Widget _bodyUI(Size size, ThemeProvider themeProvider) =>
      SingleChildScrollView(
        child: Html(
          data:
          bodyData,
          style: {
            'strong': Style(color: themeProvider.bodyTextColor()),
            'body': Style(color: themeProvider.bodyTextColor()),
            'span': Style(color: themeProvider.bodyTextColor()),
            'p': Style(color: themeProvider.bodyTextColor()),
            'li': Style(color: themeProvider.bodyTextColor()),
            'ul': Style(color: themeProvider.bodyTextColor()),
            'table': Style(color: themeProvider.bodyTextColor()),
            'tbody': Style(color: themeProvider.bodyTextColor()),
            'tr': Style(color: themeProvider.bodyTextColor()),
            'td': Style(color: themeProvider.bodyTextColor()),
            'th': Style(color: themeProvider.bodyTextColor()),
          },
        ),
      );
}
