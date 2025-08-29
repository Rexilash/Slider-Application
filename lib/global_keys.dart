import 'package:flutter/material.dart';
import 'package:slider/widgets/app_background.dart';
import 'package:slider/widgets/blur_layer.dart';
import 'package:slider/widgets/menu_buttons.dart';
import 'package:slider/widgets/slider_itself.dart';

final GlobalKey<AppBackgroundState> appBackgroundStateKey = GlobalKey<AppBackgroundState>();
final GlobalKey<BlurScreenState> blurScreenStateKey = GlobalKey<BlurScreenState>();
final GlobalKey<SliderItselfState> sliderItselfStateKey = GlobalKey<SliderItselfState>();

final List<GlobalKey<MenuButtonState>> menuButtonStateKeys = [
  GlobalKey<MenuButtonState>(),
  GlobalKey<MenuButtonState>(),
  GlobalKey<MenuButtonState>(),
];