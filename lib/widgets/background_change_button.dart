import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:slider/widgets/painters/image_button_painter.dart';
import 'package:slider/global_keys.dart';

class BackgroundChangeButton extends StatefulWidget {
  const BackgroundChangeButton({super.key});

  @override
  State<BackgroundChangeButton> createState() => _BackgroundChangeButtonState();
}

class _BackgroundChangeButtonState extends State<BackgroundChangeButton> with SingleTickerProviderStateMixin {
  final double containerHeight = 100;
  final double containerWidth = 130;
  final double buttonTrigger = 200;
  final double maxCircleRadius = 30.0;
  
  late AnimationController _controller;
  late Animation<double> _circleButtonRadius;
  late Animation<Offset> _circleButtonOffset;
  late Animation<double> _circleButtonOpacity;

  double _animatedCircleButtonRadius = 0.0;
  Offset _animatedCircleButtonOffset = Offset.zero;
  double _animatedCircleButtonOpacity = 0;

  bool _isCircleButtonActive = false;
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

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300
      )
    );

    _circleButtonRadius = Tween<double>(
      begin: 0.0,
      end: maxCircleRadius
    ).animate(_controller);

    _circleButtonOffset = Tween<Offset>(
      begin: Offset((containerWidth), containerHeight / 2),
      end: Offset((20.0 + maxCircleRadius), containerHeight / 2)
    ).animate(_controller);

    _circleButtonOpacity = Tween<double>(
      begin: 0.0,
      end: 255.0
    ).animate(_controller);


    _controller.addListener(() {
      setState(() {
        _animatedCircleButtonRadius = _circleButtonRadius.value;
        _animatedCircleButtonOffset = _circleButtonOffset.value;
        _animatedCircleButtonOpacity = _circleButtonOpacity.value;
      });
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isCircleButtonActive = true;
        });
        
      } else {
        setState(() {
          _isCircleButtonActive = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _resetTimer();
    _nullifyTimer();
    super.dispose();
  }

  void _triggerTimer() {
    _inactivityTimer = Timer(_inactivityDuration, _closeTheCircleButton);
  }

  void _resetTimer() {
    _inactivityTimer?.cancel();
  }

  void _closeTheCircleButton() {
    _controller.reverse();
  }

  void _nullifyTimer() {
    _inactivityTimer = null;
  }

  void _handleTapX() {
    if (_controller.status == AnimationStatus.dismissed) {
      _closeTheCircleButton();
      _controller.forward();
      debugPrint('Test tap 1');
      _triggerTimer();
    } else if (_controller.status == AnimationStatus.completed && _isCircleButtonActive) {
      _resetTimer();
      _triggerTimer();
      
    }
  }

  void _handleTapO() {
    if (_controller.status == AnimationStatus.dismissed) {
      _closeTheCircleButton();
      _controller.forward();
      debugPrint('Test tap 1');
      _triggerTimer();
    } else if (_controller.status == AnimationStatus.completed && _isCircleButtonActive) {
      _resetTimer();
      _triggerTimer();
      appBackgroundStateKey.currentState?.pickImageFile();
    }
  }

  void _handleTap3() {
    if (_controller.status == AnimationStatus.dismissed) {
      _closeTheCircleButton();
      _controller.forward();
      debugPrint('Test tap 1');
      _triggerTimer();
    } else if (_controller.status == AnimationStatus.completed && _isCircleButtonActive) {
      _resetTimer();
      _triggerTimer();
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: containerHeight + containerHeight + containerHeight,
      width: containerWidth,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: containerHeight,
                width: containerWidth,
                child: CustomPaint(
                  size: Size(containerWidth, containerHeight),
                  painter: ImageButton(
                    centerPosition: _animatedCircleButtonOffset,
                    buttonRadius: _animatedCircleButtonRadius,
                    circleOpacity: _animatedCircleButtonOpacity.toInt()
                  ),
                )
              ),
              GestureDetector(
                onTap: _handleTapX,
                child: Container(
                  height: containerHeight,
                  width: containerHeight, // to make this a square, intentional choice.
                  decoration: BoxDecoration(
                    border: _debugBorderValue
                  ),
                ),
              ),
            ]
          ),
          Stack(
            children: [
              Container(
                height: containerHeight,
                width: containerWidth,
                child: CustomPaint(
                  size: Size(containerWidth, containerHeight),
                  painter: ImageButton(
                    centerPosition: _animatedCircleButtonOffset,
                    buttonRadius: _animatedCircleButtonRadius,
                    circleOpacity: _animatedCircleButtonOpacity.toInt()
                  ),
                )
              ),
              GestureDetector(
                onTap: _handleTapO,
                child: Container(
                  height: containerHeight,
                  width: containerHeight, // to make this a square, intentional choice.
                  decoration: BoxDecoration(
                    border: _debugBorderValue
                  ),
                ),
              ),
            ]
          ),
          Stack(
            children: [
              Container(
                height: containerHeight,
                width: containerWidth,
                child: CustomPaint(
                  size: Size(containerWidth, containerHeight),
                  painter: ImageButton(
                    centerPosition: _animatedCircleButtonOffset,
                    buttonRadius: _animatedCircleButtonRadius,
                    circleOpacity: _animatedCircleButtonOpacity.toInt()
                  ),
                )
              ),
              GestureDetector(
                onTap: _handleTap3,
                child: Container(
                  height: containerHeight,
                  width: containerHeight, // to make this a square, intentional choice.
                  decoration: BoxDecoration(
                    border: _debugBorderValue
                  ),
                ),
              ),
            ]
          ),
        ],
      )
    );
  }
}