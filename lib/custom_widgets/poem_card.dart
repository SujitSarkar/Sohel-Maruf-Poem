import 'package:flutter/material.dart';
import 'package:mukto_dhara/custom_classes/toast.dart';
import 'package:mukto_dhara/model/favourite_poem_model.dart';
import 'package:mukto_dhara/provider/sqlite_database_helper.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';
import 'package:mukto_dhara/screens/read_poem_page.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

class PoemCard extends StatelessWidget {
  final String? poemId;
  final String poemName;
  final String poemFirstLine;
  final String poem;
  final String bookId;
  final String poetName;
  final IconData? iconData;

  const PoemCard(
      {Key? key,
        required this.poemId,
        required this.poemName,
      required this.poemFirstLine,
      required this.iconData,
        required this.poem,
        required this.poetName,
        required this.bookId
     }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final DatabaseHelper databaseHelper = Provider.of<DatabaseHelper>(context);
    final Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: (){
        Wakelock.enable();
        Navigator.push(context, MaterialPageRoute(builder: (context) => ReadPoem(poem: poem,poemName: poemName,poetName: poetName)));
      },
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: size.width*.03),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size.width*.02),
          ),
          elevation: 1,
          color: themeProvider.poemCardColor(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.width * .05, horizontal: size.width * .03),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _customPoemNameText(size, themeProvider),
                      poemFirstLine != ''? _customPoemFirstLineText(size, themeProvider) : const SizedBox(),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    FavouritePoemModel favouritePoem = FavouritePoemModel(poemId, poemName, poemFirstLine,poem,bookId,poetName);
                    await databaseHelper.insertFavouritePoem(favouritePoem);
                    showToast('কবিতাটি পছন্দের তালিকায় যুক্ত হয়েছে', themeProvider);
                  },
                  child: Padding(
                    padding:  EdgeInsets.only(left: size.width*.02, right: size.width*.02, bottom: size.width*.02),
                    child: Icon(iconData, color: themeProvider.bodyIconColor()),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// poem name text
  Widget _customPoemNameText(Size size, ThemeProvider themeProvider){
    return Text(
      poemName,
      style: TextStyle(
        color:  themeProvider.poemNameColorOnCard(),
        fontSize: size.width*.05,
        fontWeight: FontWeight.bold
      ),
    );
  }


  /// poem first line
  Widget _customPoemFirstLineText(Size size, ThemeProvider themeProvider){
    return Text(
      poemFirstLine,
      style: TextStyle(
          color:  themeProvider.poemNameColorOnCard(),
          fontSize: size.width*.04,
      ),
    );
  }
}
