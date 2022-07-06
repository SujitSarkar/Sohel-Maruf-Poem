import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mukto_dhara/custom_widgets/appbar_menu.dart';
import 'package:mukto_dhara/model/selected_book_model.dart';
import 'package:mukto_dhara/provider/api_provider.dart';
import 'package:mukto_dhara/provider/sqlite_database_helper.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';
import 'package:mukto_dhara/screens/home_screen.dart';
import 'package:provider/provider.dart';

import '../provider/ad_controller.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({Key? key}) : super(key: key);

  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  int _count = 0;
  bool _loading = false;
  List<dynamic> _bookList = [];
  final AdController adController = AdController();

  Future _customInit(ApiProvider apiProvider, DatabaseHelper databaseHelper,
      ThemeProvider themeProvider) async {
    _count++;
    // await apiProvider.checkConnectivity();

    if (apiProvider.connected) {
      if (apiProvider.bookListModel == null) {
        setState(() => _loading = true);
        await apiProvider.getBookList(themeProvider);
        setState(() {
          _bookList = apiProvider.bookListModel.result;
          _loading = false;
        });
      } else {
        setState(() {
          _bookList = apiProvider.bookListModel.result;
        });
      }
    } else {
      setState(() => _loading = true);
      databaseHelper.offlineBookList.isEmpty
          ? await databaseHelper.getOfflineBookList()
          : null;
      setState(() => _loading = false);
      _bookList = databaseHelper.offlineBookList;
      setState(() {});
    }
    databaseHelper.getFavouritePoems();

    ///Store Book to Offline
    if (apiProvider.connected &&
        apiProvider.bookListModel != null &&
        apiProvider.bookListModel.result.isNotEmpty) {
      await databaseHelper
          .storeAllBookToOffline(apiProvider.bookListModel.result);
      //Image.memory(base64Decode(base64Image));
    }
  }

  @override
  void initState() {
    super.initState();
    final ApiProvider ap = Provider.of<ApiProvider>(context,listen: false);
    if(ap.connected) adController.loadBannerAdd();
  }

  @override
  void dispose() {
    super.dispose();
    adController.disposeAllAd();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final ApiProvider apiProvider = Provider.of<ApiProvider>(context);
    final DatabaseHelper databaseHelper = Provider.of<DatabaseHelper>(context);
    final Size size = MediaQuery.of(context).size;
    themeProvider.changeStatusBarTheme();
    if (_count == 0) _customInit(apiProvider, databaseHelper, themeProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: themeProvider.screenBackgroundColor(),
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: _customAppBar(size, themeProvider),
        ),
        body: _bodyUI(size, apiProvider, themeProvider),
      ),
    );
  }

  /// body
  Widget _bodyUI(
          Size size, ApiProvider apiProvider, ThemeProvider themeProvider) =>
      _loading
          ? SpinKitDualRing(
              color: themeProvider.spinKitColor(), lineWidth: 4, size: 40)
          : Column(
              children: [
                _bookList.isNotEmpty
                    ? Expanded(
                      child: GridView.builder(
                          padding: EdgeInsets.all(size.width * .05),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: size.width * .01,
                              crossAxisSpacing: size.width * .02,
                              childAspectRatio: 0.42),
                          itemCount: _bookList.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              apiProvider.setSelectedBook(SelectedBook(
                                  bookImage: _bookList[index].catImage!,
                                  bookName: _bookList[index].categoryName!));
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Home(
                                          categoryId:
                                              _bookList[index].categoryId!,
                                          poemBookList: _bookList)));
                            },
                            child: Column(
                              children: [
                                /// book image
                                apiProvider.connected
                                    ? CachedNetworkImage(
                                        imageUrl: _bookList[index].catImage!,
                                        placeholder: (context, url) => Padding(
                                          padding:
                                              EdgeInsets.all(size.width * .04),
                                          child: Icon(
                                            Icons.image,
                                            color: Colors.grey.shade400,
                                            size: size.width * .2,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                        fit: BoxFit.cover,
                                      )
                                    : Image.memory(
                                        base64Decode(_bookList[index].catImage!)),
                                SizedBox(height: size.width * .02),

                                /// book name
                                Text(
                                  _bookList[index].categoryName!,
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  style: TextStyle(
                                      color: themeProvider.bookNameColor(),
                                      fontSize: size.width * .04,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        ),
                    )
                    : Center(
                        child: Text(
                        'কোন বই নেই!',
                        style:
                            TextStyle(color: themeProvider.appBarTitleColor()),
                      )),
                if(adController.bannerAd!=null) Container(
                  alignment: Alignment.center,
                  child: AdWidget(ad: adController.bannerAd!),
                  width: MediaQuery.of(context).size.width,
                  height: adController.bannerAd!.size.height.toDouble(),
                )
              ],
            );

  /// custom app bar
  Container _customAppBar(Size size, ThemeProvider themeProvider) => Container(
        height: AppBar().preferredSize.height,
        color: themeProvider.appBarColor(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text('সোহেল মাহরুফ কবিতা সমগ্র',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: themeProvider.appBarTitleColor(),
                      fontSize: size.width * .05,
                      fontWeight: FontWeight.w500)),
            ),
            AppBarMenu(iconColor: themeProvider.appBarIconColor())
          ],
        ),
      );
}
