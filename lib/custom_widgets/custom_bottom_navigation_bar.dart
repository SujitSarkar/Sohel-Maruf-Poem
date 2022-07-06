import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:mukto_dhara/model/selected_book_model.dart';
import 'package:mukto_dhara/provider/api_provider.dart';
import 'package:provider/provider.dart';


class CustomBottomNavigatorBar extends StatefulWidget {
  List<dynamic> bookList;

  CustomBottomNavigatorBar({required this.bookList});

  @override
  _CustomBottomNavigatorBarState createState() =>
      _CustomBottomNavigatorBarState();
}

class _CustomBottomNavigatorBarState extends State<CustomBottomNavigatorBar> {

  @override
  Widget build(BuildContext context) {
    final ApiProvider apiProvider = Provider.of<ApiProvider>(context);
    final Size size = MediaQuery.of(context).size;

    return InfiniteCarousel.builder(
      itemCount: widget.bookList.length,
      itemExtent: 120,
      center: true,
      anchor: 0.0,
      velocityFactor: 0.2,
      axisDirection: Axis.horizontal,
      loop: true,
      itemBuilder: (context, itemIndex, realIndex) {
        return GestureDetector(onTap: (){
          apiProvider.setSelectedBook(SelectedBook(bookImage: widget.bookList[itemIndex].catImage!, bookName: widget.bookList[itemIndex].categoryName!));
        },

          child: Padding(
            padding:  EdgeInsets.only(top: size.width*.03),
            child: Column(
              children: [
                SizedBox(
                    width: size.width * .06,
                    height: size.width * .08,
                    child: CachedNetworkImage(
                      imageUrl: widget.bookList[itemIndex].catImage!,
                      placeholder: (context, url) => Icon(Icons.image, color: Colors.grey.shade400),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                      fit: BoxFit.fill,
                    )),
                SizedBox(height: size.width*.01,),
                Text(
                  widget.bookList[itemIndex].categoryName!,
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
    );
  }
}
