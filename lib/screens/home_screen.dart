import 'package:flutter/material.dart';

import '../ads/ad_service.dart';
import '../app_state.dart';
import '../data/toggles.dart';
import '../theme.dart';
import '../localization.dart';
import 'widgets.dart';
import 'training_screen.dart';
import 'stats_screen.dart';
import 'device_info_screen.dart';
import 'settings_screen.dart';
import '../widgets/sub_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen(
      {required this.state, required this.onActivateTraining, super.key});
  final AppState state;
  final VoidCallback onActivateTraining;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: <Widget>[
          _masterToggle(context),
          const SizedBox(height: 12),
          AuraCard(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SectionTitle(context.tr('Your Practice Snapshot'),
                      icon: Icons.bolt),
                  const SizedBox(height: 16),
                  Row(children: <Widget>[
                    _metric(
                        context.tr('DAILY STREAK'),
                        '${state.streak} ${context.tr('days')}',
                        Icons.local_fire_department),
                    _metric(context.tr('DRILLS DONE'),
                        '${state.history.length}', Icons.flag),
                    _metric(context.tr('LESSONS'), '${state.lessonPercent}%',
                        Icons.menu_book),
                  ]),
                ]),
          ),
          const SizedBox(height: 12),
          _sensiResult(context),
          const SizedBox(height: 12),
          _quickAccess(context),
          const SizedBox(height: 14),
          for (final group in toggleGroups) ...<Widget>[
            _group(context, group),
            const SizedBox(height: 12),
          ],
          Padding(
            padding: EdgeInsets.only(top: 14),
            child: Text(
              context.tr(
                  'These toggles track your own setup. Nothing in your phone or game is changed.'),
              textAlign: TextAlign.center,
              style: TextStyle(color: AuraColors.secondary, fontSize: 12),
            ),
          ),
        ],
      );

  Widget _sensiResult(BuildContext context) => AuraCard(
        padding: const EdgeInsets.fromLTRB(16, 15, 16, 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                child: Text(context.tr('SENSI RESULT'),
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2)),
              ),
              Text(context.tr('Scale 0 to 200'),
                  style: TextStyle(color: AuraColors.secondary, fontSize: 10)),
            ]),
            const SizedBox(height: 4),
            Text(
              '${context.tr(state.hasGeneratedSensitivityResults ? 'GENERATED' : 'SAMPLE PREVIEW')} · ${state.sensitivityModel}',
              style: const TextStyle(
                  color: AuraColors.secondary, fontSize: 8, letterSpacing: .7),
            ),
            const SizedBox(height: 13),
            for (final label in const <String>[
              'General',
              'Red Dot',
              '2x',
              '4x',
              'AWM'
            ])
              _sensiRow(label, state.sensitivityResults[label] ?? 0),
          ],
        ),
      );

  Widget _sensiRow(String label, int value) => Padding(
        padding: const EdgeInsets.only(bottom: 11),
        child: Row(children: <Widget>[
          SizedBox(
            width: 70,
            child: Text(label,
                style: const TextStyle(fontSize: 11, color: Colors.white)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (value / 200).clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: const Color(0xFF332126),
                color: AuraColors.red,
              ),
            ),
          ),
          SizedBox(
            width: 38,
            child: Text('$value',
                textAlign: TextAlign.right,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
          ),
        ]),
      );

  Widget _masterToggle(BuildContext context) {
    final active = state.trainingProfileActive;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Semantics(
        button: true,
        label: context.tr(
            active ? 'Turn practice profile off' : 'Turn practice profile on'),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () {
              if (active) {
                state.setTrainingProfileActive(false);
              } else if (state.selectedSettingsCount == 0) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text(context.tr('Activate at least one feature')),
                    backgroundColor: AuraColors.red,
                    behavior: SnackBarBehavior.floating,
                  ));
              } else {
                onActivateTraining();
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeInOut,
              height: 76,
              padding: const EdgeInsets.symmetric(horizontal: 21),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  colors: active
                      ? const <Color>[Color(0xFFE11D2E), Color(0xFF5A0A12)]
                      : const <Color>[Color(0xFF28282B), Color(0xFF151518)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                    color: active
                        ? const Color(0x88E11D2E)
                        : const Color(0x35FFFFFF)),
                boxShadow: active
                    ? const <BoxShadow>[
                        BoxShadow(color: Color(0x44E11D2E), blurRadius: 22)
                      ]
                    : const <BoxShadow>[],
              ),
              child: Row(children: <Widget>[
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: Icon(
                    active ? Icons.power_settings_new : Icons.bolt,
                    key: ValueKey<bool>(active),
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: Text(
                          active ? 'ON' : 'OFF',
                          key: ValueKey<bool>(active),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.4),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.tr(active
                            ? 'Practice profile enabled'
                            : 'Tap to enable practice profile'),
                        style: const TextStyle(
                            color: Color(0xFFD8D8DB), fontSize: 11),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  width: 48,
                  height: 28,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: active
                        ? const Color(0xAAFFFFFF)
                        : const Color(0x44000000),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0x55FFFFFF)),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutBack,
                    alignment:
                        active ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: const <BoxShadow>[
                          BoxShadow(color: Color(0x44000000), blurRadius: 5)
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _quickAccess(BuildContext context) => AuraCard(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Wrap(
          alignment: WrapAlignment.spaceAround,
          runSpacing: 10,
          children: <(IconData, String, Widget)>[
            (
              Icons.sports_esports_outlined,
              'Drill library',
              TrainingScreen(state: state)
            ),
            (Icons.insights_outlined, 'Stats', StatsScreen(state: state)),
            (Icons.speed_outlined, 'Monitor', DeviceInfoScreen(state: state)),
            (Icons.settings_outlined, 'Settings', SettingsScreen(state: state)),
          ]
              .map((entry) => SizedBox(
                    width: 78,
                    child: Listener(
                      behavior: HitTestBehavior.translucent,
                      onPointerDown: entry.$2 == 'Settings'
                          ? (_) => AuraAds.instance.pauseInterstitials()
                          : null,
                      onPointerUp: entry.$2 == 'Settings'
                          ? (_) => AuraAds.instance.resumeInterstitials()
                          : null,
                      onPointerCancel: entry.$2 == 'Settings'
                          ? (_) => AuraAds.instance.resumeInterstitials()
                          : null,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          if (entry.$2 == 'Settings') {
                            Navigator.of(context).push(MaterialPageRoute<void>(
                              builder: (_) => SettingsScreen(state: state),
                            ));
                          } else {
                            openSubPage(context, entry.$3);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Column(children: <Widget>[
                            Icon(entry.$1, color: AuraColors.red, size: 20),
                            const SizedBox(height: 5),
                            Text(context.tr(entry.$2),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 10, color: AuraColors.secondary)),
                          ]),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      );

  Widget _metric(String label, String value, IconData icon) => Expanded(
        child: Column(children: <Widget>[
          Icon(icon, color: AuraColors.red, size: 20),
          const SizedBox(height: 6),
          Text(value,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 3),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AuraColors.secondary, fontSize: 8, letterSpacing: .7)),
        ]),
      );

  Widget _group(BuildContext context, ToggleGroup group) {
    final ready = group.items.where((item) => state.toggle(item.id)).length;
    return AuraCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 10, 8),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                  child: Text(context.tr(group.title),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold))),
              Text(
                  '$ready ${context.tr('of')} ${group.items.length} ${context.tr('ready')}',
                  style: const TextStyle(
                      color: AuraColors.secondary, fontSize: 11)),
            ]),
            const SizedBox(height: 6),
            for (final item in group.items)
              Row(children: <Widget>[
                Icon(item.icon, color: AuraColors.red, size: 20),
                const SizedBox(width: 10),
                Expanded(
                    child: InkWell(
                  onTap: () => _showTip(context, item),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(context.tr(item.title),
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600)),
                            Text(context.tr(item.subtitle),
                                style: const TextStyle(
                                    fontSize: 10, color: AuraColors.secondary)),
                          ])),
                )),
                IconButton(
                    tooltip: context.tr('Setup tip'),
                    onPressed: () => _showTip(context, item),
                    icon: const Icon(Icons.info_outline,
                        size: 18, color: AuraColors.secondary)),
                if (!state.isPro &&
                    AuraAds.instance.supportsAds &&
                    AuraAds.rewardedToggleIds.contains(item.id))
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Tooltip(
                      message: context.tr('Rewarded ad feature'),
                      child: const Icon(Icons.play_circle_outline,
                          size: 17, color: AuraColors.red),
                    ),
                  ),
                Switch(
                    value: state.toggle(item.id),
                    onChanged: (value) => _changeToggle(context, item, value)),
              ]),
          ]),
    );
  }

  Future<void> _changeToggle(
      BuildContext context, SetupToggle item, bool enabled) async {
    if (!enabled ||
        state.isPro ||
        !AuraAds.instance.supportsAds ||
        !AuraAds.rewardedToggleIds.contains(item.id)) {
      await state.setToggle(item.id, enabled);
      return;
    }

    AuraAds.instance.pauseInterstitials();
    try {
      final accepted = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(context.tr('Enable with a rewarded ad?')),
          content: Text(context.tr(
              'Watch a short ad to enable this training option. It turns on only after the reward is confirmed.')),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(context.tr('Not now')),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.pop(dialogContext, true),
              icon: const Icon(Icons.play_arrow, size: 18),
              label: Text(context.tr('Watch ad')),
            ),
          ],
        ),
      );
      if (accepted != true || !context.mounted) return;
      final rewarded = await AuraAds.instance.showRewardedForToggle();
      if (!context.mounted) return;
      if (rewarded) {
        await state.setToggle(item.id, true);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('Feature enabled'))),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(context.tr('Ad is not ready. Try again soon.'))),
        );
      }
    } finally {
      AuraAds.instance.resumeInterstitials();
    }
  }

  void _showTip(BuildContext context, SetupToggle item) =>
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: AuraColors.card,
        showDragHandle: true,
        builder: (context) => Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 28),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(context.tr(item.title),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 10),
                Text(context.tr(item.tip),
                    style: const TextStyle(
                        color: AuraColors.secondary, height: 1.5)),
              ]),
        ),
      );
}
