import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TrainerMode { classic, speed, precision, moving, daily }

class ModeConfig {
  const ModeConfig({
    required this.label,
    required this.blurb,
    required this.seconds,
    required this.radius,
    required this.lifetime,
    this.moving = false,
    this.simultaneous = 1,
  });

  final String label;
  final String blurb;
  final int seconds;
  final double radius; // target radius in px
  final double lifetime; // seconds a target stays
  final bool moving;
  final int simultaneous;
}

ModeConfig modeConfig(TrainerMode m) {
  switch (m) {
    case TrainerMode.classic:
      return const ModeConfig(
        label: 'Classic',
        blurb: 'One target at a time. Steady pace.',
        seconds: 30,
        radius: 34,
        lifetime: 1.8,
      );
    case TrainerMode.speed:
      return const ModeConfig(
        label: 'Speed',
        blurb: 'Targets vanish fast. Stay sharp.',
        seconds: 20,
        radius: 30,
        lifetime: 1.1,
      );
    case TrainerMode.precision:
      return const ModeConfig(
        label: 'Precision',
        blurb: 'Small targets. Accuracy matters.',
        seconds: 30,
        radius: 18,
        lifetime: 2.4,
      );
    case TrainerMode.moving:
      return const ModeConfig(
        label: 'Moving',
        blurb: 'Two bouncing targets at once.',
        seconds: 30,
        radius: 30,
        lifetime: 2.6,
        moving: true,
        simultaneous: 2,
      );
    case TrainerMode.daily:
      return const ModeConfig(
        label: 'Daily',
        blurb: 'Same target layout for everyone today.',
        seconds: 30,
        radius: 28,
        lifetime: 1.6,
      );
  }
}

class TrainerResult {
  TrainerResult({
    required this.mode,
    required this.score,
    required this.hits,
    required this.misses,
    required this.avgMs,
    required this.bestMs,
    required this.maxStreak,
    required this.profileId,
    required this.timestamp,
  });

  final TrainerMode mode;
  final int score;
  final int hits;
  final int misses;
  final double avgMs;
  final double bestMs;
  final int maxStreak;
  final String profileId;
  final int timestamp;

  double get accuracy => hits + misses == 0 ? 0 : hits / (hits + misses) * 100;

  Map<String, dynamic> toJson() => {
        'mode': mode.name,
        'score': score,
        'hits': hits,
        'misses': misses,
        'avgMs': avgMs,
        'bestMs': bestMs,
        'maxStreak': maxStreak,
        'profileId': profileId,
        't': timestamp,
      };

  factory TrainerResult.fromJson(Map<String, dynamic> j) => TrainerResult(
        mode: TrainerMode.values.firstWhere(
          (m) => m.name == j['mode'],
          orElse: () => TrainerMode.classic,
        ),
        score: (j['score'] as num).toInt(),
        hits: (j['hits'] as num).toInt(),
        misses: (j['misses'] as num).toInt(),
        avgMs: (j['avgMs'] as num).toDouble(),
        bestMs: (j['bestMs'] as num).toDouble(),
        maxStreak: (j['maxStreak'] as num).toInt(),
        profileId: j['profileId'] as String,
        timestamp: (j['t'] as num).toInt(),
      );
}

/// S / A / B / C / D from accuracy and average reaction time.
String gradeFor(TrainerResult r) {
  final speed =
      r.avgMs == 0 ? 0.0 : ((1200 - r.avgMs) / 900).clamp(0.0, 1.0).toDouble();
  final s = (r.accuracy / 100) * 0.6 + speed * 0.4;
  if (s >= 0.85) return 'S';
  if (s >= 0.70) return 'A';
  if (s >= 0.55) return 'B';
  if (s >= 0.40) return 'C';
  return 'D';
}

class Achievement {
  const Achievement(this.title, this.description, this.icon, this.unlocked);
  final String title;
  final String description;
  final IconData icon;
  final bool unlocked;
}

Map<String, int> _intMap(dynamic raw) => raw is Map
    ? raw.map<String, int>((k, v) => MapEntry(k.toString(), (v as num).toInt()))
    : <String, int>{};

