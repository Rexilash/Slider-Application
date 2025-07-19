import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;


void main() {
  runApp(SliderApp());
}

class SliderApp extends StatelessWidget {
  const SliderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slider App for Pasu :>',
      home: SliderItself(),
    );
  }
}

class SliderItself extends StatefulWidget {
  const SliderItself({super.key});

  @override
  State<SliderItself> createState() => _SliderItselfState();
}

class _SliderItselfState extends State<SliderItself> with SingleTickerProviderStateMixin {
  
  static const double customThumbRadius = 50.0;
  static const double barWidth = 135.0;
  static const double barHeight = 600.0;
  static const double barBorderRadius = 100.0;
  static const double sliderMin = 0.0;
  static const double sliderMax = 100.0;
  static const double minHeight = 150.0;

  double _opacityValue = 0.0;
  double _sliderValue = clampDouble(50.0, 0, 100);
  double _previousSliderValue = 0.0;

  Image backgroundImage = Image.asset('assets/test-background-img.jpg');

  @override
  Widget build(BuildContext context) {

    double progress = (_sliderValue - sliderMin) / (sliderMax - sliderMin);
    double mutableHeightRange = barHeight - minHeight;
    double scaledMutableHeight = progress * mutableHeightRange;
    double calculatedFillHeight = minHeight + scaledMutableHeight;
    double fillHeight = math.min(calculatedFillHeight, barHeight);
    bool isMovingUp = false;

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              /* decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/test-background-img.jpg'),
                  fit: BoxFit.fill
                )
              ), */
            ),
            SafeArea(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent
                  ),
                  height: barHeight + 100,
                  width: barWidth + 100,
                  child: Stack(
                    children: [
                      Center(
                        child: Opacity(
                          opacity: 0.5,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(barBorderRadius),
                              ),
                            elevation: 0,
                            child: Container(
                              height: barHeight + 20,
                              width: barWidth + 20,
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(0),
                                borderRadius: BorderRadius.circular(barBorderRadius),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 50,
                        bottom: 50,
                        child: Container(
                          height: fillHeight,
                          width: barWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(barBorderRadius),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.cyan,
                                Colors.pink
                              ]
                            ),
                          ),
                          child: AnimatedOpacity(
                            opacity: _opacityValue,
                            duration: const Duration(milliseconds: 100),
                            child: CustomPaint(
                              size: Size(100, 200),
                              painter: TrailCirclePainter(),
                            ),
                          ), 
                        )
                      ),
                      Center(
                        child: SizedBox(
                          height: barHeight + 20,
                          width: barWidth + 20,
                          child: CustomPaint(
                            size: Size(barWidth, barHeight),
                            painter: BorderPainter()
                          ),
                        ),
                      ),
                      Center(
                        child: Opacity(
                          opacity: 0.5,
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: barHeight - 50,
                              width: barWidth,
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: customThumbRadius,
                                      elevation: 0.0
                                    ),
                                    thumbColor: Colors.white,
                                    activeTrackColor: Colors.transparent,
                                    inactiveTrackColor: Colors.transparent
                                  ),
                                  child: Slider(
                                    value: _sliderValue,
                                    min: sliderMin,
                                    max: sliderMax,
                                    onChanged: (value) {
                                      setState(() {
                                        _sliderValue = value;
                                        /* isMovingUp = (_sliderValue > _previousSliderValue && fillHeight >= 300);

                                        if (isMovingUp) {
                                          _opacityValue = 1.0;
                                        } else {
                                          _opacityValue = 0.0;
                                        } */
                                        _previousSliderValue = _sliderValue;
                                      });
                                    },
                                    onChangeEnd: (value) { 
                                      setState(() {
                                        _opacityValue = 0.0;
                                      });
                                      _previousSliderValue = _sliderValue;
                                    }
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onVerticalDragUpdate: (details) {
                          setState(() {
                            if (details.delta.dy < 0 && _sliderValue < 100) {
                              _sliderValue++;
                              if (fillHeight >= 300) {
                                _opacityValue = 1.0;
                              }
                            } else if (details.delta.dy > 0 && _sliderValue > 0) {
                              _sliderValue--;
                              _opacityValue = 0.0;
                            }
                          });
                        },
                        onVerticalDragEnd: (details) => setState(() {
                          _opacityValue = 0.0;
                        }),
                        child: SizedBox(
                          height: barHeight,
                          width: barWidth,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}

class TrailCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerPoint1 = Offset(size.width / 2, 180);
    final centerPoint2 = Offset(size.width / 2, 250);

    final double circleRadius1 = 25;
    final double circleRadius2 = 15;

    final Paint circlePaint = Paint()
      ..color = Colors.white.withAlpha(255)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    canvas.drawCircle(centerPoint1, circleRadius1, circlePaint);
    canvas.drawCircle(centerPoint2, circleRadius2, circlePaint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(_SliderItselfState.barBorderRadius + 10));

    final Gradient myGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.pink, Colors.cyan],
    );


    final Paint gradientFillPaint = Paint()
      ..shader = myGradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    canvas.drawRRect(rRect, gradientFillPaint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}