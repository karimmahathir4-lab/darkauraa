import 'dart:convert';

import 'package:flutter/material.dart';

import 'crosshair_style.dart';

/// Fixed order of the sensitivity sliders (used for saving and sharing).
const List<String> kSensitivityKeys = [
  'General',
  'Red Dot',
  '2x Scope',
  '4x Scope',
  'AWM Scope',
  'Free Look',
];

const String kShareCodePrefix = 'FFP1:';

int _idCounter = 0;

String newProfileId() =>
    '${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}'
    '${(_idCounter++).toRadixString(36)}';

double _r1(double v) => double.parse(v.toStringAsFixed(1));

double _clampD(num v, double lo, double hi) =>
    v.toDouble().clamp(lo, hi).toDouble();

CrosshairStyle styleFromIndex(int i) {
  final last = CrosshairStyle.values.length - 1;
  return CrosshairStyle.values[i < 0 ? 0 : (i > last ? last : i)];
}

class Profile {
  Profile({
    required this.id,
    required this.name,
    required this.style,
    required this.size,
    required this.thickness,
    required this.gap,
    required this.opacity,
    required this.color,
    required this.sensitivity,
  });

  final String id;
  String name;
  final CrosshairStyle style;
  final double size;
  final double thickness;
  final double gap;
  final double opacity;
  final Color color;
  final Map<String, double> sensitivity;

  Profile copyWith({String? id, String? name}) => Profile(
        id: id ?? this.id,
        name: name ?? this.name,
        style: style,
        size: size,
        thickness: thickness,
        gap: gap,
        opacity: opacity,
        color: color,
        sensitivity: Map<String, double>.from(sensitivity),
      );

  /// Identifies the settings only (ignores name and id). Used for the
  /// "unsaved changes" check.
  String get signature => jsonEncode([
        style.index,
        _r1(size),
        _r1(thickness),
        _r1(gap),
        _r1(opacity * 100),
        color.toARGB32() & 0xFFFFFF,
        for (final k in kSensitivityKeys) (sensitivity[k] ?? 0).round(),
      ]);

  // ---------- Storage ----------

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'style': style.index,
        'size': size,
        'thickness': thickness,
        'gap': gap,
        'opacity': opacity,
        'color': color.toARGB32(),
        'sens': sensitivity,
      };

  factory Profile.fromJson(Map<String, dynamic> j) => Profile(
        id: j['id'] as String,
        name: j['name'] as String,
        style: styleFromIndex(j['style'] as int),
        size: _clampD(j['size'] as num, 8, 80),
        thickness: _clampD(j['thickness'] as num, 1, 8),
        gap: _clampD(j['gap'] as num, 0, 20),
        opacity: _clampD(j['opacity'] as num, 0.1, 1),
        color: Color(j['color'] as int),
        sensitivity: (j['sens'] as Map).map<String, double>(
          (k, v) => MapEntry(k.toString(), _clampD(v as num, 0, 100)),
        ),
      );

  // ---------- Sharing ----------

  /// Compact code: FFP1:<base64url(json list)>
  String toShareCode() {
    final shortName = name.length > 20 ? name.substring(0, 20) : name;
    final list = <Object>[
      shortName,
      style.index,
      _r1(size),
      _r1(thickness),
      _r1(gap),
      (opacity * 100).round(),
      color.toARGB32() & 0xFFFFFF,
      for (final k in kSensitivityKeys) (sensitivity[k] ?? 0).round(),
    ];
    return '$kShareCodePrefix${base64Url.encode(utf8.encode(jsonEncode(list)))}';
  }

  /// Returns null if the code is invalid.
  static Profile? fromShareCode(String raw) {
    try {
      final code = raw.trim();
      if (!code.startsWith(kShareCodePrefix)) return null;
      final body = code.substring(kShareCodePrefix.length);
      final list = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(body))),
      ) as List;
      if (list.length != 7 + kSensitivityKeys.length) return null;

      final sens = <String, double>{};
      for (var i = 0; i < kSensitivityKeys.length; i++) {
        sens[kSensitivityKeys[i]] = _clampD(list[7 + i] as num, 0, 100);
      }

      var name = (list[0] as String).trim();
      if (name.isEmpty) name = 'Imported';
      if (name.length > 20) name = name.substring(0, 20);

      return Profile(
        id: newProfileId(),
        name: name,
        style: styleFromIndex(list[1] as int),
        size: _clampD(list[2] as num, 8, 80),
        thickness: _clampD(list[3] as num, 1, 8),
        gap: _clampD(list[4] as num, 0, 20),
        opacity: _clampD((list[5] as num) / 100, 0.1, 1),
        color: Color(0xFF000000 | ((list[6] as int) & 0xFFFFFF)),
        sensitivity: sens,
      );
    } catch (_) {
      return null;
    }
  }
}
