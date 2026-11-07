import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ads/ad_service.dart';
import '../app_state.dart';
import '../trainer_store.dart';
import '../main.dart' show kAppName, kStoreUrl;
import '../theme.dart';
import '../localization.dart';
import 'pro_screen.dart';
import 'privacy_screen.dart';
import 'widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({required this.state, super.key});
  final AppState state;

  @override
  Widget build(BuildContext context) => _InterstitialPauseScope(
          child: Scaffold(
        appBar: AppBar(title: Text(context.tr('Settings'))),
        body: ListView(padding: const EdgeInsets.all(12), children: <Widget>[
          _languageCard(context),
          _tile(
              context,
              Icons.block,
              context.tr('Join ad free experience'),
              context.tr('Remove ads from the app with a one-time purchase'),
              () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (_) => ProScreen(state: state)))),
          _tile(
              context,
              Icons.privacy_tip_outlined,
              context.tr('Privacy Policy'),
              context.tr('How your local app data is handled'),
              () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (_) => const PrivacyScreen()))),
          _tile(context, Icons.share_outlined, context.tr('Share App'),
              context.tr('Tell someone about Aura Aim'), () => _share(context)),
          _tile(context, Icons.star_outline, context.tr('Rate App'),
              context.tr('Open the app store page'), _rate),
          _tile(
              context,
              Icons.delete_outline,
              context.tr('Reset all progress'),
              context.tr('Clear scores, lessons, streaks, and toggles'),
              () => _reset(context)),
          _tile(context, Icons.delete_sweep_outlined, 'Clear trainer stats',
              'Remove Aim Trainer history, bests, and achievements', () {
            trainerStore.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Trainer stats cleared.')),
            );
          }),
        ]),
      ));

  Widget _languageCard(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: AuraCard(
          padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.translate, color: AuraColors.red),
                  title: Text(context.tr('Language')),
                  subtitle: Text(context
                      .tr('Choose the language used throughout the app')),
                ),
                for (final option in const <(String, String, String)>[
                  ('en', '🇺🇸', 'English (US)'),
                  ('pt', '🇧🇷', 'Português (Brasil)'),
                  ('es', '🇪🇸', 'Español (España)'),
                  ('ar', '🇸🇦', 'العربية (السعودية)'),
                ])
                  ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.only(left: 4, right: 8),
                    leading:
                        Text(option.$2, style: const TextStyle(fontSize: 20)),
                    title:
                        Text(option.$3, style: const TextStyle(fontSize: 13)),
                    trailing: state.languageCode == option.$1
                        ? const Icon(Icons.check_circle,
                            color: AuraColors.red, size: 19)
                        : const SizedBox(width: 19),
                    onTap: () => state.setLanguage(option.$1),
                  ),
              ]),
        ),
      );

  Widget _tile(BuildContext context, IconData icon, String title,
          String subtitle, VoidCallback onTap) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: AuraCard(
          padding: EdgeInsets.zero,
          child: ListTile(
            leading: Icon(icon, color: AuraColors.red),
            title: Text(title),
            subtitle: Text(subtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: onTap,
          ),
        ),
      );

  Future<void> _share(BuildContext context) async {
    final renderObject = context.findRenderObject();
    final sharePositionOrigin = renderObject is RenderBox
        ? renderObject.localToGlobal(Offset.zero) & renderObject.size
        : null;
    await Share.share(
      '$kAppName — build a steady practice routine. $kStoreUrl',
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  Future<void> _rate() async {
    final uri = Uri.parse(kStoreUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _reset(BuildContext context) async {
    final accepted = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(context.tr('Reset all progress?')),
              content: const Text(
                  'This clears your drill scores and history, lesson completion, and setup checklist.'),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(context.tr('Cancel'))),
                FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(context.tr('Reset everything'))),
              ],
            ));
    if (accepted != true) return;
    await state.resetAll();
    trainerStore.clear();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('All progress cleared'))));
  }
}

class _InterstitialPauseScope extends StatefulWidget {
  const _InterstitialPauseScope({required this.child});
  final Widget child;

  @override
  State<_InterstitialPauseScope> createState() =>
      _InterstitialPauseScopeState();
}

class _InterstitialPauseScopeState extends State<_InterstitialPauseScope> {
  @override
  void initState() {
    super.initState();
    AuraAds.instance.pauseInterstitials();
  }

  @override
  void dispose() {
    AuraAds.instance.resumeInterstitials();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
