import 'package:flutter/material.dart';

/*
  Box used in histograms.
 */
class MyBoxPainter extends CustomPainter {
  final Color _color;

  MyBoxPainter(this._color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the color property of the paint
    paint.color = _color;

    // Top circle
    var topCenter = Offset(size.width / 2, size.width / 2);
    canvas.drawCircle(topCenter, size.width / 2, paint);

    // Bottom rectangle
    var rect = Rect.fromLTWH(0, size.width / 2, size.width, size.height - size.width/2);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

/*
  Bars used in histograms.
 */
class MyBarPainter extends CustomPainter {
  final Color _color;

  MyBarPainter(this._color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the color property of the paint
    paint.color = _color;

    // Top circle
    var topCenter = Offset(size.width / 2, size.width / 2);
    canvas.drawCircle(topCenter, size.width / 2, paint);

    // Bottom circle
    var bottomCenter = Offset(size.width / 2, size.height - size.width / 2);
    canvas.drawCircle(bottomCenter, size.width / 2, paint);

    // Middle rectangle
    var rect = Rect.fromLTWH(0, size.width / 2, size.width, size.height - size.width);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}