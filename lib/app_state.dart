import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'data/toggles.dart';
import 'models/crosshair_style.dart';
import 'models/profile.dart';
import 'storage.dart';

DateTime _day(DateTime date) => DateTime(date.year, date.month, date.day);

int calculateDailyStreak(Iterable<DateTime> completedDays, DateTime today) {
  final days = completedDays.map(_day).toSet();
  var cursor = _day(today);
  if (!days.contains(cursor)) {
    cursor = cursor.subtract(const Duration(days: 1));
    if (!days.contains(cursor)) return 0;
  }
  var streak = 0;
  while (days.contains(cursor)) {
    streak++;
    cursor = cursor.subtract(const Duration(days: 1));
  }
  return streak;
}

class AppState extends ChangeNotifier {
  String languageCode = 'en';
  bool onboardingComplete = false;
  bool initialPaywallSeen = false;
  bool isPro = false;
  bool trainingProfileActive = false;
  Map<String, bool> toggles = defaultToggleValues();
  Map<String, int> bestScores = <String, int>{};
  List<Map<String, dynamic>> history = <Map<String, dynamic>>[];
  Set<String> completedLessons = <String>{};
  Map<String, dynamic> profileValues = defaultProfileValues();
  Map<String, int> sensitivityResults = <String, int>{
    'General': 164,
    'Red Dot': 156,
    '2x': 140,
    '4x': 124,
    'AWM': 98,
  };
  String sensitivityModel = 'iPhone 13';
  bool hasGeneratedSensitivityResults = false;
  List<Profile> profiles = <Profile>[];
  String? activeProfileId;
  Map<String, double> sensitivity = <String, double>{
    for (final key in kSensitivityKeys) key: 70,
  };

  Profile? get activeProfile {
    for (final profile in profiles) {
      if (profile.id == activeProfileId) return profile;
    }
    return null;
  }

  CrosshairStyle get crosshairStyle {
    final value = profileValue('crosshair_style');
    return switch (value) {
      'Dot' => CrosshairStyle.dot,
      'Circle' => CrosshairStyle.circle,
      'Plus' => CrosshairStyle.plus,
      'T-Shape' => CrosshairStyle.tShape,
      _ => CrosshairStyle.cross,
    };
  }

  double get crosshairSize =>
      (profileValue('crosshair_size') as num?)?.toDouble() ?? 32;
  double get crosshairThickness =>
      (profileValue('crosshair_thickness') as num?)?.toDouble() ?? 2;
  double get crosshairGap =>
      (profileValue('crosshair_gap') as num?)?.toDouble() ?? 5;
  double get crosshairOpacity =>
      (profileValue('crosshair_opacity') as num?)?.toDouble() ?? .9;
  Color get crosshairColor {
    final name = profileValue('crosshair_color') as String? ?? 'Lime';
    final value = trainingOverlayColors[name] ?? 0xFFB5F542;
    return Color(value);
  }

  bool get isDirty {
    final active = activeProfile;
    return active != null && active.signature != snapshot('').signature;
  }

  Future<void> load() async {
    onboardingComplete = await AuraStorage.readOnboardingComplete();
    initialPaywallSeen = await AuraStorage.readInitialPaywallSeen();
    final savedLanguage = await AuraStorage.readLanguage();
    if (const <String>{'en', 'pt', 'es', 'ar'}.contains(savedLanguage)) {
      languageCode = savedLanguage;
    }
    toggles = <String, bool>{
      ...defaultToggleValues(),
      ...await AuraStorage.readToggles()
    };
    bestScores = await AuraStorage.readScores();
    history = await AuraStorage.readHistory();
    completedLessons = await AuraStorage.readLessons();
    profileValues = <String, dynamic>{
      ...defaultProfileValues(),
      ...await AuraStorage.readProfileValues(),
    };
    final savedProfiles = profileValues['saved_profiles'];
    if (savedProfiles is List) {
      try {
        profiles = savedProfiles
            .map((entry) =>
                Profile.fromJson(Map<String, dynamic>.from(entry as Map)))
            .toList();
      } catch (_) {
        profiles = <Profile>[];
      }
    }
    activeProfileId = profileValues['active_profile_id'] as String?;
    if (profiles.isEmpty) {
      profiles = _seedProfiles();
      activeProfileId = profiles.first.id;
      _applyProfile(profiles.first);
      await _persistProfiles();
    } else if (activeProfile == null) {
      activeProfileId = profiles.first.id;
      _applyProfile(profiles.first);
    } else {
      _applySensitivity(activeProfile!);
    }
    notifyListeners();
  }

