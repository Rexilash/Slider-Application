import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuButton extends StatefulWidget {
  String svgResource;
  Border? borderValue;

  MenuButton({
    super.key,
    required this.svgResource,
    required this.borderValue
  });

  @override
  State<MenuButton> createState() => MenuButtonState();
}

class MenuButtonState extends State<MenuButton> {
  double containerHeight = 100;
  double containerWidth = 120;

  double positionTop = 0;
  double positionLeft = 0;

  double opacity = 0;

  double imageHeight = 0;
  double imageWidth = 0;

  Duration animationDuration = Duration(milliseconds: 300);

  void initState() {
    super.initState();

    positionTop = containerHeight / 2;
    positionLeft = containerWidth;
    imageHeight = 0;
    imageWidth = 0;
    opacity = 0;
  }

  void buttonExtend() {
    setState(() {
      positionTop = 15;
      positionLeft = 15;

      imageHeight = 70;
      imageWidth = 70;

      opacity = 1;
    });
  }

  void buttonRetract() {
    setState(() {
      positionTop = containerHeight / 2;
      positionLeft = containerWidth;
      
      imageHeight = 0;
      imageWidth = 0;

      opacity = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: containerHeight,
      width: containerWidth,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: animationDuration,
            top: positionTop,
            left: positionLeft,
            height: imageHeight,
            width: imageWidth,
            child: AnimatedOpacity(
              opacity: opacity,
              duration: animationDuration,
              child: Container(
                child: SvgPicture.asset(
                  widget.svgResource,
                  fit: BoxFit.fill
                ),
              )
            ),
          ),
        ]
      ),
    );
  }
}