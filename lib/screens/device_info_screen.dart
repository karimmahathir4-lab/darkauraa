import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme.dart';
import '../localization.dart';
import '../app_state.dart';
import '../data/iphone_profiles.dart';
import 'widgets.dart';

const List<String> _scopeNames = <String>[
  'General',
  'Red Dot',
  '2x',
  '4x',
  'AWM'
];
const List<double> _scopeFactors = <double>[1, .95, .85, .75, .6];
const Map<String, int> _styleOffsets = <String, int>{
  'Defensive': -8,
  'Balanced': 0,
  'Aggressive': 8
};

Map<String, int> generateSensitivityValues(
        {required int base, required int offset, required Random random}) =>
    <String, int>{
      for (var i = 0; i < _scopeNames.length; i++)
        _scopeNames[i]:
            ((base + offset + random.nextInt(13) - 6) * _scopeFactors[i] * 2)
                .round()
                .clamp(1, 200)
                .toInt(),
    };

class DeviceInfoScreen extends StatefulWidget {
  const DeviceInfoScreen({required this.state, super.key});
  final AppState state;
  @override
  State<DeviceInfoScreen> createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends State<DeviceInfoScreen> {
  static const String _modelPreferenceKey = 'aura.selected_iphone_model';
  final Random _random = Random();
  Timer? _timer;
  String _iphoneModel = 'iPhone 13';
  String _style = 'Balanced';
  bool _generating = false;
  Map<String, int>? _values;
  final Map<String, int> _stats = <String, int>{
    'FPS': 56,
    'CPU': 42,
    'RAM': 61,
    'TEMP': 38
  };

  @override
  void initState() {
    super.initState();
    _restoreIPhoneModel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _stats['FPS'] = _drift('FPS', -2, 2, 48, 60);
        _stats['CPU'] = _drift('CPU', -5, 5, 15, 85);
        _stats['RAM'] = _drift('RAM', -2, 2, 40, 80);
        _stats['TEMP'] = _drift('TEMP', -1, 1, 32, 46);
      });
    });
  }

  Future<void> _restoreIPhoneModel() async {
    final prefs = await SharedPreferences.getInstance();
    final savedModel = prefs.getString(_modelPreferenceKey);
    if (!mounted ||
        savedModel == null ||
        !iPhoneProfiles.any((profile) => profile.model == savedModel)) return;
    setState(() {
      _iphoneModel = savedModel;
      _values = null;
    });
  }

  int _drift(String key, int low, int high, int min, int max) =>
      (_stats[key]! + low + _random.nextInt(high - low + 1))
          .clamp(min, max)
          .toInt();

  Future<void> _generate() async {
    setState(() => _generating = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _values = generateSensitivityValues(
          base: iPhoneProfiles
              .firstWhere((profile) => profile.model == _iphoneModel)
              .sampleBase,
          offset: _styleOffsets[_style]!,
          random: _random);
      _generating = false;
    });
    widget.state.updateSensitivityResults(_values!, _iphoneModel);
  }

  Future<void> _copy() async {
    final values = _values;
    if (values == null) return;
    await Clipboard.setData(ClipboardData(
        text: values.entries.map((e) => '${e.key}: ${e.value}').join('\n')));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(context.tr('Copied simulated values')),
        backgroundColor: AuraColors.red));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: <Widget>[
            _generatorCard(),
            const SizedBox(height: 14),
            _sampleDeviceCard(),
            const SizedBox(height: 14),
            _performanceCard(),
          ]);

  Widget _generatorCard() => AuraCard(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            SectionTitle(context.tr('Sensitivity Generator (simulated)'),
                icon: Icons.tune),
            const SizedBox(height: 14),
            _iphoneModelSelector(context),
            const SizedBox(height: 12),
            _chipSet(
                context.tr('Play style'),
                _styleOffsets.keys.map(context.tr).toList(),
                context.tr(_style),
                (value) => setState(() => _style = _styleOffsets.keys
                    .firstWhere((key) => context.tr(key) == value))),
            const SizedBox(height: 16),
            SizedBox(
                width: double.infinity,
                height: 46,
                child: FilledButton.icon(
                  onPressed: _generating ? null : _generate,
                  icon: _generating
                      ? const SizedBox.square(
                          dimension: 17,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.auto_awesome),
                  label: Text(
                      context.tr(_generating ? 'GENERATING...' : 'GENERATE')),
                  style: FilledButton.styleFrom(
                      backgroundColor: AuraColors.red,
                      disabledBackgroundColor: AuraColors.red),
                )),
            if (_values != null) ...<Widget>[
              const SizedBox(height: 16),
              for (final name in _scopeNames)
                _valueRow(context, name, _values![name]!),
              Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                      onPressed: _copy,
                      icon: const Icon(Icons.copy, size: 16),
                      label: Text(context.tr('Copy')))),
            ],
            Text(
                context.tr(
                    'Illustrative starting point only. Apple and games do not publish universal per-iPhone aim sensitivity values; tune these in your own game.'),
                style: TextStyle(color: AuraColors.secondary, fontSize: 11)),
          ]));

  Widget _chipSet(String label, List<String> options, String selected,
          ValueChanged<String> onSelect) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Text(context.tr(label),
            style: const TextStyle(color: AuraColors.secondary, fontSize: 11)),
        const SizedBox(height: 5),
        Wrap(
            spacing: 6,
            children: options
                .map((option) => ChoiceChip(
                      label: Text(option, style: const TextStyle(fontSize: 11)),
                      selected: selected == option,
                      showCheckmark: false,
                      selectedColor: AuraColors.red,
                      onSelected: (_) => onSelect(option),
                    ))
                .toList()),
      ]);

  Widget _valueRow(BuildContext context, String name, int value) => Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(children: <Widget>[
        SizedBox(
            width: 74,
            child:
                Text(context.tr(name), style: const TextStyle(fontSize: 11))),
        Expanded(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                    value: value / 200,
                    minHeight: 7,
                    backgroundColor: const Color(0xFF303030),
                    color: AuraColors.red))),
        SizedBox(
            width: 38,
            child: Text('$value',
                textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.bold))),
      ]));

  Widget _iphoneModelSelector(BuildContext context) {
    final selected =
        iPhoneProfiles.firstWhere((profile) => profile.model == _iphoneModel);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(context.tr('iPhone model · choose manually'),
            style: TextStyle(color: AuraColors.secondary, fontSize: 11)),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          initialValue: _iphoneModel,
          isExpanded: true,
          dropdownColor: AuraColors.card,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF101012),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: iPhoneProfiles
              .map((profile) => DropdownMenuItem<String>(
                    value: profile.model,
                    child: Text('${profile.model} · ${profile.displaySummary}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11)),
                  ))
              .toList(),
          onChanged: (model) {
            if (model == null) return;
            setState(() {
              _iphoneModel = model;
              _values = null;
            });
            unawaited(SharedPreferences.getInstance()
                .then((prefs) => prefs.setString(_modelPreferenceKey, model)));
          },
        ),
        const SizedBox(height: 4),
        Text(
            '${context.tr('Sample baseline')} ${selected.sampleBase} · ${context.tr('Sensitivity varies by game and player.')}',
            style: const TextStyle(color: AuraColors.secondary, fontSize: 9)),
      ],
    );
  }

  Widget _sampleDeviceCard() {
    final selected =
        iPhoneProfiles.firstWhere((profile) => profile.model == _iphoneModel);
    return AuraCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SectionTitle(context.tr('Device Info (sample data)'),
              icon: Icons.smartphone),
          const SizedBox(height: 14),
          _InfoLine('Model', selected.model),
          const _InfoLine('Platform', 'iPhone · manual selection'),
          const _InfoLine('iOS version', 'Not read · sample panel'),
          _InfoLine('Display size',
              '${selected.screenInches.toStringAsFixed(1)} inches'),
          _InfoLine('Display refresh',
              'Up to ${selected.refreshHz} Hz (specification)'),
          const _InfoLine('Preset source', 'Illustrative estimate'),
        ],
      ),
    );
  }

  Widget _performanceCard() => AuraCard(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            SectionTitle(context.tr('Live Performance (simulated)'),
                icon: Icons.speed),
            const SizedBox(height: 18),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _gauge('FPS', _stats['FPS']!, 60, ''),
                  _gauge('CPU', _stats['CPU']!, 100, '%'),
                  _gauge('RAM', _stats['RAM']!, 100, '%'),
                  _gauge('TEMP', _stats['TEMP']!, 50, '°'),
                ]),
          ]));

  Widget _gauge(String label, int value, int max, String suffix) => SizedBox(
      width: 62,
      child: Column(children: <Widget>[
        SizedBox.square(
            dimension: 62,
            child: Stack(alignment: Alignment.center, children: <Widget>[
              CircularProgressIndicator(
                  value: (value / max).clamp(0.0, 1.0),
                  strokeWidth: 5,
                  backgroundColor: const Color(0xFF303030),
                  color: AuraColors.red,
                  strokeCap: StrokeCap.round),
              Text('$value$suffix',
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold)),
            ])),
        const SizedBox(height: 6),
        Text(context.tr(label),
            style: const TextStyle(
                color: AuraColors.secondary, fontSize: 9, letterSpacing: 1)),
      ]));
}

class _InfoLine extends StatelessWidget {
  const _InfoLine(this.label, this.value);
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 11),
      child: Row(children: <Widget>[
        Expanded(
            child: Text(context.tr(label),
                style: const TextStyle(
                    color: AuraColors.secondary, fontSize: 12))),
        Text(value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ]));
}
