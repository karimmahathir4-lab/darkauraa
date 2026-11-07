import 'package:flutter/material.dart';

class TrainingReticle extends StatelessWidget {
  const TrainingReticle({
    required this.color,
    required this.style,
    required this.size,
    super.key,
  });

  final Color color;
  final String style;
  final double size;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size.square(size),
        painter: TrainingReticlePainter(color: color, style: style),
      );
}

class TrainingReticlePainter extends CustomPainter {
  const TrainingReticlePainter({required this.color, required this.style});
  final Color color;
  final String style;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final radius = size.shortestSide * .38;
    if (style == 'Dot') {
      canvas.drawCircle(center, 3.1, paint..style = PaintingStyle.fill);
      return;
    }
    if (style == 'Circle') {
      canvas.drawCircle(center, radius * .7, paint);
      canvas.drawCircle(center, 2, paint..style = PaintingStyle.fill);
      return;
    }
    if (style == 'T-Shape') {
      canvas.drawLine(Offset(center.dx - radius, center.dy - radius * .3),
          Offset(center.dx + radius, center.dy - radius * .3), paint);
      canvas.drawLine(Offset(center.dx, center.dy - radius * .3),
          Offset(center.dx, center.dy + radius), paint);
      return;
    }
    final gap = style == 'Classic' ? 2.0 : 4.0;
    canvas.drawLine(Offset(center.dx - radius, center.dy),
        Offset(center.dx - gap, center.dy), paint);
    canvas.drawLine(Offset(center.dx + gap, center.dy),
        Offset(center.dx + radius, center.dy), paint);
    canvas.drawLine(Offset(center.dx, center.dy - radius),
        Offset(center.dx, center.dy - gap), paint);
    canvas.drawLine(Offset(center.dx, center.dy + gap),
        Offset(center.dx, center.dy + radius), paint);
    canvas.drawCircle(center, style == 'Precision' ? 2.2 : 1.5,
        paint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant TrainingReticlePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.style != style;
}
