import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../ads/ad_service.dart';
import '../app_state.dart';
import '../data/toggles.dart';
import '../theme.dart';
import '../localization.dart';
import '../widgets/training_reticle.dart';

class DrillDefinition {
  const DrillDefinition({
    required this.id,
    required this.name,
    required this.trains,
    required this.description,
    required this.icon,
    this.reaction = false,
    this.tracking = false,
    this.numbered = false,
  });
  final String id;
  final String name;
  final String trains;
  final String description;
  final IconData icon;
  final bool reaction;
  final bool tracking;
  final bool numbered;
}

class DrillSessionScreen extends StatefulWidget {
  const DrillSessionScreen({
    required this.drill,
    required this.difficulty,
    required this.durationSeconds,
    required this.state,
    super.key,
  });
  final DrillDefinition drill;
  final String difficulty;
  final int durationSeconds;
  final AppState state;

  @override
  State<DrillSessionScreen> createState() => _DrillSessionScreenState();
}

class _DrillSessionScreenState extends State<DrillSessionScreen> {
  final Random _random = Random();
  Timer? _clock;
  Timer? _motion;
  Timer? _reactionWait;
  Timer? _markerTimer;
  Timer? _simulatedStatsTimer;
  int _simulatedFps = 56;
  int _simulatedRam = 61;
  int _simulatedPing = 42;
  int _countdown = 3;
  int _remaining = 30;
  int _score = 0;
  int _hits = 0;
  int _misses = 0;
  int _round = 0;
  bool _started = false;
  bool _finished = false;
  bool _targetVisible = true;
  bool _reactionReady = false;
  bool _isNewBest = false;
  Offset _target = const Offset(.5, .5);
  Offset _velocity = const Offset(.002, .003);
  Offset? _crosshair;
  Offset? _previousCrosshair;
  final List<Offset> _switchTargets = <Offset>[];
  int _trackingSamples = 0;
  int _trackingHits = 0;
  int _smoothSamples = 0;
  int _smoothHits = 0;
  final List<int> _reactionTimes = <int>[];
  final List<int> _targetTimes = <int>[];
  DateTime? _shownAt;
  DateTime _targetShownAt = DateTime.now();
  bool _showHitMarker = false;
  Offset _hitMarkerPosition = const Offset(.5, .5);

  bool get _customCrosshairVisible =>
      widget.state.trainingProfileActive && widget.state.toggle('crosshair');
  Color get _crosshairColor => Color(trainingOverlayColors[
          widget.state.profileValue('crosshair_color') as String? ?? 'Lime'] ??
      0xFFB5F542);
  String get _crosshairStyle =>
      widget.state.profileValue('crosshair_style') as String? ?? 'Precision';

  void _handleProfileUpdate() {
    if (mounted) setState(() {});
  }

  int get _radius {
    final scale =
        (MediaQuery.sizeOf(context).shortestSide / 390).clamp(.72, 1.25);
    switch (widget.difficulty) {
      case 'Easy':
        return (34 * scale).round();
      case 'Hard':
        return (17 * scale).round();
      default:
        return (25 * scale).round();
    }
  }

