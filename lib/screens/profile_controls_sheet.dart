import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../app_state.dart';
import '../data/toggles.dart';
import '../theme.dart';
import '../localization.dart';
import '../widgets/training_reticle.dart';

Future<void> showProfileControls(BuildContext context, AppState state) {
  var selectedGroup = toggleGroups
      .indexWhere((group) => group.items.any((item) => state.toggle(item.id)));
  return showDialog<void>(
    context: context,
    barrierColor: const Color(0xC9000000),
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setDialogState) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 22),
        backgroundColor: Colors.transparent,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final panelHeight =
                (constraints.maxHeight * .78).clamp(390.0, 680.0);
            final activeGroupIndices = List<int>.generate(
              toggleGroups.length,
              (index) => index,
            )
                .where((index) => toggleGroups[index].items.any(
                      (item) => state.toggle(item.id),
                    ))
                .toList();
            final displayedGroup = activeGroupIndices.contains(selectedGroup)
                ? selectedGroup
                : activeGroupIndices.firstOrNull ?? -1;
            final activeItems = displayedGroup < 0
                ? <SetupToggle>[]
                : toggleGroups[displayedGroup]
                    .items
                    .where((item) => state.toggle(item.id))
                    .toList();
            return SizedBox(
              height: panelHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xF509090A),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: AuraColors.red, width: 1.4),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(color: Color(0x44E11D2E), blurRadius: 25),
                      ],
                    ),
                    child: Column(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(13, 12, 8, 10),
                        child: Row(children: <Widget>[
                          Container(
                            width: 37,
                            height: 37,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: const Color(0x77E11D2E)),
                              image: const DecorationImage(
                                image: AssetImage('assets/aura_red_icon.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(context.tr('PRACTICE PROFILE'),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: .8,
                                        fontSize: 12)),
                                const SizedBox(height: 3),
                                Text(context.tr('App-only preferences'),
                                    style: const TextStyle(
                                        color: AuraColors.secondary,
                                        fontSize: 9)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AuraColors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(context.tr('SIM'),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1)),
                          ),
                          const SizedBox(width: 3),
                          IconButton(
                            tooltip: context.tr('Close'),
                            visualDensity: VisualDensity.compact,
                            onPressed: () => Navigator.pop(dialogContext),
                            icon: const Icon(Icons.close, size: 19),
                          ),
                        ]),
                      ),
                      const Divider(height: 1, color: Color(0x28FFFFFF)),
                      Expanded(
                        child: Row(children: <Widget>[
                          SizedBox(
                            width: 94,
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(7, 10, 6, 8),
                              itemCount: activeGroupIndices.length,
                              itemBuilder: (context, index) {
                                final groupIndex = activeGroupIndices[index];
                                final group = toggleGroups[groupIndex];
                                final selected = selectedGroup == groupIndex;
                                final count = group.items
                                    .where((item) => state.toggle(item.id))
                                    .length;
                                const navigation = <(IconData, String)>[
                                  (Icons.tune, 'Sensi'),
                                  (
                                    Icons.sports_baseball_outlined,
                                    'Ball Setup'
                                  ),
                                  (Icons.gps_fixed, 'Crosshair'),
                                  (Icons.gamepad_outlined, 'Controls'),
                                  (Icons.display_settings_outlined, 'Display'),
                                  (Icons.track_changes, 'Habits'),
                                ];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(13),
                                    onTap: () => setDialogState(
                                        () => selectedGroup = groupIndex),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 160),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 9),
                                      decoration: BoxDecoration(
                                        color: selected
                                            ? const Color(0x33E11D2E)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(13),
                                        border: Border.all(
                                          color: selected
                                              ? const Color(0x66E11D2E)
                                              : const Color(0x1EFFFFFF),
                                        ),
                                      ),
                                      child: Column(children: <Widget>[
                                        Icon(navigation[groupIndex].$1,
                                            size: 18,
                                            color: selected
                                                ? AuraColors.red
                                                : AuraColors.secondary),
                                        const SizedBox(height: 4),
                                        Text(
                                            context
                                                .tr(navigation[groupIndex].$2),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 9,
                                                color: selected
                                                    ? Colors.white
                                                    : AuraColors.secondary,
                                                fontWeight: selected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal)),
                                        const SizedBox(height: 2),
                                        Text('$count/${group.items.length}',
                                            style: const TextStyle(
                                                fontSize: 8,
                                                color: AuraColors.secondary)),
                                      ]),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const VerticalDivider(
                              width: 1, color: Color(0x28FFFFFF)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                if (state.profiles.isNotEmpty)
                                  SizedBox(
                                    height: 34,
                                    child: Row(children: <Widget>[
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          state.tap();
                                          state.cycleProfile(-1);
                                          setDialogState(() {});
                                        },
                                        icon: const Icon(Icons.chevron_left,
                                            size: 18),
                                      ),
                                      Expanded(
                                        child: Text(
                                          state.activeProfile?.name ??
                                              'No profile',
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 11),
                                        ),
                                      ),
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          state.tap();
                                          state.cycleProfile(1);
                                          setDialogState(() {});
                                        },
                                        icon: const Icon(Icons.chevron_right,
                                            size: 18),
                                      ),
                                    ]),
                                  ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(11, 12, 8, 7),
                                  child: Row(children: <Widget>[
                                    Expanded(
                                      child: Text(
                                          displayedGroup < 0
                                              ? 'No active options'
                                              : toggleGroups[displayedGroup]
                                                  .title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Text(
                                      displayedGroup < 0
                                          ? '0 ready'
                                          : '${activeItems.length} ready',
                                      style: const TextStyle(
                                          fontSize: 9,
                                          color: AuraColors.secondary),
                                    ),
                                  ]),
                                ),
                                Expanded(
                                  child: activeItems.isEmpty
                                      ? Center(
                                          child: Text(
                                            context.tr('No active options'),
                                            style: const TextStyle(
                                                color: AuraColors.secondary,
                                                fontSize: 10),
                                          ),
                                        )
                                      : ListView.separated(
                                          padding: const EdgeInsets.fromLTRB(
                                              9, 0, 9, 8),
                                          itemCount: activeItems.length,
                                          separatorBuilder: (_, __) =>
                                              const SizedBox(height: 6),
                                          itemBuilder: (context, index) {
                                            final item = activeItems[index];
                                            final enabled =
                                                state.toggle(item.id);
                                            return Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 6, 5, 6),
                                              decoration: BoxDecoration(
                                                color: enabled
                                                    ? const Color(0x1CE11D2E)
                                                    : const Color(0x111A1A1D),
                                                borderRadius:
                                                    BorderRadius.circular(13),
                                                border: Border.all(
                                                  color: enabled
                                                      ? const Color(0x3DE11D2E)
                                                      : const Color(0x1CFFFFFF),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(children: <Widget>[
                                                    Icon(item.icon,
                                                        size: 15,
                                                        color: enabled
                                                            ? AuraColors.red
                                                            : AuraColors
                                                                .secondary),
                                                    const SizedBox(width: 6),
                                                    Expanded(
                                                      child: Text(
                                                          context
                                                              .tr(item.title),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: const TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                    ),
                                                    SizedBox(
                                                      height: 29,
                                                      child: FittedBox(
                                                        fit: BoxFit.contain,
                                                        child: Switch.adaptive(
                                                          value: enabled,
                                                          activeTrackColor:
                                                              AuraColors.red,
                                                          onChanged: (value) {
                                                            unawaited(
                                                                state.setToggle(
                                                                    item.id,
                                                                    value));
                                                            setDialogState(
                                                                () {});
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                                  if (enabled) ...<Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 21,
                                                              right: 2),
                                                      child: _buildEditor(
                                                          context,
                                                          item,
                                                          state,
                                                          setDialogState),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                      const Divider(height: 1, color: Color(0x28FFFFFF)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(9, 7, 9, 8),
                        child: Text(
                          context.tr(
                              'Nothing on your phone or in a game is changed.'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: AuraColors.secondary, fontSize: 9),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

Widget _buildEditor(BuildContext context, SetupToggle item, AppState state,
    StateSetter setDialogState) {
  final id = item.id;
  switch (id) {
    case 'ball_overlay':
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              context
                  .tr('Saved preference only · no ball is drawn in Training'),
              style: const TextStyle(fontSize: 8, color: AuraColors.secondary)),
          const SizedBox(height: 4),
          _colorEditor(
              context.tr('Ball color preference'), 'ball_color', state),
          const SizedBox(height: 3),
          Text(context.tr('Settings'),
              style: const TextStyle(fontSize: 8, color: AuraColors.secondary)),
          _rangeEditor(context.tr('Preferred ball size'), 'ball_size', state,
              18, 54, ' px'),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: AuraColors.red,
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 7),
                minimumSize: const Size(0, 28),
              ),
              onPressed: () {
                unawaited(state.setToggle('ball_overlay', false));
                setDialogState(() {});
              },
              icon: const Icon(Icons.visibility_off, size: 14),
              label: Text(context.tr('Hide / turn off'),
                  style: const TextStyle(fontSize: 9)),
            ),
          ),
        ],
      );
    case 'crosshair':
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _colorEditor(context.tr('Crosshair color'), 'crosshair_color', state),
          const SizedBox(height: 4),
          _crosshairStylePicker(state),
        ],
      );
    case 'mobile_sensi':
      return _rangeEditor(
          context.tr('Touch sensitivity'), id, state, 1, 200, '');
    case 'emu_sensi':
      return _rangeEditor(
          context.tr('Emulator sensitivity note'), id, state, 1, 200, '');
    case 'phone_dpi':
      return _rangeEditor(
          context.tr('Preferred device DPI note'), id, state, 200, 800, ' DPI');
    case 'ai_sensi_aim':
      return _rangeEditor(
          context.tr('Practice sensitivity note'), id, state, 1, 200, '');
    case 'aim_lock':
      return _InlineNote(
          text: context.tr(
              'Visual focus preference only. No aim is locked or assisted.'));
    case 'fps_live':
      return _InlineNote(
          text:
              context.tr('Generated FPS demo value only; no device reading.'));
    case 'ram_live':
      return _InlineNote(
          text:
              context.tr('Generated RAM demo value only; no device reading.'));
    case 'ping_live':
      return _InlineNote(
          text: context
              .tr('Generated ping demo value only; no network measurement.'));
    case 'gyro':
      return _rangeEditor(
          context.tr('Gyro practice sensitivity'), id, state, 1, 100, '%');
    case 'fire_size':
      return _rangeEditor(
          context.tr('Fire button size'), id, state, 30, 100, '%');
    case 'brightness':
      return _rangeEditor(
          context.tr('Brightness reminder'), id, state, 20, 100, '%');
    case 'warmup':
      return _rangeEditor(
          context.tr('Warm-up length'), id, state, 3, 20, ' min');
    case 'hud_phone':
      return _choiceEditor(context.tr('Phone HUD spacing'), id, state,
          const <String>['Compact', 'Balanced', 'Reach']);
    case 'custom_hud':
      return _choiceEditor(context.tr('Layout preset note'), id, state,
          const <String>['Thumbs', 'Balanced', 'Claw']);
    case 'claw':
      return _choiceEditor(context.tr('Finger layout note'), id, state,
          const <String>['Three fingers', 'Four fingers']);
    case 'high_fps':
      return _choiceEditor(context.tr('Frame-rate target note'), id, state,
          const <String>['60 FPS', '90 FPS', '120 FPS', '144 FPS']);
    case 'smooth_graphics':
      return _choiceEditor(context.tr('Graphics preference'), id, state,
          const <String>['Smooth', 'Balanced', 'Quality']);
    case 'haptics':
      return _InlineNote(
          text: context.tr(
              'Hits use a medium vibration; misses use a lighter vibration while the practice profile is on.'));
    case 'sounds':
      return _InlineNote(
          text: context.tr(
              'A short system click plays after hits and misses while the practice profile is on.'));
    case 'hit_markers':
      return _InlineNote(
          text: context.tr('Show hit markers in supported drills.'));
    default:
      return const SizedBox.shrink();
  }
}

Widget _colorEditor(String label, String id, AppState state) => StatefulBuilder(
      builder: (context, setLocalState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: <Widget>[
            Expanded(
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 8, color: AuraColors.secondary))),
            Text(state.profileValue(id) as String? ?? 'Red',
                style:
                    const TextStyle(fontSize: 8, color: AuraColors.secondary)),
          ]),
          const SizedBox(height: 4),
          Wrap(
            spacing: 5,
            runSpacing: 4,
            children: trainingOverlayColors.entries.map((entry) {
              final selected = state.profileValue(id) == entry.key;
              return Tooltip(
                message: entry.key,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    setLocalState(() {});
                    unawaited(state.setProfileValue(id, entry.key));
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 130),
                    width: 17,
                    height: 17,
                    decoration: BoxDecoration(
                      color: Color(entry.value),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            selected ? Colors.white : const Color(0x66888888),
                        width: selected ? 2 : 1,
                      ),
                      boxShadow: selected
                          ? <BoxShadow>[
                              BoxShadow(
                                  color: Color(entry.value), blurRadius: 7)
                            ]
                          : const <BoxShadow>[],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );

Widget _crosshairStylePicker(AppState state) => StatefulBuilder(
      builder: (context, setLocalState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(context.tr('Settings · Pro Crosshair'),
              style: const TextStyle(fontSize: 8, color: AuraColors.secondary)),
          const SizedBox(height: 4),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: <Widget>[
              for (final style in const <String>[
                'Precision',
                'Classic',
                'Dot',
                'Circle',
                'T-Shape'
              ]) ...<Widget>[
                Tooltip(
                  message: style,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      setLocalState(() {});
                      unawaited(
                          state.setProfileValue('crosshair_style', style));
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 140),
                      width: 39,
                      height: 41,
                      decoration: BoxDecoration(
                        color: state.profileValue('crosshair_style') == style
                            ? const Color(0x33E11D2E)
                            : const Color(0x161A1A1D),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: state.profileValue('crosshair_style') == style
                              ? AuraColors.red
                              : const Color(0x28FFFFFF),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TrainingReticle(
                            color: Color(trainingOverlayColors[
                                    state.profileValue('crosshair_color')
                                            as String? ??
                                        'Lime'] ??
                                0xFFB5F542),
                            style: style,
                            size: 21,
                          ),
                          Text(context.tr(style == 'Precision' ? 'PRO' : style),
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: const TextStyle(fontSize: 6, height: 1.2)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ]),
          ),
        ],
      ),
    );

Widget _rangeEditor(
  String label,
  String id,
  AppState state,
  double min,
  double max,
  String suffix,
) =>
    StatefulBuilder(
      builder: (context, setLocalState) {
        final value = (state.profileValue(id) as num?)?.toDouble() ?? min;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                  child: Text(label,
                      style: const TextStyle(
                          fontSize: 8, color: AuraColors.secondary))),
              Text('${value.round()}$suffix',
                  style: const TextStyle(
                      fontSize: 9, fontWeight: FontWeight.bold)),
            ]),
            SizedBox(
              height: 27,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 12),
                ),
                child: Slider(
                  value: value.clamp(min, max).toDouble(),
                  min: min,
                  max: max,
                  activeColor: AuraColors.red,
                  inactiveColor: const Color(0xFF3A171B),
                  onChanged: (next) {
                    state.updateProfileValue(id, next.round());
                    setLocalState(() {});
                  },
                  onChangeEnd: (_) => unawaited(state.saveProfileValues()),
                ),
              ),
            ),
          ],
        );
      },
    );

Widget _choiceEditor(
  String label,
  String id,
  AppState state,
  List<String> choices,
) =>
    StatefulBuilder(
      builder: (context, setLocalState) => Row(children: <Widget>[
        Expanded(
            child: Text(label,
                style:
                    const TextStyle(fontSize: 8, color: AuraColors.secondary))),
        const SizedBox(width: 4),
        DropdownButton<String>(
          value: choices.contains(state.profileValue(id))
              ? state.profileValue(id) as String
              : choices.first,
          isDense: true,
          underline: const SizedBox.shrink(),
          dropdownColor: AuraColors.card,
          style: const TextStyle(fontSize: 9, color: Colors.white),
          items: choices
              .map((choice) => DropdownMenuItem<String>(
                    value: choice,
                    child: Text(context.tr(choice),
                        style: const TextStyle(fontSize: 9)),
                  ))
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            setLocalState(() {});
            unawaited(state.setProfileValue(id, value));
          },
        ),
      ]),
    );

class _InlineNote extends StatelessWidget {
  const _InlineNote({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 21, top: 2),
        child: Text(context.tr(text),
            style: const TextStyle(color: AuraColors.secondary, fontSize: 8)),
      );
}
