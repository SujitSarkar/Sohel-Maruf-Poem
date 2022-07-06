import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mukto_dhara/custom_classes/scroll_to_hide_widget.dart';
import 'package:mukto_dhara/custom_widgets/appbar_menu.dart';
import 'package:mukto_dhara/custom_widgets/poem_card.dart';
import 'package:mukto_dhara/model/selected_book_model.dart';
import 'package:mukto_dhara/provider/api_provider.dart';
import 'package:mukto_dhara/provider/sqlite_database_helper.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';
import 'package:mukto_dhara/screens/favourite_screen.dart';
import 'package:provider/provider.dart';
import '../provider/ad_controller.dart';

class Home extends StatefulWidget {
  final String categoryId;
  final List<dynamic> poemBookList;
  const Home({Key? key, required this.categoryId,required this.poemBookList}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;
  bool _forwarded = false;
  late ScrollController _scrollController;
  int _count = 0;
  bool _loading = false;
  List<dynamic> _poemList = [];
  List<dynamic> _searchedPoemList = [];
  final AdController adController = AdController();

  Future _customInit(ApiProvider apiProvider, ThemeProvider themeProvider,DatabaseHelper databaseHelper) async {
    _count++;
    setState(() => _loading = true);
    //await apiProvider.checkConnectivity();

    if(apiProvider.connected){
      await apiProvider.getBookPoems(widget.categoryId, themeProvider).then((value) => setState(() {
        _poemList = apiProvider.book.result;
        _searchedPoemList = _poemList;
        _loading = false;
      }));
      await databaseHelper.storeAllPoemsToOffline(_poemList, widget.categoryId);
    }else{
      setState(() => _loading = true);
      await databaseHelper.getOfflinePoemList(widget.categoryId);
      setState((){
        _poemList = databaseHelper.allOfflinePoemList;
        _searchedPoemList = _poemList;
        _loading = false;
      });
    }
  }

  void _searchMember(String searchItem) {
    setState(() {
      if (searchItem == '') {
        _searchedPoemList = _poemList;
      }
      _searchedPoemList = _poemList
          .where((element) => (element.poemName
          .contains(searchItem)))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    ///Initialize Ad
    final ApiProvider ap = Provider.of<ApiProvider>(context,listen: false);
    if(ap.connected) adController.loadInterstitialAd();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
    if(adController.interstitialAd!=null) adController.showInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final ApiProvider apiProvider = Provider.of<ApiProvider>(context);
    final DatabaseHelper databaseHelper = Provider.of<DatabaseHelper>(context);
    final Size size = MediaQuery.of(context).size;
    themeProvider.changeStatusBarTheme();

    if(_count == 0) _customInit(apiProvider, themeProvider,databaseHelper);
    return SafeArea(
      child: Scaffold(
        backgroundColor: themeProvider.screenBackgroundColor(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.width * .6),
          child: _showSearchBar
              ? _customSearchBar(themeProvider, size)
              : _customAppBar(size, themeProvider),
        ),
        body: _bodyUI(size, themeProvider, apiProvider, databaseHelper),
        bottomNavigationBar: ScrollToHide(
            scrollController: _scrollController,
            child: _customBottomNavigation(size, apiProvider, themeProvider,databaseHelper)),
      ),
    );
  }

  /// body
  Widget _bodyUI(Size size, ThemeProvider themeProvider, ApiProvider apiProvider, DatabaseHelper databaseHelper) {
    return NotificationListener(
      onNotification: (scrollNotification) {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_forwarded == true) {
            setState(() => _forwarded = false);
          }
        } else if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_forwarded == false) {
            setState(() {
              _forwarded = true;
            });
          }
        }
        return true;
      },
      child: _loading
          ? SpinKitDualRing(color: themeProvider.spinKitColor(), lineWidth: 4, size: 40)
          : _searchedPoemList.isNotEmpty? ListView.builder(
          controller: _scrollController,
          itemCount: _searchedPoemList.length,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return PoemCard(
              poemId: _searchedPoemList[index].postId,
              poemName: _searchedPoemList[index].poemName,
              poemFirstLine: _searchedPoemList[index].firstLine ?? '',
              poem: _searchedPoemList[index].poem,
              poetName: _searchedPoemList[index].poetName,
              bookId: _searchedPoemList[index].bookId,
              iconData: databaseHelper.favouritePoemIdList.contains(_searchedPoemList[index].postId) ? Icons.bookmark : LineAwesomeIcons.bookmark,
            );
          }) :  Center(child: Text('কোন কবিতা নেই', style: TextStyle(color: themeProvider.appBarTitleColor()),)),
    );
  }

  /// custom app bar
  Widget _customAppBar(Size size, ThemeProvider themeProvider) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: _forwarded ? AppBar().preferredSize.height : 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _customAppBarItem(themeProvider, LineAwesomeIcons.search,
              _onAppBarIconPress(LineAwesomeIcons.search, size)),
          _customAppBarItem(themeProvider, LineAwesomeIcons.bookmark,
              _onAppBarIconPress(LineAwesomeIcons.bookmark, size)),
          // _appBarMenu(themeProvider),
          AppBarMenu(iconColor: _forwarded ? themeProvider.appBarIconColor() : Colors.transparent)
        ],
      ),
    );
  }

  /// custom appbar icons
  Widget _customAppBarItem(ThemeProvider themeProvider,  IconData iconData,
      Function() appBarIconPress) {
    return IconButton(
      icon: Icon(iconData),
      color: _forwarded ? themeProvider.appBarIconColor() : Colors.transparent,
      onPressed: appBarIconPress,
    );
  }

  /// custom bottom navigation
  Widget _customBottomNavigation(Size size, ApiProvider apiProvider, ThemeProvider themeProvider,DatabaseHelper databaseHelper) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          color: Colors.amberAccent,
          height: size.width * .2,
          child: InfiniteCarousel.builder(
            itemCount: widget.poemBookList.length,
            itemExtent: 120,
            center: true,
            anchor: 0.0,
            velocityFactor: 0.2,
            axisDirection: Axis.horizontal,
            loop: true,
            itemBuilder: (context, itemIndex, realIndex) {
              return GestureDetector(onTap: () async {
                apiProvider.setSelectedBook(SelectedBook(bookImage: widget.poemBookList[itemIndex].catImage!,
                    bookName: widget.poemBookList[itemIndex].categoryName!));
                setState(() => _loading = true);
                await apiProvider.checkConnectivity();
                if(apiProvider.connected){
                  await apiProvider.getBookPoems(
                      widget.poemBookList[itemIndex].categoryId!,
                      themeProvider).then((value) => setState(() {
                    _loading = false;
                    _poemList = apiProvider.book.result;
                    _searchedPoemList = _poemList;
                  }));
                }else{
                  await databaseHelper.getOfflinePoemList( widget.poemBookList[itemIndex].categoryId!).then((value){
                    setState(() {
                      _loading = false;
                      _poemList = databaseHelper.allOfflinePoemList;
                      _searchedPoemList = _poemList;
                    });
                  });
                }
              },
                child: Padding(
                  padding:  EdgeInsets.only(top: size.width*.03),
                  child: Column(
                    children: [
                      SizedBox(
                          width: size.width * .06,
                          height: size.width * .08,
                          child: apiProvider.connected? CachedNetworkImage(
                            imageUrl: widget.poemBookList[itemIndex].catImage!,
                            placeholder: (context, url) => Icon(Icons.image, color: Colors.grey.shade400),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                            fit: BoxFit.fill,
                          ):Image.memory(base64Decode(widget.poemBookList[itemIndex].catImage!),
                            fit: BoxFit.fill)),
                      SizedBox(height: size.width*.01),

                      Text(
                        widget.poemBookList[itemIndex].categoryName!,
                        style:  TextStyle(
                            color: Colors.black,
                            fontSize: size.width*.03
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          )
        ),
        Positioned(
          top: -size.width * .065,
          left: size.width * .04,
          child: Container(
            width: size.width * .21,
            height: size.width * .23,
            color: Colors.blue.shade700,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: size.width * .06,
                    height: size.width * .08,
                    child:apiProvider.connected? CachedNetworkImage(
                      imageUrl: apiProvider.selectedBook.bookImage,
                      placeholder: (context, url) => Icon(Icons.image, color: Colors.grey.shade400),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                      fit: BoxFit.fill,
                    ):Image.memory(base64Decode(apiProvider.selectedBook.bookImage),fit: BoxFit.fill)),
                SizedBox(
                  height: size.width * .01,
                ),
                Text(
                  apiProvider.selectedBook.bookName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontSize: size.width * .032),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  /// custom search bar
  Widget _customSearchBar(ThemeProvider themeProvider, Size size) {
    return AnimatedContainer(
      duration:  const Duration(milliseconds: 150),
      height: _forwarded ? AppBar().preferredSize.height : 0,
      child: TextFormField(
        controller: _searchController,
        onChanged: _searchMember,
        autofocus: true,
        style: TextStyle(
          color: themeProvider.appBarTitleColor()
        ),
        cursorColor: themeProvider.appBarTitleColor(),
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: 'খোঁজ করুন',
          hintStyle: TextStyle(
              color: themeProvider.searchBarHintColor(),
              fontSize: size.width * .04),
          prefixIcon: Icon(Icons.search,
              color: _forwarded
                  ? themeProvider.appBarIconColor()
                  : Colors.transparent),
          suffixIcon: InkWell(
              onTap: () => setState(() {
                _searchedPoemList = _poemList;
                _showSearchBar = !_showSearchBar;
              }),
              child: Icon(Icons.close,
                  color: _forwarded
                      ? themeProvider.appBarIconColor()
                      : Colors.transparent)),
        ),
      ),
    );
  }

  /// functions
  Function() _onAppBarIconPress(IconData iconData, Size size) => () {
        if (iconData == LineAwesomeIcons.bookmark) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const FavouriteScreen()));
        }
        if (iconData == LineAwesomeIcons.search) {
          setState(() => _showSearchBar = !_showSearchBar);
        }
      };
}