  @override
  void initState() {
    super.initState();
    AuraAds.instance.pauseInterstitials();
    widget.state.addListener(_handleProfileUpdate);
    _remaining = widget.durationSeconds;
    _simulatedStatsTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _simulatedFps = (_simulatedFps + _random.nextInt(3) - 1).clamp(48, 60);
        _simulatedRam = (_simulatedRam + _random.nextInt(5) - 2).clamp(40, 80);
        _simulatedPing =
            (_simulatedPing + _random.nextInt(11) - 5).clamp(18, 120);
      });
    });
    _clock = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (!_started) {
        if (_countdown == 1) {
          setState(() {
            _countdown = 0;
            _started = true;
          });
          _startDrill();
        } else {
          setState(() => _countdown--);
        }
      } else if (_remaining <= 1) {
        _remaining = 0;
        _finishDrill();
      } else {
        setState(() => _remaining--);
      }
    });
  }

  void _startDrill() {
    if (widget.drill.reaction) {
      _scheduleReaction();
      return;
    }
    if (widget.drill.numbered) _spawnSwitchTargets();
    if (widget.drill.id == 'flick') _target = _spawnFarTarget();
    if (!widget.drill.numbered &&
        !widget.drill.tracking &&
        widget.drill.id != 'flick') {
      _target = _spawnRandomTarget();
    }
    _targetShownAt = DateTime.now();
    if (widget.drill.tracking) {
      _motion = Timer.periodic(
        const Duration(milliseconds: 100),
        (_) {
          if (!mounted || _finished) return;
          setState(() {
            _moveTrackingTarget();
            _trackingSamples++;
            if (_crosshair != null && (_crosshair! - _target).distance < .075) {
              _trackingHits++;
            }
            _score = _trackingSamples == 0
                ? 0
                : (_trackingHits * 100 / _trackingSamples).round();
          });
        },
      );
    }
    if (widget.drill.id == 'peek_shot') _schedulePeek();
  }

  Offset _spawnRandomTarget() => Offset(
      .12 + _random.nextDouble() * .76, .14 + _random.nextDouble() * .72);

  Offset _spawnFarTarget() {
    final edge = _random.nextInt(4);
    if (edge == 0) return Offset(.08, .16 + _random.nextDouble() * .68);
    if (edge == 1) return Offset(.92, .16 + _random.nextDouble() * .68);
    if (edge == 2) return Offset(.12 + _random.nextDouble() * .76, .12);
    return Offset(.12 + _random.nextDouble() * .76, .88);
  }

  void _spawnSwitchTargets() {
    final count = 4 + _random.nextInt(2);
    _switchTargets
      ..clear()
      ..addAll(List<Offset>.generate(count, (_) => _spawnRandomTarget()));
    _round = 0;
  }

  void _moveTrackingTarget() {
    if (widget.drill.id == 'recoil_control') {
      final factor = widget.difficulty == 'Hard'
          ? 1.6
          : widget.difficulty == 'Easy'
              ? .7
              : 1.0;
      final sway = (_random.nextDouble() - .5) * .003 * factor;
      _target = Offset((_target.dx + sway).clamp(.12, .88).toDouble(),
          (_target.dy - .003 * factor).clamp(.14, .86).toDouble());
      if (_target.dy <= .15) _target = Offset(_target.dx, .84);
      return;
    }
    if (_random.nextInt(widget.difficulty == 'Hard' ? 8 : 14) == 0) {
      _velocity = Offset((_random.nextDouble() - .5) * .012,
          (_random.nextDouble() - .5) * .012);
    }
    final factor = widget.difficulty == 'Hard'
        ? 1.7
        : widget.difficulty == 'Easy'
            ? .65
            : 1.0;
    var x = _target.dx + _velocity.dx * factor;
    var y = _target.dy + _velocity.dy * factor;
    if (x < .12 || x > .88) _velocity = Offset(-_velocity.dx, _velocity.dy);
    if (y < .14 || y > .86) _velocity = Offset(_velocity.dx, -_velocity.dy);
    x = (x + _velocity.dx * factor).clamp(.12, .88).toDouble();
    y = (y + _velocity.dy * factor).clamp(.14, .86).toDouble();
    _target = Offset(x, y);
  }

  void _scheduleReaction() {
    _reactionReady = false;
    _targetVisible = false;
    _reactionWait?.cancel();
    _reactionWait =
        Timer(Duration(milliseconds: 1000 + _random.nextInt(3001)), () {
      if (!mounted || _finished) return;
      setState(() {
        _reactionReady = true;
        _targetVisible = true;
        _shownAt = DateTime.now();
      });
    });
  }

  void _schedulePeek() {
    final visibleMs = widget.difficulty == 'Hard'
        ? 400 + _random.nextInt(180)
        : 650 + _random.nextInt(251);
    _reactionWait?.cancel();
    _reactionWait = Timer(Duration(milliseconds: visibleMs), () {
      if (!mounted || _finished) return;
      setState(() {
        _targetVisible = false;
        _misses++;
        _score = max(0, _score - 1);
      });
      _feedback(hit: false);
      _reactionWait = Timer(const Duration(milliseconds: 300), () {
        if (!mounted || _finished) return;
        setState(() {
          _targetVisible = true;
          _target = Offset(.12 + _random.nextDouble() * .76,
              .14 + _random.nextDouble() * .72);
          _targetShownAt = DateTime.now();
        });
        _schedulePeek();
      });
    });
  }

  void _stopGameTimers() {
    _clock?.cancel();
    _motion?.cancel();
    _reactionWait?.cancel();
    _markerTimer?.cancel();
  }

  void _finishDrill() {
    if (_finished) return;
    _stopGameTimers();
    if (widget.drill.tracking) {
      final trackingScore = _trackingSamples == 0
          ? 0
          : (_trackingHits * 100 / _trackingSamples).round();
      final smoothnessBonus =
          widget.drill.id == 'recoil_control' && _smoothSamples > 0
              ? (_smoothHits * 10 / _smoothSamples).round()
              : 0;
      _score = min(100, trackingScore + smoothnessBonus);
    }
    _isNewBest = _score > (widget.state.bestScores[widget.drill.id] ?? 0);
    if (mounted) setState(() => _finished = true);
    if (widget.drill.tracking) _feedback(hit: _score >= 50);
    widget.state.recordDrill(widget.drill.id, _score);
  }

  void _handleTap(TapUpDetails details, Size size) {
    if (!_started || _finished) return;
    if (widget.drill.reaction) {
      if (!_reactionReady) {
        setState(() {
          _misses++;
          _round++;
        });
        _feedback(hit: false);
        if (_round >= 5) {
          _finishDrill();
        } else {
          _scheduleReaction();
        }
      } else {
        final elapsed = DateTime.now().difference(_shownAt!).inMilliseconds;
        _reactionTimes.add(elapsed);
        _hits++;
        _score += max(1, 1000 - elapsed) ~/ 20;
        _feedback(hit: true);
        _flashHitMarker(const Offset(.5, .5));
        _round++;
        if (_round >= 5) {
          _finishDrill();
        } else {
          _scheduleReaction();
        }
      }
      setState(() {});
      return;
    }
    if (widget.drill.numbered) {
      final expected = _round % _switchTargets.length;
      var selected = -1;
      var nearest = double.infinity;
      for (var i = 0; i < _switchTargets.length; i++) {
        final point = Offset(_switchTargets[i].dx * size.width,
            _switchTargets[i].dy * size.height);
        final distance = (details.localPosition - point).distance;
        if (distance < nearest) {
          nearest = distance;
          selected = i;
        }
      }
      if (selected == expected && nearest <= _radius + 8) {
        _hits++;
        _score += 15;
        _round++;
        if (_round >= _switchTargets.length) _spawnSwitchTargets();
        _feedback(hit: true);
        _flashHitMarker(_switchTargets[selected]);
      } else {
        _misses++;
        _score = max(0, _score - 2);
        _feedback(hit: false);
      }
      setState(() {});
      return;
    }
    if (widget.drill.id == 'peek_shot' && !_targetVisible) {
      setState(() {
        _misses++;
        _score = max(0, _score - 1);
      });
      _feedback(hit: false);
      return;
    }
    final targetPoint =
        Offset(_target.dx * size.width, _target.dy * size.height);
    final distance = (details.localPosition - targetPoint).distance;
    if (distance <= _radius + 8) {
      _hits++;
      final elapsed = DateTime.now().difference(_targetShownAt).inMilliseconds;
      _targetTimes.add(elapsed);
      _score += widget.drill.id == 'flick' ? max(1, 1000 - elapsed) ~/ 40 : 10;
      _round++;
      _flashHitMarker(_target);
      if (widget.drill.id == 'micro_adjust') {
        _target = Offset(
            (_target.dx + (_random.nextDouble() - .5) * .22)
                .clamp(.12, .88)
                .toDouble(),
            (_target.dy + (_random.nextDouble() - .5) * .22)
                .clamp(.14, .86)
                .toDouble());
      } else {
        _target = widget.drill.id == 'flick'
            ? _spawnFarTarget()
            : _spawnRandomTarget();
      }
      _targetShownAt = DateTime.now();
      _targetVisible = true;
      if (widget.drill.id == 'peek_shot') _schedulePeek();
      _feedback(hit: true);
    } else {
      _misses++;
      _score = max(0, _score - 2);
      _feedback(hit: false);
    }
    setState(() {});
  }

  void _handlePan(DragUpdateDetails details, Size size) {
    if (!_started || _finished || !widget.drill.tracking) return;
    final p = Offset(details.localPosition.dx / size.width,
        details.localPosition.dy / size.height);
    final targetPoint =
        Offset(_target.dx * size.width, _target.dy * size.height);
    final distance = (details.localPosition - targetPoint).distance;
    setState(() {
      _crosshair = p;
      _trackingSamples++;
      if (distance <= _radius + 14) _trackingHits++;
      _score = _trackingSamples == 0
          ? 0
          : (_trackingHits * 100 / _trackingSamples).round();
      if (widget.drill.id == 'recoil_control' && _previousCrosshair != null) {
        _smoothSamples++;
        if ((p - _previousCrosshair!).distance < .035) _smoothHits++;
      }
      _previousCrosshair = p;
    });
  }

  void _feedback({required bool hit}) =>
      widget.state.playTrainingFeedback(hit: hit);

  void _flashHitMarker(Offset position) {
    if (!widget.state.trainingProfileActive ||
        !widget.state.toggle('hit_markers')) {
      return;
    }
    _showHitMarker = true;
    _hitMarkerPosition = position;
    _markerTimer?.cancel();
    _markerTimer = Timer(const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _showHitMarker = false);
    });
  }

  int get _accuracy => widget.drill.tracking
      ? _score.clamp(0, 100).toInt()
      : _hits + _misses == 0
          ? 0
          : (_hits * 100 / (_hits + _misses)).round();
  int? get _averageReaction => _reactionTimes.isEmpty
      ? null
      : (_reactionTimes.reduce((a, b) => a + b) / _reactionTimes.length)
          .round();
  int? get _averageTargetTime => _targetTimes.isEmpty
      ? null
      : (_targetTimes.reduce((a, b) => a + b) / _targetTimes.length).round();

  @override
  void dispose() {
    AuraAds.instance.resumeInterstitials();
    widget.state.removeListener(_handleProfileUpdate);
    _simulatedStatsTimer?.cancel();
    _stopGameTimers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(context.tr(widget.drill.name))),
        body: _finished
            ? _results()
            : LayoutBuilder(builder: (context, constraints) {
                final size = Size(constraints.maxWidth, constraints.maxHeight);
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) => _handleTap(details, size),
                  onPanUpdate: (details) => _handlePan(details, size),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: ColoredBox(
                          color: widget.drill.reaction && _reactionReady
                              ? const Color(0xFFE11D2E)
                              : AuraColors.background,
                        ),
                      ),
                      Positioned(
                        top: 14,
                        left: 16,
                        right: 16,
                        child: _hud(),
                      ),
                      if (_customCrosshairVisible &&
                          !widget.drill.tracking &&
                          widget.drill.id != 'flick')
                        Positioned(
                          left: size.width / 2 - 17,
                          top: size.height / 2 - 17,
                          child: IgnorePointer(
                            child: TrainingReticle(
                              color: _crosshairColor,
                              style: _crosshairStyle,
                              size: 34,
                            ),
                          ),
                        ),
                      if (!_started)
                        Center(
                            child: Text('$_countdown',
                                style: const TextStyle(
                                    fontSize: 72, fontWeight: FontWeight.bold)))
                      else if (widget.drill.reaction)
                        Center(
                          child: Text(
                            context.tr(_reactionReady ? 'TAP!' : 'WAIT'),
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              color: _reactionReady
                                  ? Colors.white
                                  : AuraColors.secondary,
                            ),
                          ),
                        )
                      else if (widget.drill.numbered)
                        for (var i = 0; i < _switchTargets.length; i++)
                          Positioned(
                            left: _switchTargets[i].dx * size.width - _radius,
                            top: _switchTargets[i].dy * size.height - _radius,
                            child: _numberedTarget(
                                i + 1, i == _round % _switchTargets.length),
                          )
                      else if (_targetVisible)
                        Positioned(
                          left: _target.dx * size.width - _radius,
                          top: _target.dy * size.height - _radius,
                          child: _targetWidget(),
                        ),
                      if (widget.drill.tracking && _crosshair != null)
                        Positioned(
                          left: _crosshair!.dx * size.width - 16,
                          top: _crosshair!.dy * size.height - 16,
                          child: _customCrosshairVisible
                              ? IgnorePointer(
                                  child: TrainingReticle(
                                    color: _crosshairColor,
                                    style: _crosshairStyle,
                                    size: 32,
                                  ),
                                )
                              : const Icon(Icons.control_camera,
                                  color: Colors.white, size: 32),
                        ),
                      if (widget.drill.id == 'flick' && _started)
                        Positioned(
                            left: size.width / 2 - 16,
                            top: size.height / 2 - 16,
                            child: _customCrosshairVisible
                                ? IgnorePointer(
                                    child: TrainingReticle(
                                      color: _crosshairColor,
                                      style: _crosshairStyle,
                                      size: 32,
                                    ),
                                  )
                                : const Icon(Icons.add,
                                    color: Colors.white, size: 32)),
                      if (_showHitMarker &&
                          widget.state.trainingProfileActive &&
                          widget.state.toggle('hit_markers'))
                        Positioned(
                          left: _hitMarkerPosition.dx * size.width - 14,
                          top: _hitMarkerPosition.dy * size.height - 14,
                          child: const Icon(Icons.check_circle,
                              color: Colors.white, size: 28),
                        ),
                      if (widget.drill.tracking && _started)
                        Positioned(
                            bottom: 36,
                            left: 0,
                            right: 0,
                            child: Text(
                                context
                                    .tr('Hold and drag to follow the target'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: AuraColors.secondary))),
                    ],
                  ),
                );
              }),
      );

  Widget _hud() {
    final showFps =
        widget.state.trainingProfileActive && widget.state.toggle('fps_live');
    final showRam =
        widget.state.trainingProfileActive && widget.state.toggle('ram_live');
    final showPing =
        widget.state.trainingProfileActive && widget.state.toggle('ping_live');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _hudPill(context, 'SCORE', '$_score'),
            _hudPill(context, 'TIME', '${_remaining}s'),
            if (widget.drill.reaction)
              _hudPill(context, 'ROUND', '$_round/5')
            else
              _hudPill(context, 'HIT', '$_hits'),
          ],
        ),
        if (showFps || showRam || showPing) ...<Widget>[
          const SizedBox(height: 6),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            alignment: WrapAlignment.center,
            children: <Widget>[
              if (showFps) _simulatedMetric('FPS', '$_simulatedFps'),
              if (showRam) _simulatedMetric('RAM', '$_simulatedRam%'),
              if (showPing) _simulatedMetric('PING', '$_simulatedPing ms'),
            ],
          ),
        ],
      ],
    );
  }

  Widget _simulatedMetric(String label, String value) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xE8161616),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AuraColors.redBorder),
        ),
        child: Text.rich(TextSpan(children: <InlineSpan>[
          TextSpan(
              text: '$label  ',
              style: const TextStyle(color: AuraColors.secondary, fontSize: 9)),
          TextSpan(
              text: value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold)),
        ])),
      );

  Widget _hudPill(BuildContext context, String label, String value) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: AuraColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AuraColors.redBorder)),
        child: Column(children: <Widget>[
          Text(context.tr(label),
              style: const TextStyle(
                  color: AuraColors.secondary, fontSize: 9, letterSpacing: 1)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold))
        ]),
      );

  Widget _targetWidget() => Container(
        width: _radius * 2,
        height: _radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.drill.id == 'peek_shot'
              ? const Color(0xFFE11D2E)
              : const Color(0xFFB01525),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const <BoxShadow>[
            BoxShadow(color: Color(0x66E11D2E), blurRadius: 16)
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 20),
      );

  Widget _numberedTarget(int number, bool active) => Container(
        width: _radius * 2,
        height: _radius * 2,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? AuraColors.red : const Color(0xFF6B1720),
            border: Border.all(color: Colors.white, width: 2)),
        child: Center(
            child: Text('$number',
                style: const TextStyle(fontWeight: FontWeight.bold))),
      );

  Widget _results() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.flag_circle, color: AuraColors.red, size: 60),
            const SizedBox(height: 12),
            Text(context.tr('DRILL COMPLETE'),
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2)),
            const SizedBox(height: 20),
            Text('$_score',
                style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: AuraColors.red)),
            Text(context.tr('SCORE'),
                style: const TextStyle(
                    color: AuraColors.secondary, letterSpacing: 2)),
            const SizedBox(height: 20),
            Text('${context.tr('Accuracy')}  $_accuracy%'),
            if (_averageReaction != null)
              Text('${context.tr('Average reaction')}  $_averageReaction ms'),
            if (_reactionTimes.isNotEmpty)
              Text(
                  '${context.tr('Best reaction')}  ${_reactionTimes.reduce(min)} ms'),
            if (_averageTargetTime != null)
              Text(
                  '${context.tr('Average time to hit')}  $_averageTargetTime ms'),
            if (widget.drill.numbered)
              Text(
                  'Targets per minute  ${(_hits * 60 / widget.durationSeconds).round()}'),
            if (_isNewBest)
              Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Chip(
                      avatar:
                          const Icon(Icons.emoji_events, color: Colors.amber),
                      label: Text(context.tr('NEW BEST')))),
            const SizedBox(height: 24),
            Row(children: <Widget>[
              Expanded(
                  child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(context.tr('BACK')))),
              const SizedBox(width: 12),
              Expanded(
                  child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                                builder: (_) => DrillSessionScreen(
                                    drill: widget.drill,
                                    difficulty: widget.difficulty,
                                    durationSeconds: widget.durationSeconds,
                                    state: widget.state)));
                      },
                      child: Text(context.tr('RETRY')))),
            ]),
          ],
        ),
      ),
    );
  }
}
