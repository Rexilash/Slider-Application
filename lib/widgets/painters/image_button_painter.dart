import 'package:flutter/material.dart';

class ImageButton extends CustomPainter {
  Offset centerPosition;
  double buttonRadius;
  int circleOpacity;

  ImageButton({
    required this.centerPosition,
    required this.buttonRadius,
    required this.circleOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint buttonColor = Paint()
      ..color = Colors.white.withAlpha(circleOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    canvas.drawCircle(centerPosition, buttonRadius, buttonColor);
  }

  @override
  bool shouldRepaint(covariant ImageButton oldDelegate) {
    return oldDelegate.centerPosition != centerPosition ||
    oldDelegate.buttonRadius != buttonRadius || oldDelegate.circleOpacity != circleOpacity;
  }
}