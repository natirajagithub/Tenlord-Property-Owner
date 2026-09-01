import 'package:flutter/material.dart';

class HeaderWavePainter extends CustomPainter {
  final Color baseColor;

  HeaderWavePainter({this.baseColor = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    // Large Smooth Circular Arc Overlay (Matching Reference Image 1)
    final centerRight = Offset(size.width * 0.9, -size.height * 0.2);
    final centerLeft = Offset(-size.width * 0.3, size.height * 0.8);

    final paintOuter = Paint()
      ..color = baseColor.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    final paintInner = Paint()
      ..color = baseColor.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(centerRight, size.width * 0.85, paintOuter);
    canvas.drawCircle(centerLeft, size.width * 0.75, paintInner);
  }

  @override
  bool shouldRepaint(covariant HeaderWavePainter oldDelegate) => false;
}
