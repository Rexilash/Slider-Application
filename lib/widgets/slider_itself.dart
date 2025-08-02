import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:slider/widgets/painters/trailing_circle_painter.dart';
import 'package:slider/widgets/painters/border_painter.dart';

class SliderItself extends StatefulWidget {
  const SliderItself({super.key});

  @override
  State<SliderItself> createState() => SliderItselfState();
}

class SliderItselfState extends State<SliderItself> with SingleTickerProviderStateMixin {
  
  static const double customThumbRadius = 50.0;
  static const double barWidth = 135.0;
  static const double barHeight = 600.0;
  static const double barBorderRadius = 100.0;
  static const double sliderMin = 0.0;
  static const double sliderMax = 100.0;
  static const double minHeight = 150.0;

  double _opacityValue = 0.0;
  double _sliderValue = clampDouble(50.0, 0, 100);

  Image backgroundImage = Image.asset('assets/test-background-img.jpg');

  @override
  Widget build(BuildContext context) {
    double progress = (_sliderValue - sliderMin) / (sliderMax - sliderMin);
    double mutableHeightRange = barHeight - minHeight;
    double scaledMutableHeight = progress * mutableHeightRange;
    double calculatedFillHeight = minHeight + scaledMutableHeight;
    double fillHeight = math.min(calculatedFillHeight, barHeight);

    return Container(
      child: Center(
        child: Stack(
          children: [
            SafeArea(
              child: Stack(
                children: [
                  Center(
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
                                        onChanged: (value) {},
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onVerticalDragUpdate: (details) {
                                setState(() {
                                  double internalValue = _sliderValue;
                                  if (details.delta.dy < 0 && _sliderValue <= 100) {
                                    internalValue++;
                                    _sliderValue = internalValue.clamp(sliderMin, sliderMax);
                                    if (fillHeight >= 300) {
                                      _opacityValue = 1.0;
                                    }
                                  } else if (details.delta.dy > 0 && _sliderValue >= 0) {
                                    internalValue--;
                                    _sliderValue = internalValue.clamp(sliderMin, sliderMax);
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
              ),
            ),
          ]
        ),
      ),
    );
  }
}