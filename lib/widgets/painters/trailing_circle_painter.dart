import 'package:flutter/material.dart';

class TrailCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerPoint1 = Offset(size.width / 2, 160);
    final centerPoint2 = Offset(size.width / 2, 210);
    final centerPoint3 = Offset(size.width / 2, 245);

    final double circleRadius1 = 20;
    final double circleRadius2 = 10;
    final double circleRadius3 = 5;

    final Paint circlePaint = Paint()
      ..color = Colors.white.withAlpha(127)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    canvas.drawCircle(centerPoint1, circleRadius1, circlePaint);
    canvas.drawCircle(centerPoint2, circleRadius2, circlePaint);
    canvas.drawCircle(centerPoint3, circleRadius3, circlePaint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}