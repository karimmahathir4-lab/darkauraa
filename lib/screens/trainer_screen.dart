import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../ads/ad_service.dart';
import '../app_state.dart';
import '../trainer_store.dart';
import '../widgets/common.dart';
import 'widgets.dart';
import '../widgets/crosshair_painter.dart';
import '../localization.dart';

enum _Phase { idle, playing, finished }

enum _AimMode { direct, drag }

class _Target {
  _Target({
    required this.pos,
    required this.vel,
    required this.radius,
    required this.spawnedAt,
    required this.expiresAt,
  });

  Offset pos;
  Offset vel;
  final double radius;
  final double spawnedAt;
  final double expiresAt;
}

class _Pop {
  const _Pop(this.pos, this.bornMs, this.hit);
  final Offset pos;
  final double bornMs;
  final bool hit;
}

class TrainerScreen extends StatefulWidget {
  const TrainerScreen({required this.state, super.key});
  final AppState state;

  @override
  State<TrainerScreen> createState() => _TrainerScreenState();
}

class _TrainerScreenState extends State<TrainerScreen>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;

  TrainerMode _mode = TrainerMode.classic;
  _AimMode _aimMode = _AimMode.direct;
  _Phase _phase = _Phase.idle;

  Size _arena = const Size(300, 380);
  Offset? _aim;
  Random _rng = Random();

  final List<_Target> _targets = [];
  final List<_Pop> _pops = [];
  final List<double> _reactions = [];

  int _score = 0;
  int _hits = 0;
  int _misses = 0;
  int _escaped = 0;
  int _streak = 0;
  int _maxStreak = 0;
  double _lastMs = 0;
  double _timeLeft = 0;
  int _lastSimulatedSecond = -1;
  int _simulatedFps = 56;
  int _simulatedRam = 62;
  int _simulatedPing = 38;

  TrainerResult? _result;
  bool _newBest = false;
  bool _adPauseHeld = false;

  ModeConfig get _cfg => modeConfig(_mode);

  // Drag speed comes from the General sensitivity slider (x0.4 to x2.0).
  double get _mult =>
      0.4 + (widget.state.sensitivity['General'] ?? 70.0) / 100 * 1.6;

  double get _xMin => _cfg.radius + 4;
  double get _xMax => max(_xMin + 1, _arena.width - _cfg.radius - 4);
  double get _yMin => 52 + _cfg.radius;
  double get _yMax => max(_yMin + 1, _arena.height - 76 - _cfg.radius);

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
  }

  @override
  void dispose() {
    _releaseInterstitialPause();
    _ticker.dispose();
    super.dispose();
  }

  int _dailySeed() {
    final d = DateTime.now();
    return d.year * 10000 + d.month * 100 + d.day;
  }

  // ---------------- Game loop ----------------

  void _start() {
    if (!_adPauseHeld) {
      _adPauseHeld = true;
      AuraAds.instance.pauseInterstitials();
    }
    final cfg = _cfg;
    _rng = _mode == TrainerMode.daily ? Random(_dailySeed()) : Random();
    _targets.clear();
    _pops.clear();
    _reactions.clear();
    _score = 0;
    _hits = 0;
    _misses = 0;
    _escaped = 0;
    _streak = 0;
    _maxStreak = 0;
    _lastMs = 0;
    _lastSimulatedSecond = -1;
    _timeLeft = cfg.seconds.toDouble();
    _result = null;
    _newBest = false;
    _aim = Offset(_arena.width / 2, _arena.height / 2);
    _phase = _Phase.playing;
    _ticker.stop();
    _ticker.start();
    setState(() {});
  }

  void _finish({required bool save}) {
    _releaseInterstitialPause();
    _ticker.stop();
    _targets.clear();

    if (save) {
      final avg = _reactions.isEmpty
          ? 0.0
          : _reactions.reduce((a, b) => a + b) / _reactions.length;
      final best = _reactions.isEmpty ? 0.0 : _reactions.reduce(min);
      final result = TrainerResult(
        mode: _mode,
        score: _score,
        hits: _hits,
        misses: _misses,
        avgMs: avg,
        bestMs: best,
        maxStreak: _maxStreak,
        profileId: widget.state.activeProfileId ?? 'none',
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );
      _newBest =
          result.score > 0 && result.score > trainerStore.bestScore(_mode);
      trainerStore.add(result);
      unawaited(widget.state.recordDrill('aim_${_mode.name}', _score));
      _result = result;
      _phase = _Phase.finished;
    } else {
      _phase = _Phase.idle;
    }
    setState(() {});
  }

  void _releaseInterstitialPause() {
    if (!_adPauseHeld) return;
    _adPauseHeld = false;
    AuraAds.instance.resumeInterstitials();
  }

  void _spawn(double now) {
    final cfg = _cfg;
    final pos = Offset(
      _xMin + _rng.nextDouble() * (_xMax - _xMin),
      _yMin + _rng.nextDouble() * (_yMax - _yMin),
    );
    var vel = Offset.zero;
    if (cfg.moving) {
      final angle = _rng.nextDouble() * 2 * pi;
      final speed = 70 + _rng.nextDouble() * 70;
      vel = Offset(cos(angle) * speed, sin(angle) * speed);
    }
    _targets.add(_Target(
      pos: pos,
      vel: vel,
      radius: cfg.radius,
      spawnedAt: now,
      expiresAt: now + cfg.lifetime * 1000,
    ));
  }

  void _onTick(Duration elapsed) {
    final cfg = _cfg;
    final now = elapsed.inMilliseconds.toDouble();
    final currentSecond = (now / 1000).floor();
    if (currentSecond != _lastSimulatedSecond) {
      _lastSimulatedSecond = currentSecond;
      _simulatedFps = (_simulatedFps + _rng.nextInt(3) - 1).clamp(48, 60);
      _simulatedRam = (_simulatedRam + _rng.nextInt(5) - 2).clamp(40, 80);
      _simulatedPing = (_simulatedPing + _rng.nextInt(11) - 5).clamp(18, 120);
    }
    final dt = ((now - _lastMs) / 1000).clamp(0.0, 0.1).toDouble();
    _lastMs = now;
    _timeLeft = cfg.seconds - now / 1000;

    if (_timeLeft <= 0) {
      _timeLeft = 0;
      _finish(save: true);
      return;
    }

    if (cfg.moving) {
      for (final t in _targets) {
        var p = t.pos + t.vel * dt;
        var v = t.vel;
        if (p.dx < _xMin || p.dx > _xMax) {
          v = Offset(-v.dx, v.dy);
          p = Offset(p.dx.clamp(_xMin, _xMax).toDouble(), p.dy);
        }
        if (p.dy < _yMin || p.dy > _yMax) {
          v = Offset(v.dx, -v.dy);
          p = Offset(p.dx, p.dy.clamp(_yMin, _yMax).toDouble());
        }
        t.pos = p;
        t.vel = v;
      }
    }

    _targets.removeWhere((t) {
      final gone = now >= t.expiresAt;
      if (gone) {
        _escaped++;
        _streak = 0;
      }
      return gone;
    });
    _pops.removeWhere((p) => now - p.bornMs > 350);

    while (_targets.length < cfg.simultaneous) {
      _spawn(now);
    }
    setState(() {});
  }

  void _fire(Offset p) {
    if (_phase != _Phase.playing) return;

    _Target? hit;
    for (final t in _targets.reversed) {
      if ((t.pos - p).distance <= t.radius + 8) {
        hit = t;
        break;
      }
    }

    if (hit != null) {
      final reaction = _lastMs - hit.spawnedAt;
      _targets.remove(hit);
      _hits++;
      _streak++;
      if (_streak > _maxStreak) _maxStreak = _streak;
      final combo = 1 + (_streak ~/ 5) * 0.5;
      final speedBonus = max(0, ((1200 - reaction) / 100).round());
      _score += ((10 + speedBonus) * combo).round();
      _reactions.add(reaction);
      _pops.add(_Pop(hit.pos, _lastMs, true));
      widget.state.playTrainingFeedback(hit: true);
    } else {
      _misses++;
      _streak = 0;
      _score = max(0, _score - 5);
      _pops.add(_Pop(p, _lastMs, false));
      widget.state.playTrainingFeedback(hit: false);
    }
    setState(() {});
  }

  // ---------------- Input ----------------

  void _onDown(PointerDownEvent e) {
    if (_phase != _Phase.playing) return;
    if (_aimMode == _AimMode.direct) {
      _aim = e.localPosition;
      _fire(e.localPosition);
    }
  }

  void _onMove(PointerMoveEvent e) {
    if (_phase != _Phase.playing) return;
    if (_aimMode == _AimMode.direct) {
      _aim = e.localPosition;
    } else {
      final a = (_aim ?? Offset(_arena.width / 2, _arena.height / 2)) +
          e.delta * _mult;
      _aim = Offset(
        a.dx.clamp(0.0, _arena.width).toDouble(),
        a.dy.clamp(0.0, _arena.height).toDouble(),
      );
    }
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    final playing = _phase == _Phase.playing;

    return ListenableBuilder(
      listenable: Listenable.merge([widget.state, trainerStore]),
      builder: (context, _) {
        final accent = Theme.of(context).colorScheme.primary;

        return ListView(
          physics: playing ? const NeverScrollableScrollPhysics() : null,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Text(context.tr('Aim Trainer'),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(
              '${context.tr(_cfg.blurb)} ${_cfg.seconds}s'
              '${_mode == TrainerMode.daily ? '  Seed ${_dailySeed()}' : ''}',
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 12),

            // Mode chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final m in TrainerMode.values)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(context.tr(modeConfig(m).label)),
                        selected: _mode == m,
                        onSelected: playing
                            ? null
                            : (_) {
                                widget.state.tap();
                                setState(() => _mode = m);
                              },
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Aim style
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<_AimMode>(
                segments: [
                  ButtonSegment(
                    value: _AimMode.direct,
                    label: Text(context.tr('Direct tap')),
                    icon: Icon(Icons.touch_app),
                  ),
                  ButtonSegment(
                    value: _AimMode.drag,
                    label: Text(context.tr('Drag + Fire')),
                    icon: Icon(Icons.open_with),
                  ),
                ],
                selected: {_aimMode},
                onSelectionChanged:
                    playing ? null : (s) => setState(() => _aimMode = s.first),
              ),
            ),
            if (_aimMode == _AimMode.drag)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  '${context.tr('Drag speed')} x${_mult.toStringAsFixed(2)} '
                  '(${context.tr('from your General sensitivity slider')})',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
            const SizedBox(height: 12),

            _arenaView(accent),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: playing
                  ? OutlinedButton.icon(
                      onPressed: () => _finish(save: false),
                      icon: const Icon(Icons.stop),
                      label: Text(context.tr('Stop')),
                    )
                  : FilledButton.icon(
                      onPressed: () {
                        widget.state.tap();
                        _start();
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: Text(context.tr(
                          _phase == _Phase.finished ? 'Play again' : 'Start')),
                    ),
            ),

            SectionTitle(context.tr('Lifetime')),
            Row(
              children: [
                Expanded(
                  child: StatTile(
                    label: context.tr('Sessions'),
                    value: '${trainerStore.sessions}',
                    icon: Icons.history,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatTile(
                    label: context.tr('Total hits'),
                    value: '${trainerStore.totalHits}',
                    icon: Icons.adjust,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatTile(
                    label: context.tr('Best streak'),
                    value: '${trainerStore.bestStreak}',
                    icon: Icons.local_fire_department,
                  ),
                ),
              ],
            ),

            SectionTitle(context.tr('Personal bests')),
            GlassCard(
              child: Column(
                children: [
                  for (final m in TrainerMode.values)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Text(context.tr(modeConfig(m).label),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          const Spacer(),
                          Text(
                            trainerStore.bestScore(m) == 0
                                ? '-'
                                : '${trainerStore.bestScore(m)}',
                            style: TextStyle(
                                color: accent, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            SectionTitle(context.tr('Recent scores')),
            GlassCard(child: _recentScores(accent)),

            SectionTitle(context.tr('Achievements')),
            _achievements(context, accent),
          ],
        );
      },
    );
  }

  Widget _recentScores(Color accent) {
    final h = trainerStore.history;
    if (h.length < 2) {
      return Text(
        context.tr('Play two sessions to see your trend.'),
        style: TextStyle(color: Colors.white54),
      );
    }
    final recent = h.length > 12 ? h.sublist(h.length - 12) : h;
    final values = recent.map((r) => r.score.toDouble()).toList();
    final top = values.reduce(max) + 10;
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: CustomPaint(
        painter: SparklinePainter(values, accent, minY: 0, maxY: top),
      ),
    );
  }

  Widget _achievements(BuildContext context, Color accent) {
    final w = (MediaQuery.of(context).size.width - 32 - 8) / 2;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final a in trainerStore.achievements)
          Opacity(
            opacity: a.unlocked ? 1 : 0.4,
            child: SizedBox(
              width: w,
              child: GlassCard(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(a.icon, color: a.unlocked ? accent : Colors.white54),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.tr(a.title),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 13)),
                          const SizedBox(height: 2),
                          Text(context.tr(a.description),
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _arenaView(Color accent) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: 380,
        child: LayoutBuilder(
          builder: (context, box) {
            _arena = Size(box.maxWidth, box.maxHeight);
            final aim = _aim ?? Offset(_arena.width / 2, _arena.height / 2);
            final playing = _phase == _Phase.playing;

            return Stack(
              children: [
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF140F26), Color(0xFF0B0B12)],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: _ArenaPainter(
                      targets: _targets,
                      pops: _pops,
                      aim: aim,
                      nowMs: _lastMs,
                      accent: accent,
                      crosshair: CrosshairPainter.fromState(widget.state),
                      showCrosshair: widget.state.trainingProfileActive &&
                          widget.state.toggle('crosshair'),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Listener(
                    behavior: HitTestBehavior.opaque,
                    onPointerDown: _onDown,
                    onPointerMove: _onMove,
                    child: const SizedBox.expand(),
                  ),
                ),
                if (playing)
                  Positioned(
                    top: 10,
                    left: 14,
                    right: 14,
                    child: IgnorePointer(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _Hud(context.tr('TIME'), '${_timeLeft.ceil()}s'),
                          _Hud(context.tr('SCORE'), '$_score'),
                          _Hud(context.tr('STREAK'), 'x$_streak'),
                        ],
                      ),
                    ),
                  ),
                if (playing && widget.state.trainingProfileActive)
                  Positioned(
                    top: 48,
                    left: 14,
                    right: 14,
                    child: IgnorePointer(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (widget.state.toggle('fps_live'))
                            _Hud(context.tr('FPS · SIM'), '$_simulatedFps'),
                          if (widget.state.toggle('ram_live')) ...[
                            const SizedBox(width: 12),
                            _Hud(context.tr('RAM · SIM'), '$_simulatedRam%'),
                          ],
                          if (widget.state.toggle('ping_live')) ...[
                            const SizedBox(width: 12),
                            _Hud(
                                context.tr('PING · SIM'), '$_simulatedPing ms'),
                          ],
                        ],
                      ),
                    ),
                  ),
                if (_phase == _Phase.idle)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Align(
                        alignment: Alignment(0, 0.6),
                        child: Text(
                          context.tr('Press Start'),
                          style: TextStyle(
                              color: Colors.white54,
                              letterSpacing: 1.4,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                if (playing && _aimMode == _AimMode.drag)
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: GestureDetector(
                      onTapDown: (_) => _fire(_aim ?? Offset.zero),
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accent.fade(0.25),
                          border: Border.all(color: accent, width: 2),
                        ),
                        alignment: Alignment.center,
                        child: Text(context.tr('FIRE'),
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2)),
                      ),
                    ),
                  ),
                if (_phase == _Phase.finished && _result != null)
                  Positioned.fill(child: _resultOverlay(accent, _result!)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _resultOverlay(Color accent, TrainerResult r) {
    return Container(
      color: Colors.black.fade(0.82),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            gradeFor(r),
            style: TextStyle(
                fontSize: 64, fontWeight: FontWeight.w900, color: accent),
          ),
          if (_newBest)
            Text(context.tr('NEW PERSONAL BEST'),
                style: TextStyle(
                    color: Color(0xFFFACC15),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    fontSize: 12)),
          const SizedBox(height: 6),
          Text('${r.score} ${context.tr('pts')}',
              style:
                  const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Cell(
                  context.tr('Accuracy'), '${r.accuracy.toStringAsFixed(0)}%'),
              _Cell(context.tr('Avg reaction'),
                  r.avgMs == 0 ? '-' : '${r.avgMs.round()} ms'),
              _Cell(context.tr('Best'),
                  r.bestMs == 0 ? '-' : '${r.bestMs.round()} ms'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Cell(context.tr('Hits'), '${r.hits}'),
              _Cell(context.tr('Misses'), '${r.misses}'),
              _Cell(context.tr('Escaped'), '$_escaped'),
              _Cell(context.tr('Streak'), '${r.maxStreak}'),
            ],
          ),
          if (_reactions.length >= 2) ...[
            const SizedBox(height: 14),
            SizedBox(
              height: 46,
              width: double.infinity,
              child: CustomPaint(
                painter: SparklinePainter(
                  List<double>.from(_reactions),
                  accent,
                  minY: 200,
                  maxY: 1500,
                ),
              ),
            ),
            Text(context.tr('Reaction time per hit'),
                style: TextStyle(color: Colors.white38, fontSize: 10)),
          ],
        ],
      ),
    );
  }
}

class _Hud extends StatelessWidget {
  const _Hud(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 10, letterSpacing: 1.2, color: Colors.white54)),
        Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(fontSize: 10, color: Colors.white54)),
      ],
    );
  }
}

