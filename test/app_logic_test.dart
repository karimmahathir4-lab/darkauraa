import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:aura_red_aim_panel/app_state.dart';
import 'package:aura_red_aim_panel/data/iphone_profiles.dart';
import 'package:aura_red_aim_panel/screens/device_info_screen.dart';

void main() {
  group('sensitivity values', () {
    test('generates five bounded values for each sample device profile', () {
      for (final base in <int>[72, 82, 90, 62]) {
        final values = generateSensitivityValues(
            base: base, offset: 8, random: Random(base));
        expect(values.length, 5);
        for (final value in values.values) {
          expect(value, inInclusiveRange(1, 200));
        }
      }
    });
  });

  group('iPhone sample profiles', () {
    test('catalog names are unique and provide bounded baselines', () {
      final names = iPhoneProfiles.map((profile) => profile.model).toSet();
      expect(iPhoneProfiles.length, greaterThanOrEqualTo(40));
      expect(names.length, iPhoneProfiles.length);
      for (final profile in iPhoneProfiles) {
        expect(profile.sampleBase, inInclusiveRange(72, 92));
      }
    });
  });

  group('daily streak', () {
    test('counts consecutive days ending today', () {
      final today = DateTime(2026, 10, 7);
      expect(
          calculateDailyStreak(<DateTime>[
            today,
            today.subtract(const Duration(days: 1)),
            today.subtract(const Duration(days: 2)),
          ], today),
          3);
    });

    test('allows a streak ending yesterday and stops at a gap', () {
      final today = DateTime(2026, 10, 7);
      expect(
          calculateDailyStreak(<DateTime>[
            today.subtract(const Duration(days: 1)),
            today.subtract(const Duration(days: 2)),
            today.subtract(const Duration(days: 4)),
          ], today),
          2);
    });
  });
}
