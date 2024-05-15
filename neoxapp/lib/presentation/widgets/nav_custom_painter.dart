import 'dart:math';

import 'package:flutter/material.dart';
import 'package:neoxapp/core/theme_color.dart';

class NavCustomPainter extends CustomPainter {
  late double loc;
  late double s;
  Color color;
  TextDirection textDirection;

  NavCustomPainter(double startingLoc, int itemsLength, this.color, this.textDirection) {
    final span = 1.0 / itemsLength;
    s = 0.2;
    double l = startingLoc + (span - s) / 2;
    loc = textDirection == TextDirection.rtl ? 0.8 - l : l;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo((loc - 0.1) * size.width, 0)
      ..cubicTo(
        (loc + s * 0.20) * size.width,
        size.height * 0.05,
        loc * size.width,
        size.height * 0.50,
        (loc + s * 0.50) * size.width,
        size.height * 0.50,
      )
      ..cubicTo(
        (loc + s) * size.width,
        size.height * 0.50,
        (loc + s - s * 0.20) * size.width,
        size.height * 0.05,
        (loc + s + 0.1) * size.width,
        0,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.save();

    canvas.drawShadow(path, AppColors.primaryColor.withOpacity(0.9), 6, false);
    canvas.restore();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}

class ShadowedShapePainter extends CustomPainter {
  final Path? shape;
  final Color? shapeColor;
  final List<Shadow>? shadows;
  final Paint? _paint;

  ShadowedShapePainter({this.shape, this.shapeColor, this.shadows})
      : _paint = Paint()
          ..color = shapeColor!
          ..style = PaintingStyle.fill
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    shadows!.forEach((s) {
      canvas.save();
      canvas.translate(s.offset.dx, s.offset.dy);
      canvas.drawShadow(shape!, s.color, sqrt(s.blurRadius), false);
      canvas.restore();
    });
    canvas.drawPath(shape!, _paint!);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
