import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:slider/global_keys.dart';
import 'package:slider/widgets/menu_buttons.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  final double containerHeight = 100;
  final double containerWidth = 120;
  final double buttonTrigger = 200;
  final double animationContainer = 80;

  bool _isButtonActive = false;
  Timer? _inactivityTimer;

  Border? _debugBorderValue;

  static const Duration _inactivityDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();

    if (kDebugMode) {
      _debugBorderValue = Border.all(width: 5, color: Colors.black);
    } else {
      _debugBorderValue = null;
    }
  }

  void showOrRemoveButtons() {
    if (_isButtonActive) {
      setState(() {
        menuButtonStateKeys[0].currentState?.buttonExtend();
        menuButtonStateKeys[1].currentState?.buttonExtend();
        menuButtonStateKeys[2].currentState?.buttonExtend();
      });
    } else {
      setState(() {
        menuButtonStateKeys[0].currentState?.buttonRetract();
        menuButtonStateKeys[1].currentState?.buttonRetract();
        menuButtonStateKeys[2].currentState?.buttonRetract();
      });
    }
  }

  void _triggerTimer() {
    _inactivityTimer = Timer(
      _inactivityDuration, 
      () {
        _isButtonActive = false;
        showOrRemoveButtons();
      }
    );
  }

  void _resetTimer() {
    _inactivityTimer?.cancel();
  }

  void _nullifyTimer() {
    _inactivityTimer = null;
  }

  @override
  void dispose() {
    _resetTimer();
    _nullifyTimer();
    super.dispose();
  }

  
  Widget blur() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => blurScreenStateKey.currentState?.blurDialog(),
      child: Container(
        height: containerHeight,
        width: containerHeight,
      ),
    );
  }

  Widget background() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => appBackgroundStateKey.currentState?.pickImageFile(),
      child: Container(
        height: containerHeight,
        width: containerHeight,
        decoration: BoxDecoration(
          border: _debugBorderValue,
          color: Colors.transparent
        ),
      ),
    );
  }

  Widget gradient() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => sliderItselfStateKey.currentState?.colorPicker(),
      child: Container(
        height: containerHeight,
        width: containerHeight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: containerHeight * 3,
      width: containerWidth,
      child: Stack(
        children: [
          Column(
            children: [
              MenuButton(
                key: menuButtonStateKeys[0],
                svgResource: './assets/X-icon.svg',
                borderValue: _debugBorderValue
              ),
              MenuButton(
                key: menuButtonStateKeys[1],
                svgResource: './assets/circle-icon.svg',
                borderValue: _debugBorderValue
              ),
              MenuButton(
                key: menuButtonStateKeys[2],
                svgResource: './assets/triangle-icon.svg',
                borderValue: _debugBorderValue
              )
            ],
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap:() {
              setState(() {
                _isButtonActive = true;
                _triggerTimer();
                showOrRemoveButtons();
              });
            },
            child: Container(
              height: containerHeight * 3,
              width: containerHeight,
              decoration: BoxDecoration(
                border: _debugBorderValue
              ),
            )
          ),
          if (_isButtonActive) Column(
            children: [
              blur(),
              background(),
              gradient()
            ],
          )
        ]
      )
    );
  }
}