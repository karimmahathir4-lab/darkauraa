import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app_state.dart';
import '../theme.dart';
import '../localization.dart';
import 'widgets.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({required this.state, super.key});
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final scores = state.history
        .map((entry) => (entry['score'] as num).toDouble())
        .toList();
    final points =
        scores.length > 12 ? scores.sublist(scores.length - 12) : scores;
    final top = scores.isEmpty ? 0 : scores.reduce(math.max).round();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: <Widget>[
        RedGradientHeader(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(context.tr('YOUR PROGRESS'),
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1)),
                const SizedBox(height: 5),
                Text(context.tr('A look at the practice you have put in.'),
                    style: const TextStyle(
                        color: Color(0xFFE9C9CC), fontSize: 12)),
              ]),
        ),
        const SizedBox(height: 14),
        Row(children: <Widget>[
          Expanded(
              child: _StatTile(
                  label: context.tr('SESSIONS'),
                  value: '${state.history.length}',
                  icon: Icons.sports_esports_outlined)),
          const SizedBox(width: 9),
          Expanded(
              child: _StatTile(
                  label: context.tr('BEST SCORE'),
                  value: '$top',
                  icon: Icons.emoji_events_outlined)),
          const SizedBox(width: 9),
          Expanded(
              child: _StatTile(
                  label: context.tr('STREAK'),
                  value: '${state.streak}d',
                  icon: Icons.local_fire_department_outlined)),
        ]),
        const SizedBox(height: 13),
        AuraCard(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SectionTitle(context.tr('Score progress'),
                    icon: Icons.insights),
                const SizedBox(height: 4),
                Text(context.tr('Your 12 most recent drill results'),
                    style: const TextStyle(
                        color: AuraColors.secondary, fontSize: 11)),
                const SizedBox(height: 18),
                SizedBox(
                  height: 190,
                  width: double.infinity,
                  child: points.length < 2
                      ? Center(
                          child: Text(
                              points.isEmpty
                                  ? context.tr(
                                      'Complete a drill to start your progress curve.')
                                  : context.tr(
                                      'Complete another drill to see your curve.'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: AuraColors.secondary, fontSize: 12)))
                      : TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 1200),
                          curve: Curves.easeOutCubic,
                          builder: (context, progress, _) => CustomPaint(
                            painter: _ProgressCurvePainter(
                                points: points, progress: progress),
                            child: const SizedBox.expand(),
                          ),
                        ),
                ),
                const SizedBox(height: 12),
                Row(children: <Widget>[
                  const Icon(Icons.circle, color: AuraColors.red, size: 8),
                  const SizedBox(width: 6),
                  Text(context.tr('DRILL SCORE'),
                      style: const TextStyle(
                          color: AuraColors.secondary,
                          fontSize: 9,
                          letterSpacing: 1)),
                ]),
              ]),
        ),
        const SizedBox(height: 13),
        AuraCard(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SectionTitle(context.tr('Learning progress'),
                    icon: Icons.menu_book_outlined),
                const SizedBox(height: 14),
                Row(children: <Widget>[
                  Expanded(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                                begin: 0,
                                end: state.completedLessons.length / 8),
                            duration: const Duration(milliseconds: 900),
                            builder: (context, value, _) =>
                                LinearProgressIndicator(
                                    value: value,
                                    minHeight: 8,
                                    backgroundColor: const Color(0xFF303034),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            AuraColors.red)),
                          ))),
                  const SizedBox(width: 12),
                  Text('${state.lessonPercent}%',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ]),
                const SizedBox(height: 8),
                Text(
                    '${state.completedLessons.length} ${context.tr('of')} 8 ${context.tr('lessons completed')}',
                    style: const TextStyle(
                        color: AuraColors.secondary, fontSize: 11)),
              ]),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text(
              context.tr('Stats use practice history saved inside this app.'),
              textAlign: TextAlign.center,
              style:
                  const TextStyle(color: AuraColors.secondary, fontSize: 11)),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile(
      {required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) => AuraCard(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        child: Column(children: <Widget>[
          Icon(icon, color: AuraColors.red, size: 18),
          const SizedBox(height: 6),
          Text(value,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AuraColors.secondary, fontSize: 8, letterSpacing: .6)),
        ]),
      );
}

class _ProgressCurvePainter extends CustomPainter {
  const _ProgressCurvePainter({required this.points, required this.progress});
  final List<double> points;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 5.0;
    const right = 7.0;
    const top = 10.0;
    const bottom = 18.0;
    final chart =
        Rect.fromLTRB(left, top, size.width - right, size.height - bottom);
    final gridPaint = Paint()
      ..color = const Color(0x22FFFFFF)
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = chart.top + chart.height * i / 3;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
    }
    final minScore = points.reduce(math.min);
    final maxScore = points.reduce(math.max);
    final range = math.max(1.0, maxScore - minScore);
    final coords = <Offset>[];
    for (var i = 0; i < points.length; i++) {
      final x = chart.left + chart.width * i / (points.length - 1);
      final y = chart.bottom -
          ((points[i] - minScore) / range) * chart.height * .78 -
          chart.height * .1;
      coords.add(Offset(x, y));
    }
    final line = Path()..moveTo(coords.first.dx, coords.first.dy);
    for (var i = 1; i < coords.length; i++) {
      final previous = coords[i - 1];
      final current = coords[i];
      final midX = (previous.dx + current.dx) / 2;
      line.cubicTo(midX, previous.dy, midX, current.dy, current.dx, current.dy);
    }
    final metric = line.computeMetrics().first;
    final shown = metric.extractPath(0, metric.length * progress);
    final area = Path.from(shown)
      ..lineTo(coords.first.dx + (coords.last.dx - coords.first.dx) * progress,
          chart.bottom)
      ..lineTo(coords.first.dx, chart.bottom)
      ..close();
    canvas.drawPath(
        area,
        Paint()
          ..shader = const LinearGradient(
                  colors: <Color>[Color(0x55E11D2E), Color(0x00E11D2E)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)
              .createShader(chart));
    canvas.drawPath(
        shown,
        Paint()
          ..color = AuraColors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round);
    for (final point in coords) {
      canvas.drawCircle(point, 4, Paint()..color = AuraColors.red);
      canvas.drawCircle(point, 2, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressCurvePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.points != points;
}
