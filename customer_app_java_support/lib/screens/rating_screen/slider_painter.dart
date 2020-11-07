import 'package:flutter/material.dart';

class SliderPainter extends CustomPainter {
  double progress;

  SliderPainter({this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    double trackHeight = 1.0;
    double thumbRadius = 28;

    var trackPaint = Paint()
      ..color = Colors.black26
      ..strokeWidth = 1.0;

    var thumbPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    canvas.drawRect(
        Rect.fromLTWH(thumbRadius, (size.height - trackHeight) / 2,
            size.width - thumbRadius * 2, trackHeight),
        trackPaint);

    canvas.drawCircle(
        Offset(thumbRadius + (size.width - thumbRadius * 2) * progress,
            (size.height - trackHeight) / 2),
        5,
        Paint()..color = Colors.black);

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(
                (size.width - thumbRadius * 2) * progress,
                (size.height / 2) - thumbRadius,
                thumbRadius * 2,
                thumbRadius * 2),
            Radius.circular(16)),
        thumbPaint);
  }

  @override
  bool shouldRepaint(SliderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(SliderPainter oldDelegate) => true;
}