class _ArenaPainter extends CustomPainter {
  _ArenaPainter({
    required this.targets,
    required this.pops,
    required this.aim,
    required this.nowMs,
    required this.accent,
    required this.crosshair,
    required this.showCrosshair,
  });

  final List<_Target> targets;
  final List<_Pop> pops;
  final Offset aim;
  final double nowMs;
  final Color accent;
  final CrosshairPainter crosshair;
  final bool showCrosshair;

  @override
  void paint(Canvas canvas, Size size) {
    // Faint grid
    final grid = Paint()
      ..color = Colors.white.fade(0.04)
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (var y = 0.0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    // Targets
    for (final t in targets) {
      final total = t.expiresAt - t.spawnedAt;
      final life = ((t.expiresAt - nowMs) / total).clamp(0.0, 1.0).toDouble();
      canvas.drawCircle(t.pos, t.radius, Paint()..color = accent);
      canvas.drawCircle(t.pos, t.radius * 0.66, Paint()..color = Colors.white);
      canvas.drawCircle(
          t.pos, t.radius * 0.33, Paint()..color = const Color(0xFFEF4444));
      canvas.drawArc(
        Rect.fromCircle(center: t.pos, radius: t.radius + 6),
        -pi / 2,
        2 * pi * life,
        false,
        Paint()
          ..color = Colors.white.fade(0.7)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
      );
    }

    // Hit / miss pops
    for (final p in pops) {
      final k = ((nowMs - p.bornMs) / 350).clamp(0.0, 1.0).toDouble();
      final color = p.hit ? const Color(0xFF4ADE80) : const Color(0xFFF87171);
      canvas.drawCircle(
        p.pos,
        8 + 26 * k,
        Paint()
          ..color = color.fade(1 - k)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }

    // The player's crosshair (uses the live crosshair settings)
    if (showCrosshair) {
      canvas.save();
      canvas.translate(aim.dx - 80, aim.dy - 80);
      crosshair.paint(canvas, const Size.square(160));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ArenaPainter old) => true;
}
