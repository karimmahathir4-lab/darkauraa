import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aura_red_aim_panel/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('enabled training feedback sends haptics and system click', () async {
    final state = AppState()
      ..toggles['haptics'] = true
      ..toggles['sounds'] = true
      ..setTrainingProfileActive(true);
    final calls = <MethodCall>[];
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      calls.add(call);
      return null;
    });
    addTearDown(() =>
        messenger.setMockMethodCallHandler(SystemChannels.platform, null));

    state.playTrainingFeedback(hit: true);
    await Future<void>.delayed(Duration.zero);
    expect(calls, hasLength(2));
    expect(
      calls.any((call) =>
          call.method == 'HapticFeedback.vibrate' &&
          call.arguments == 'HapticFeedbackType.mediumImpact'),
      isTrue,
    );
    expect(
      calls.any((call) =>
          call.method == 'SystemSound.play' &&
          call.arguments == 'SystemSoundType.click'),
      isTrue,
    );

    calls.clear();
    state.playTrainingFeedback(hit: false);
    await Future<void>.delayed(Duration.zero);
    expect(
      calls.any((call) =>
          call.method == 'HapticFeedback.vibrate' &&
          call.arguments == 'HapticFeedbackType.lightImpact'),
      isTrue,
    );
  });

  test('feedback stays disabled unless the practice profile is active',
      () async {
    final state = AppState()
      ..toggles['haptics'] = true
      ..toggles['sounds'] = true;
    final calls = <MethodCall>[];
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      calls.add(call);
      return null;
    });
    addTearDown(() =>
        messenger.setMockMethodCallHandler(SystemChannels.platform, null));

    state.playTrainingFeedback(hit: true);
    await Future<void>.delayed(Duration.zero);

    expect(calls, isEmpty);
  });
}
