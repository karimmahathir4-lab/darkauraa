import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models/crosshair_style.dart';

class CrosshairPainter extends CustomPainter {
  const CrosshairPainter({
    required this.style,
    required this.size,
    required this.thickness,
    required this.gap,
    required this.opacity,
    required this.color,
  });

  final CrosshairStyle style;
  final double size;
  final double thickness;
  final double gap;
  final double opacity;
  final Color color;

  factory CrosshairPainter.fromState(AppState state) => CrosshairPainter(
        style: state.crosshairStyle,
        size: state.crosshairSize,
        thickness: state.crosshairThickness,
        gap: state.crosshairGap,
        opacity: state.crosshairOpacity,
        color: state.crosshairColor,
      );

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final scale = size / 40;
    final radius = 16 * scale;
    final inner = gap * scale;
    final paint = Paint()
      ..color = color.withAlpha((opacity.clamp(0.0, 1.0) * 255).round())
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    if (style == CrosshairStyle.dot) {
      canvas.drawCircle(center, math.max(2, thickness * 1.2),
          paint..style = PaintingStyle.fill);
      return;
    }
    if (style == CrosshairStyle.circle) {
      canvas.drawCircle(center, radius - inner / 2, paint);
      return;
    }
    if (style == CrosshairStyle.tShape) {
      canvas.drawLine(Offset(center.dx - radius, center.dy - inner),
          Offset(center.dx + radius, center.dy - inner), paint);
      canvas.drawLine(Offset(center.dx, center.dy - inner),
          Offset(center.dx, center.dy + radius), paint);
      return;
    }
    final plus = style == CrosshairStyle.plus;
    final reach = plus ? radius * .62 : radius;
    final start = plus ? 0.0 : inner;
    canvas.drawLine(Offset(center.dx - reach, center.dy),
        Offset(center.dx - start, center.dy), paint);
    canvas.drawLine(Offset(center.dx + start, center.dy),
        Offset(center.dx + reach, center.dy), paint);
    canvas.drawLine(Offset(center.dx, center.dy - reach),
        Offset(center.dx, center.dy - start), paint);
    canvas.drawLine(Offset(center.dx, center.dy + start),
        Offset(center.dx, center.dy + reach), paint);
  }

  @override
  bool shouldRepaint(covariant CrosshairPainter oldDelegate) =>
      oldDelegate.style != style ||
      oldDelegate.size != size ||
      oldDelegate.thickness != thickness ||
      oldDelegate.gap != gap ||
      oldDelegate.opacity != opacity ||
      oldDelegate.color != color;
}
