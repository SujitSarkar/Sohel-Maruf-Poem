import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mukto_dhara/custom_classes/toast.dart';
import 'package:mukto_dhara/custom_widgets/poem_card.dart';
import 'package:mukto_dhara/model/favourite_poem_model.dart';
import 'package:mukto_dhara/provider/ad_controller.dart';
import 'package:mukto_dhara/provider/sqlite_database_helper.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import '../provider/api_provider.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  int _count = 0;
  bool _loading = false;
  List<FavouritePoemModel> _favouritePoems = [];
  final AdController adController = AdController();

  Future _customInit(DatabaseHelper databaseHelper) async {
    _count++;
    setState(() => _loading = true);
    await databaseHelper.getFavouritePoems().then((value) => setState(() {
      _loading = false;
      _favouritePoems = databaseHelper.favouritePoemList;
    }));
  }

  @override
  void initState() {
    super.initState();
    ///Initialize Ad
    final ApiProvider ap = Provider.of<ApiProvider>(context,listen: false);
    if(ap.connected){
      adController.loadBannerAdd(); adController.loadInterstitialAd();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (adController.interstitialAd!=null) adController.showInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final DatabaseHelper databaseHelper = Provider.of<DatabaseHelper>(context);
    final Size size = MediaQuery.of(context).size;
    if(_count == 0) _customInit(databaseHelper);

    themeProvider.changeStatusBarTheme();
    return  Scaffold(
      backgroundColor: themeProvider.screenBackgroundColor(),
      body:  NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled){
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: themeProvider.appBarColor(),
              elevation: 0.0,
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon:  Icon(
                    LineAwesomeIcons.times,
                    color: themeProvider.appBarTitleColor(),
                  )),
              centerTitle: true,
              title: Text('পছন্দের তালিকা',
                  style: TextStyle(
                    color: themeProvider.appBarTitleColor(),
                  )),
            ),
          ];
        },
       body: _bodyUI(size, databaseHelper, themeProvider),
      ),
      bottomNavigationBar: adController.bannerAd!=null? Container(
        alignment: Alignment.center,
        child: AdWidget(ad: adController.bannerAd!),
        width: MediaQuery.of(context).size.width,
        height: adController.bannerAd!.size.height.toDouble(),
      ):const SizedBox(height: 5),
    );
  }

  Widget _bodyUI(Size size, DatabaseHelper databaseHelper, ThemeProvider themeProvider){
    return _loading? SpinKitDualRing(color: themeProvider.spinKitColor(), lineWidth: 4, size: 40,)
     : databaseHelper.favouritePoemList.isNotEmpty?
    ListView.builder(
      padding: EdgeInsets.zero,
        itemCount: _favouritePoems.length,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return Dismissible(
              direction: DismissDirection.endToStart,
              resizeDuration: const Duration(milliseconds: 200),
              key: ObjectKey(_favouritePoems.elementAt(index)),
            onDismissed: (direction) async {
              await databaseHelper.deleteFavouritePoem(_favouritePoems[index].postId, index);
              await databaseHelper.getFavouritePoems();
              showToast('পছন্দের তালিকা থেকে মুছে ফেলা হয়েছে', themeProvider);
            },
              child: PoemCard(
              poemId:  _favouritePoems[index].postId,
              poemName: _favouritePoems[index].poemName,
              poemFirstLine: _favouritePoems[index].firstLine,
              poem: _favouritePoems[index].poem,
              poetName: _favouritePoems[index].poetName,
              iconData: null,
                bookId: _favouritePoems[index].bookId,
            ),
          );
        }) : Center(child: Text('কোন কবিতা নেই', style: TextStyle(color: themeProvider.appBarTitleColor()),));
  }
}
