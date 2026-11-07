import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aura_red_aim_panel/models/crosshair_style.dart';
import 'package:aura_red_aim_panel/models/profile.dart';

void main() {
  test('profile share code round-trips crosshair and sensitivity values', () {
    final source = Profile(
      id: 'test-profile',
      name: 'Practice',
      style: CrosshairStyle.tShape,
      size: 38,
      thickness: 3,
      gap: 6,
      opacity: .75,
      color: const Color(0xFF35D8E6),
      sensitivity: <String, double>{
        for (final key in kSensitivityKeys) key: 72,
      },
    );

    final imported = Profile.fromShareCode(source.toShareCode());

    expect(imported, isNotNull);
    expect(imported!.name, source.name);
    expect(imported.style, source.style);
    expect(imported.size, source.size);
    expect(imported.thickness, source.thickness);
    expect(imported.gap, source.gap);
    expect(imported.opacity, closeTo(source.opacity, .01));
    expect(imported.color, source.color);
    expect(imported.sensitivity, source.sensitivity);
  });

  test('rejects malformed profile share codes', () {
    expect(Profile.fromShareCode('not-a-profile'), isNull);
    expect(Profile.fromShareCode('FFP1:broken'), isNull);
  });
}
