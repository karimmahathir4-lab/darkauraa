import 'package:flutter/material.dart';

import '../screens/widgets.dart';
import '../theme.dart';

extension AuraColorFade on Color {
  Color fade(double opacity) =>
      withAlpha((opacity.clamp(0.0, 1.0) * 255).round());
}

class GlassCard extends StatelessWidget {
  const GlassCard(
      {required this.child,
      this.padding = const EdgeInsets.all(16),
      super.key});
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) =>
      AuraCard(padding: padding, child: child);
}

class StatTile extends StatelessWidget {
  const StatTile(
      {required this.label,
      required this.value,
      required this.icon,
      super.key});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) => GlassCard(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          Icon(icon, color: AuraColors.red, size: 18),
          const SizedBox(height: 5),
          Text(value,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          Text(label,
              style: const TextStyle(color: Colors.white54, fontSize: 9)),
        ]),
      );
}

class SparklinePainter extends CustomPainter {
  const SparklinePainter(this.values, this.color,
      {required this.minY, required this.maxY});
  final List<double> values;
  final Color color;
  final double minY;
  final double maxY;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final range = (maxY - minY).abs() < 0.001 ? 1.0 : maxY - minY;
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height -
          ((values[i] - minY) / range).clamp(0.0, 1.0) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final previousX = size.width * (i - 1) / (values.length - 1);
        final previousValue = values[i - 1];
        final previousY = size.height -
            ((previousValue - minY) / range).clamp(0.0, 1.0) * size.height;
        final midX = (previousX + x) / 2;
        path.cubicTo(midX, previousY, midX, y, x, y);
      }
    }
    canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(covariant SparklinePainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.color != color;
}
