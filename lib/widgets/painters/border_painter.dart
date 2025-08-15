import 'package:flutter/material.dart';
import 'package:slider/widgets/slider_itself.dart';

class BorderPainter extends CustomPainter {
  Color topGradientColor;
  Color bottomGradientColor;

  BorderPainter({
    required this.topGradientColor,
    required this.bottomGradientColor
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(SliderItselfState.barBorderRadius + 10));

    final Gradient myGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [topGradientColor, bottomGradientColor],
    );

    final Paint gradientFillPaint = Paint()
      ..shader = myGradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    canvas.drawRRect(rRect, gradientFillPaint);
  }

  @override
  bool shouldRepaint(covariant BorderPainter oldDelegate) {
    return oldDelegate.topGradientColor != topGradientColor || oldDelegate.bottomGradientColor != bottomGradientColor;
  }
}