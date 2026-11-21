import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ads/ad_service.dart';
import '../app_state.dart';
import '../main.dart' show kAppName, kStoreUrl;
import '../theme.dart';
import '../localization.dart';
import 'pro_screen.dart';
import 'privacy_screen.dart';
import 'widgets.dart';

const MethodChannel _reviewChannel =
    MethodChannel('com.handcraft.darkaura/review');

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({required this.state, super.key});
  final AppState state;

  @override
  Widget build(BuildContext context) => _InterstitialPauseScope(
          child: Scaffold(
        appBar: AppBar(title: Text(context.tr('Settings'))),
        body: ListView(padding: const EdgeInsets.all(12), children: <Widget>[
          _appIconCard(context),
          _languageCard(context),
          _tile(
              context,
              state.isPro ? Icons.verified : Icons.block,
              context.tr(state.isPro
                  ? 'Dark Aura Panel Pro Experience Active'
                  : 'Join Dark Aura Panel Pro Experience'),
              context.tr(state.isPro
                  ? 'Your Pro experience is active.'
                  : 'Unlock every feature with a plan that fits you.'),
              state.isPro
                  ? null
                  : () => Navigator.push(
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
        ]),
      ));

  Widget _appIconCard(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: AuraCard(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[
                const Icon(Icons.app_shortcut_outlined,
                    color: AuraColors.red, size: 21),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        context.tr('App Icon'),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        state.isPro
                            ? context.tr('Choose your preferred app icon')
                            : context.tr('Unlock Pro to switch app icons'),
                        style: const TextStyle(
                            color: AuraColors.secondary, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                if (!state.isPro)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0x28E11D2E),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0x66E11D2E)),
                    ),
                    child: Text(
                      context.tr('PRO'),
                      style: const TextStyle(
                        color: AuraColors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
              ]),
              const SizedBox(height: 14),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _iconOptionTile(
                      context: context,
                      title: context.tr('Original Icon'),
                      assetPath: 'assets/aura_red_icon.png',
                      iconKey: 'default',
                      selected: state.currentAppIcon == 'default',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _iconOptionTile(
                      context: context,
                      title: context.tr('Pro Rabbit Icon'),
                      assetPath: 'assets/pro_rabbit_icon.png',
                      iconKey: 'ProIcon',
                      selected: state.currentAppIcon == 'ProIcon',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _iconOptionTile({
    required BuildContext context,
    required String title,
    required String assetPath,
    required String iconKey,
    required bool selected,
  }) =>
      InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          if (!state.isPro && iconKey != 'default') {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => ProScreen(state: state),
              ),
            );
            return;
          }
          final changed = await state.setAppIcon(iconKey);
          if (!changed && context.mounted) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(context.tr('Could not change app icon')),
                behavior: SnackBarBehavior.floating,
              ));
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: selected ? const Color(0x28E11D2E) : const Color(0x111E1E24),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AuraColors.red : const Color(0x22FFFFFF),
              width: selected ? 1.8 : 1,
            ),
          ),
          child: Column(
            children: <Widget>[
              Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      assetPath,
                      width: 54,
                      height: 54,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (selected)
                    Positioned(
                      right: -4,
                      bottom: -4,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AuraColors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check,
                            size: 13, color: Colors.white),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? Colors.white : const Color(0xFFD0D0D5),
                ),
              ),
            ],
          ),
        ),
      );

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
          String subtitle, VoidCallback? onTap) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: AuraCard(
          padding: EdgeInsets.zero,
          child: ListTile(
            leading: Icon(icon, color: AuraColors.red),
            title: Text(title),
            subtitle: Text(subtitle),
            trailing: onTap == null
                ? const Icon(Icons.check_circle, color: AuraColors.red)
                : const Icon(Icons.chevron_right),
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
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      try {
        final requested =
            await _reviewChannel.invokeMethod<bool>('requestReview');
        if (requested == true) return;
      } on PlatformException {
        // Fall back to the App Store listing when native review isn't available.
      } on MissingPluginException {
        // Fall back to the App Store listing when native review isn't available.
      }
    }

    final uri = Uri.parse('$kStoreUrl?action=write-review');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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