  Profile snapshot(String name, {String? id}) => Profile(
        id: id ?? newProfileId(),
        name: name,
        style: crosshairStyle,
        size: crosshairSize,
        thickness: crosshairThickness,
        gap: crosshairGap,
        opacity: crosshairOpacity,
        color: crosshairColor,
        sensitivity: Map<String, double>.from(sensitivity),
      );

  void _applySensitivity(Profile profile) {
    sensitivity = <String, double>{
      for (final key in kSensitivityKeys) key: profile.sensitivity[key] ?? 70,
    };
  }

  void _applyProfile(Profile profile) {
    profileValues['crosshair_style'] = profile.style.label;
    profileValues['crosshair_size'] = profile.size;
    profileValues['crosshair_thickness'] = profile.thickness;
    profileValues['crosshair_gap'] = profile.gap;
    profileValues['crosshair_opacity'] = profile.opacity;
    String? colorName;
    for (final entry in trainingOverlayColors.entries) {
      if (entry.value == profile.color.toARGB32()) {
        colorName = entry.key;
        break;
      }
    }
    if (colorName != null) profileValues['crosshair_color'] = colorName;
    _applySensitivity(profile);
  }

  void applyProfile(Profile profile) {
    _applyProfile(profile);
    activeProfileId = profile.id;
    notifyListeners();
    _persistProfiles();
  }

  Profile saveAsNewProfile(String name) {
    final profile = snapshot(name);
    profiles.add(profile);
    activeProfileId = profile.id;
    notifyListeners();
    _persistProfiles();
    return profile;
  }

  void updateActiveProfile() {
    final current = activeProfile;
    if (current == null) return;
    final index = profiles.indexOf(current);
    profiles[index] = snapshot(current.name, id: current.id);
    notifyListeners();
    _persistProfiles();
  }

  void renameProfile(Profile profile, String name) {
    profile.name = name;
    notifyListeners();
    _persistProfiles();
  }

  void duplicateProfile(Profile profile) {
    final index = profiles.indexOf(profile);
    profiles.insert(
        index + 1,
        profile.copyWith(
          id: newProfileId(),
          name: '${profile.name} copy',
        ));
    notifyListeners();
    _persistProfiles();
  }

  void deleteProfile(Profile profile) {
    profiles.remove(profile);
    if (activeProfileId == profile.id) {
      activeProfileId = profiles.isEmpty ? null : profiles.first.id;
      if (activeProfile != null) _applyProfile(activeProfile!);
    }
    notifyListeners();
    _persistProfiles();
  }

  void importProfile(Profile profile) {
    profiles.add(profile);
    applyProfile(profile);
  }

  void cycleProfile(int delta) {
    if (profiles.isEmpty) return;
    final current =
        profiles.indexWhere((profile) => profile.id == activeProfileId);
    final next = ((current < 0 ? 0 : current) + delta) % profiles.length;
    applyProfile(profiles[next]);
  }

  List<Profile> _seedProfiles() {
    Profile make(String name, CrosshairStyle style, double size, double thick,
            double gap, Color color, List<double> sens) =>
        Profile(
          id: newProfileId(),
          name: name,
          style: style,
          size: size,
          thickness: thick,
          gap: gap,
          opacity: .9,
          color: color,
          sensitivity: <String, double>{
            for (var i = 0; i < kSensitivityKeys.length; i++)
              kSensitivityKeys[i]: sens[i],
          },
        );
    return <Profile>[
      make('Balanced', CrosshairStyle.cross, 32, 2, 5, const Color(0xFF35D8E6),
          [78, 72, 65, 60, 45, 80]),
      make('Precision', CrosshairStyle.circle, 24, 2, 4,
          const Color(0xFF28D17C), [60, 55, 48, 42, 30, 65]),
      make('Rush', CrosshairStyle.plus, 40, 3, 5, const Color(0xFFFF303E),
          [92, 88, 80, 74, 58, 90]),
    ];
  }

  Future<void> _persistProfiles() async {
    profileValues['saved_profiles'] =
        profiles.map((profile) => profile.toJson()).toList();
    profileValues['active_profile_id'] = activeProfileId;
    await saveProfileValues();
  }

  Future<void> setLanguage(String value) async {
    if (!const <String>{'en', 'pt', 'es', 'ar'}.contains(value)) return;
    languageCode = value;
    notifyListeners();
    await AuraStorage.writeLanguage(value);
  }

