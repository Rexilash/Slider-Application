import 'package:flutter/material.dart';
import 'package:slider/global_keys.dart';
import 'package:slider/widgets/app_background.dart';
import 'package:slider/widgets/slider_itself.dart';
import 'package:slider/widgets/menu.dart';
import 'package:slider/widgets/blur_layer.dart';

void main() {
  runApp(SliderApp());
}

class SliderApp extends StatelessWidget {
  const SliderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slider App for Pasu :>',
      home: Scaffold(
        body: AppDisplay()
      )
    );
  }
}

class AppDisplay extends StatelessWidget {
  const AppDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          AppBackground(key: appBackgroundStateKey),
          BlurScreen(key: blurScreenStateKey),
          SliderItself(key: sliderItselfStateKey),
          Align(
            alignment: Alignment.centerRight,
            child: Menu()
          )
        ],
      ),
    );
  }
}