class TrainerStore extends ChangeNotifier {
  final List<TrainerResult> history = [];
  int sessions = 0;
  int totalHits = 0;
  int bestStreak = 0;
  double bestAccuracy = 0; // sessions with 20+ shots
  double bestAvgMs = 0; // sessions with 10+ hits
  final Set<String> profilesUsed = {};
  final Map<String, int> modeBest = {};
  final Map<String, int> profileBest = {};
  final Map<String, int> profileSessions = {};

  int bestScore(TrainerMode m) => modeBest[m.name] ?? 0;

  void add(TrainerResult r) {
    history.add(r);
    if (history.length > 40) history.removeAt(0);

    sessions++;
    totalHits += r.hits;
    if (r.maxStreak > bestStreak) bestStreak = r.maxStreak;
    if (r.hits + r.misses >= 20 && r.accuracy > bestAccuracy) {
      bestAccuracy = r.accuracy;
    }
    if (r.hits >= 10 &&
        r.avgMs > 0 &&
        (bestAvgMs == 0 || r.avgMs < bestAvgMs)) {
      bestAvgMs = r.avgMs;
    }
    profilesUsed.add(r.profileId);
    if (r.score > bestScore(r.mode)) modeBest[r.mode.name] = r.score;
    if (r.score > (profileBest[r.profileId] ?? 0)) {
      profileBest[r.profileId] = r.score;
    }
    profileSessions[r.profileId] = (profileSessions[r.profileId] ?? 0) + 1;

    notifyListeners();
    _save();
  }

  List<Achievement> get achievements => [
        Achievement('First Blood', 'Finish your first session', Icons.flag,
            sessions > 0),
        Achievement('Sharpshooter', '90% accuracy with 20+ shots',
            Icons.gps_fixed, bestAccuracy >= 90),
        Achievement('Quick Draw', 'Average under 600 ms (10+ hits)',
            Icons.flash_on, bestAvgMs > 0 && bestAvgMs < 600),
        Achievement('On Fire', 'Hit a streak of 15',
            Icons.local_fire_department, bestStreak >= 15),
        Achievement('Centurion', '100 total hits', Icons.military_tech,
            totalHits >= 100),
        Achievement('Profile Hopper', 'Play with 3 different profiles',
            Icons.swap_horiz, profilesUsed.length >= 3),
      ];

  void clear() {
    history.clear();
    sessions = 0;
    totalHits = 0;
    bestStreak = 0;
    bestAccuracy = 0;
    bestAvgMs = 0;
    profilesUsed.clear();
    modeBest.clear();
    profileBest.clear();
    profileSessions.clear();
    notifyListeners();
    _save();
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'trainer',
        jsonEncode({
          'history': history.map((e) => e.toJson()).toList(),
          'sessions': sessions,
          'totalHits': totalHits,
          'bestStreak': bestStreak,
          'bestAccuracy': bestAccuracy,
          'bestAvgMs': bestAvgMs,
          'profilesUsed': profilesUsed.toList(),
          'modeBest': modeBest,
          'profileBest': profileBest,
          'profileSessions': profileSessions,
        }),
      );
    } catch (_) {}
  }

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('trainer');
      if (raw == null) return;
      final m = jsonDecode(raw) as Map<String, dynamic>;

      history
        ..clear()
        ..addAll(((m['history'] as List?) ?? const []).map(
          (e) => TrainerResult.fromJson(Map<String, dynamic>.from(e as Map)),
        ));
      sessions = (m['sessions'] as num?)?.toInt() ?? 0;
      totalHits = (m['totalHits'] as num?)?.toInt() ?? 0;
      bestStreak = (m['bestStreak'] as num?)?.toInt() ?? 0;
      bestAccuracy = (m['bestAccuracy'] as num?)?.toDouble() ?? 0;
      bestAvgMs = (m['bestAvgMs'] as num?)?.toDouble() ?? 0;
      profilesUsed
        ..clear()
        ..addAll(((m['profilesUsed'] as List?) ?? const [])
            .map((e) => e.toString()));
      modeBest
        ..clear()
        ..addAll(_intMap(m['modeBest']));
      profileBest
        ..clear()
        ..addAll(_intMap(m['profileBest']));
      profileSessions
        ..clear()
        ..addAll(_intMap(m['profileSessions']));
      notifyListeners();
    } catch (_) {}
  }
}

final TrainerStore trainerStore = TrainerStore();