  Future<void> completeOnboarding() async {
    onboardingComplete = true;
    notifyListeners();
    await AuraStorage.writeOnboardingComplete(true);
  }

  Future<void> markInitialPaywallSeen() async {
    if (initialPaywallSeen) return;
    initialPaywallSeen = true;
    await AuraStorage.writeInitialPaywallSeen(true);
  }

  void setProEntitled(bool value) {
    if (isPro == value) return;
    isPro = value;
    notifyListeners();
  }

  bool toggle(String id) => toggles[id] ?? false;

  int get selectedSettingsCount =>
      toggles.values.where((enabled) => enabled).length;

  dynamic profileValue(String id) => profileValues[id];

  void updateSensitivityResults(Map<String, int> values, String model) {
    sensitivityResults = Map<String, int>.of(values);
    sensitivityModel = model;
    hasGeneratedSensitivityResults = true;
    notifyListeners();
  }

  void updateProfileValue(String id, dynamic value) {
    profileValues[id] = value;
    notifyListeners();
  }

  void playTrainingFeedback({required bool hit}) {
    if (!trainingProfileActive) return;
    if (toggle('haptics')) {
      unawaited(
          hit ? HapticFeedback.mediumImpact() : HapticFeedback.lightImpact());
    }
    if (toggle('sounds')) {
      unawaited(SystemSound.play(SystemSoundType.click));
    }
  }

  void tap() => playTrainingFeedback(hit: true);

  void setSensitivity(String key, double value) {
    if (!kSensitivityKeys.contains(key)) return;
    sensitivity[key] = value.clamp(0.0, 100.0).toDouble();
    profileValues['aim_sensitivity'] = Map<String, double>.from(sensitivity);
    notifyListeners();
  }

  Future<void> saveProfileValues() =>
      AuraStorage.writeJson(AuraStorage.profileValuesKey, profileValues);

  Future<void> setProfileValue(String id, dynamic value) async {
    updateProfileValue(id, value);
    await saveProfileValues();
  }

  void setTrainingProfileActive(bool enabled) {
    trainingProfileActive = enabled;
    notifyListeners();
  }

  Future<void> setToggle(String id, bool value) async {
    toggles[id] = value;
    notifyListeners();
    await AuraStorage.writeJson(AuraStorage.togglesKey, toggles);
  }

  int get streak => calculateDailyStreak(
        history.map((entry) => DateTime.parse(entry['date'] as String)),
        DateTime.now(),
      );

  int get lessonPercent => completedLessons.isEmpty
      ? 0
      : (completedLessons.length * 100 / 8).round();

  Future<void> recordDrill(String id, int score) async {
    if (score > (bestScores[id] ?? 0)) bestScores[id] = score;
    history.add(<String, dynamic>{
      'drill': id,
      'score': score,
      'date': DateTime.now().toIso8601String(),
    });
    await Future.wait<void>(<Future<void>>[
      AuraStorage.writeJson(AuraStorage.scoresKey, bestScores),
      AuraStorage.writeJson(AuraStorage.historyKey, history),
    ]);
    notifyListeners();
  }

  Future<void> setLessonComplete(String id, bool complete) async {
    if (complete) {
      completedLessons.add(id);
    } else {
      completedLessons.remove(id);
    }
    await AuraStorage.writeLessons(completedLessons);
    notifyListeners();
  }

  Future<void> resetChecklist() async {
    toggles = defaultToggleValues();
    trainingProfileActive = false;
    notifyListeners();
    await AuraStorage.writeJson(AuraStorage.togglesKey, toggles);
  }

  Future<void> resetAll() async {
    final didCompleteOnboarding = onboardingComplete;
    final didSeeInitialPaywall = initialPaywallSeen;
    await AuraStorage.clear();
    await AuraStorage.writeOnboardingComplete(didCompleteOnboarding);
    await AuraStorage.writeInitialPaywallSeen(didSeeInitialPaywall);
    trainingProfileActive = false;
    toggles = defaultToggleValues();
    bestScores = <String, int>{};
    history = <Map<String, dynamic>>[];
    completedLessons = <String>{};
    profileValues = defaultProfileValues();
    profiles = _seedProfiles();
    activeProfileId = profiles.first.id;
    _applyProfile(profiles.first);
    sensitivity = <String, double>{for (final key in kSensitivityKeys) key: 70};
    languageCode = 'en';
    notifyListeners();
  }
}
