import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Color _topGradientColor = Colors.pink;
  Color _bottomGradientColor = Colors.cyan;

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
        child: RotatedBox(
          quarterTurns: 4, //to easily rotate it whenever
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
                                      _bottomGradientColor,
                                      _topGradientColor,
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
                                  painter: BorderPainter(
                                    topGradientColor: _topGradientColor,
                                    bottomGradientColor: _bottomGradientColor
                                  )
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
                                      internalValue += 0.3;
                                      _sliderValue = internalValue.clamp(sliderMin, sliderMax);
                                      if (fillHeight >= 300) {
                                        _opacityValue = 1.0;
                                      }
                                    } else if (details.delta.dy > 0 && _sliderValue >= 0) {
                                      internalValue -= 0.3;
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
      ),
    );
  }

  final String _topKey = 'top';
  final String _bottomKey = 'bottom';

  Future<void> colorPicker() async {
    Color pickingColorTop = _topGradientColor;
    Color pickingColorBottom = _bottomGradientColor; 
    final Map<String, Color>? pickingColors = await showDialog<Map<String, Color>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select 2 Colors For Your Gradient'),
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Top Gradient Color'),
                    ColorPicker(
                      pickerColor: pickingColorTop,
                      onColorChanged: (color) => setState(() => pickingColorTop = color),
                    ),
                    Divider(),
                    Text('Bottom Gradient Color'),
                    ColorPicker(
                      pickerColor: pickingColorBottom,
                      onColorChanged: (color) => setState(() => pickingColorBottom = color)
                    ),
                  ],
                );
              }
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop({_topKey: pickingColorTop, _bottomKey: pickingColorBottom});
              },
              child: Text('Set Colors')
            )
          ],
        );
      }
    );

    if (pickingColors != null) {
      setState(() {
        _topGradientColor = pickingColors[_topKey]!;
        _bottomGradientColor = pickingColors[_bottomKey]!;
      });
      _saveGradient();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadGradient();
  }

  Future<void> _loadGradient() async {
    final gradients = await SharedPreferences.getInstance();
    
    final loadedGradientTop = gradients.getInt(_topKey) ?? Colors.pink.toARGB32();
    final loadedGradientbottom = gradients.getInt(_bottomKey) ?? Colors.cyan.toARGB32();

    setState(() {
      _topGradientColor = Color(loadedGradientTop);
      _bottomGradientColor = Color(loadedGradientbottom);
    });
  }

  Future<void> _saveGradient() async {
    final gradients = await SharedPreferences.getInstance();

    await gradients.setInt(_topKey, _topGradientColor.toARGB32());
    await gradients.setInt(_bottomKey, _bottomGradientColor.toARGB32());
  }
}