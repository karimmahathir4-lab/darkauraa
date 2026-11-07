import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuraStorage {
  AuraStorage._();

  static const String togglesKey = 'aura.toggles';
  static const String scoresKey = 'aura.best_scores';
  static const String historyKey = 'aura.drill_history';
  static const String lessonsKey = 'aura.completed_lessons';
  static const String profileValuesKey = 'aura.profile_values';
  static const String languageKey = 'aura.language_code';
  static const String onboardingKey = 'aura.onboarding_complete';
  static const String initialPaywallKey = 'aura.initial_paywall_seen';

  static Future<bool> readOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(onboardingKey) ?? false;
  }

  static Future<void> writeOnboardingComplete(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(onboardingKey, value);
  }

  static Future<bool> readInitialPaywallSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(initialPaywallKey) ?? false;
  }

  static Future<void> writeInitialPaywallSeen(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(initialPaywallKey, value);
  }

  static Future<String> readLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(languageKey) ?? 'en';
  }

  static Future<void> writeLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(languageKey, language);
  }

  static Future<Map<String, bool>> readToggles() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(togglesKey);
    if (raw == null) return <String, bool>{};
    return (jsonDecode(raw) as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, value as bool),
    );
  }

  static Future<Map<String, int>> readScores() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(scoresKey);
    if (raw == null) return <String, int>{};
    return (jsonDecode(raw) as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, (value as num).toInt()),
    );
  }

  static Future<List<Map<String, dynamic>>> readHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(historyKey);
    if (raw == null) return <Map<String, dynamic>>[];
    return (jsonDecode(raw) as List<dynamic>).cast<Map<String, dynamic>>();
  }

  static Future<Map<String, dynamic>> readProfileValues() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(profileValuesKey);
    if (raw == null) return <String, dynamic>{};
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  }

  static Future<Set<String>> readLessons() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(lessonsKey) ?? <String>[]).toSet();
  }

  static Future<void> writeJson(String key, Object value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(value));
  }

  static Future<void> writeLessons(Set<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(lessonsKey, value.toList());
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
