import 'package:flutter/material.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class PoetListDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final Size size = MediaQuery.of(context).size;

    final List<String> _poetList = [
      'নজরুল ইসলাম',
      'রবি ঠাকুর',
      'জসীমউদ্দীন',
      'শামসুর রাহমান',
      'নজরুল ইসলাম',
      'রবি ঠাকুর',
      'জসীমউদ্দীন',
      'শামসুর রাহমান',
      'নজরুল ইসলাম',
      'রবি ঠাকুর',
      'জসীমউদ্দীন',
      'শামসুর রাহমান',
      'নজরুল ইসলাম',
      'রবি ঠাকুর',
      'জসীমউদ্দীন',
      'শামসুর রাহমান',
      'নজরুল ইসলাম',
      'রবি ঠাকুর',
      'জসীমউদ্দীন',
      'শামসুর রাহমান',
    ];

    return AlertDialog(
      backgroundColor: themeProvider.poetListDialogBgColor(),
      title: Text(
        'কবি তালিকা',
        style: TextStyle(
          color: themeProvider.poetListDialogTitleColor(),
          fontSize: size.width*.05
        ),
      ),
      content: ListView.builder(
        itemCount: _poetList.length,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _poetList[index],
                  style: TextStyle(
                    color: themeProvider.poemNameColor(),
                    fontSize: size.width*.04,
                  ),
                ),
                SizedBox(height: size.width*.04,),
                Divider(
                  color: themeProvider.dialogDividerColor(),
                  thickness: 1,
                ),
                SizedBox(height: size.width*.04,),
              ],
            );
          }),
    );
  }
}
