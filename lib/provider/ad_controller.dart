import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

class AdController{
  ///Banner ad ID
  //Android: ca-app-pub-3005672286778851/8123487663
  ///Interstitial
  //Android: ca-app-pub-3005672286778851/5114180948
  ///Admob App ID:::::(AndroidManifest.xml & Info.plist)
  //Android: ca-app-pub-3005672286778851~1034414298


  InterstitialAd? interstitialAd;
  BannerAd? bannerAd;

  static final String bannerAddUnitId=Platform.isAndroid
      // ? 'ca-app-pub-3005672286778851/8123487663'
      // : 'ca-app-pub-3005672286778851/8123487663';
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/6300978111';

  static final String interstitialAddUnitId=Platform.isAndroid
      // ? 'ca-app-pub-3005672286778851/5114180948'
      // : 'ca-app-pub-3005672286778851/5114180948';
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/1033173712';

  void loadBannerAdd(){
    bannerAd = BannerAd(
        adUnitId: bannerAddUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: const BannerAdListener()
    );
    bannerAd!.load();
  }

  void loadInterstitialAd(){
    InterstitialAd.load(
        adUnitId: interstitialAddUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            //loadInterstitialAd();
            // print('InterstitialAd failed to load: $error');
          },
        ));
  }
  void showInterstitialAd(){
    interstitialAd!.show();
    loadInterstitialAd();
  }

  void disposeAllAd(){
    bannerAd!.dispose();
    interstitialAd!.dispose();
  }
}