import 'package:flutter/material.dart';

import '../app_state.dart';
import '../drills/drill_base.dart';
import '../drills/tap_target.dart';
import '../drills/reaction.dart';
import '../drills/flick.dart';
import '../drills/tracking.dart';
import '../drills/micro_adjust.dart';
import '../drills/target_switch.dart';
import '../drills/peek_shot.dart';
import '../drills/recoil_control.dart';
import '../theme.dart';
import '../localization.dart';
import 'widgets.dart';

const List<DrillDefinition> trainingDrills = <DrillDefinition>[
  tapTargetDrill,
  reactionDrill,
  flickDrill,
  trackingDrill,
  microAdjustDrill,
  targetSwitchDrill,
  peekShotDrill,
  recoilControlDrill,
];

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({required this.state, super.key});
  final AppState state;

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  String _difficulty = 'Medium';
  int _duration = 30;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: <Widget>[
          RedGradientHeader(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Text(context.tr('TRAIN WITH INTENTION'),
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1)),
                const SizedBox(height: 5),
                Text(
                    context.tr(
                        'Short practice rounds for timing, control, and precision.'),
                    style: const TextStyle(
                        color: Color(0xFFE9C9CC), fontSize: 12)),
              ])),
          const SizedBox(height: 14),
          AuraCard(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Text(context.tr('Round length'),
                    style: const TextStyle(
                        color: AuraColors.secondary, fontSize: 12)),
                const SizedBox(height: 8),
                Wrap(
                    spacing: 8,
                    children: <int>[15, 30, 60]
                        .map((seconds) => ChoiceChip(
                              label: Text('$seconds ${context.tr('sec')}'),
                              selected: _duration == seconds,
                              showCheckmark: false,
                              onSelected: (_) =>
                                  setState(() => _duration = seconds),
                              selectedColor: AuraColors.red,
                            ))
                        .toList()),
              ])),
          const SizedBox(height: 14),
          for (final drill in trainingDrills) ...<Widget>[
            _drillCard(drill),
            const SizedBox(height: 12),
          ],
        ],
      );

  Widget _drillCard(DrillDefinition drill) => AuraCard(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[
                Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                        color: const Color(0x335A0A12),
                        borderRadius: BorderRadius.circular(13)),
                    child: Icon(drill.icon, color: AuraColors.red)),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      Text(context.tr(drill.name),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(
                          '${context.tr('Trains')} ${context.tr(drill.trains)}',
                          style: const TextStyle(
                              color: AuraColors.secondary, fontSize: 11)),
                    ])),
                Text(
                    '${context.tr('BEST')} ${widget.state.bestScores[drill.id] ?? '—'}',
                    style: const TextStyle(
                        color: AuraColors.secondary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 9),
              Text(context.tr(drill.description),
                  style: const TextStyle(
                      color: AuraColors.secondary, fontSize: 12)),
              const SizedBox(height: 7),
              Wrap(
                  spacing: 6,
                  children: <String>['Easy', 'Medium', 'Hard']
                      .map((level) => ChoiceChip(
                            label: Text(context.tr(level),
                                style: const TextStyle(fontSize: 10)),
                            selected: _difficulty == level,
                            showCheckmark: false,
                            visualDensity: VisualDensity.compact,
                            onSelected: (_) =>
                                setState(() => _difficulty = level),
                            selectedColor: AuraColors.red,
                          ))
                      .toList()),
              Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (_) => DrillSessionScreen(
                                  drill: drill,
                                  difficulty: _difficulty,
                                  durationSeconds: _duration,
                                  state: widget.state,
                                ))),
                    icon: const Icon(Icons.play_arrow),
                    label: Text(context.tr('Start')),
                  )),
            ]),
      );
}
