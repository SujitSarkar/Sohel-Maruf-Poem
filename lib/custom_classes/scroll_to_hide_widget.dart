import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollToHide extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;
  final Duration duration;

  const ScrollToHide(
      {Key? key,
      required this.child,
      required this.scrollController,
      this.duration = const Duration(milliseconds: 300)})
      : super(key: key);

  @override
  _ScrollToHideState createState() => _ScrollToHideState();
}

class _ScrollToHideState extends State<ScrollToHide> {
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(listen);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(listen);
    super.dispose();
  }

  void listen(){
    final direction = widget.scrollController.position.userScrollDirection;
    if(direction == ScrollDirection.forward){
      hide();
    } else if(direction == ScrollDirection.reverse){
      show();
    }

  }

  void show(){
    if(!isVisible) setState(() => isVisible = true);
  }

  void hide(){
    if(isVisible) setState(() => isVisible = false);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;

    return AnimatedContainer(
      duration: widget.duration,
      height: isVisible? size.width * .2 : size.width * .1,
      child: Wrap(
        children: [
          widget.child,
        ],
      ),
    );
  }
}
