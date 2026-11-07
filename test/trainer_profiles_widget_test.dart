import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aura_red_aim_panel/app_state.dart';
import 'package:aura_red_aim_panel/screens/profiles_screen.dart';
import 'package:aura_red_aim_panel/screens/trainer_screen.dart';
import 'package:aura_red_aim_panel/trainer_store.dart';
import 'package:aura_red_aim_panel/localization.dart';

Widget testApp(Widget child) => MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      supportedLocales: AuraLocalizations.supportedLocales,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AuraLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(body: child),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<AppState> loadState() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final state = AppState();
    await state.load();
    await trainerStore.load();
    return state;
  }

  testWidgets('Aim Trainer tab builds with its five modes', (tester) async {
    final state = await loadState();
    await tester.pumpWidget(testApp(TrainerScreen(state: state)));
    await tester.pump();

    expect(find.text('Aim Trainer'), findsOneWidget);
    expect(find.text('Classic'), findsOneWidget);
    expect(find.text('Daily'), findsOneWidget);
  });

  testWidgets('Profiles screen loads the three starter loadouts',
      (tester) async {
    final state = await loadState();
    await tester.pumpWidget(testApp(ProfilesScreen(state: state)));
    await tester.pumpAndSettle();

    expect(state.profiles.map((profile) => profile.name),
        containsAll(<String>['Balanced', 'Precision', 'Rush']));
    expect(find.text('Profiles'), findsOneWidget);
    expect(find.text('Balanced'), findsOneWidget);
  });
}
