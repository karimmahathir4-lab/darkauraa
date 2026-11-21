import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ads/ad_service.dart';
import '../app_state.dart';
import '../data/toggles.dart';
import '../main.dart' show kStoreUrl;
import 'pro_screen.dart';
import '../theme.dart';
import '../localization.dart';
import 'widgets.dart';

const MethodChannel _homeReviewChannel =
    MethodChannel('com.handcraft.darkaura/review');

class HomeScreen extends StatelessWidget {
  const HomeScreen(
      {required this.state, required this.onActivateTraining, super.key});
  final AppState state;
  final VoidCallback onActivateTraining;

  @override
  Widget build(BuildContext context) => ListView(
        padding: EdgeInsets.fromLTRB(
            16, 8, 16, MediaQuery.viewPaddingOf(context).bottom + 108),
        children: <Widget>[
          _masterToggle(context),
          const SizedBox(height: 14),
          for (final group in toggleGroups) ...<Widget>[
            _group(context, group),
            const SizedBox(height: 12),
          ],
          _rateUsCard(context),
          const SizedBox(height: 14),
        ],
      );

  Widget _rateUsCard(BuildContext context) => AuraCard(
        padding: const EdgeInsets.all(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _openRate(context),
          child: Row(
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0x28E11D2E),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0x66E11D2E)),
                ),
                child: const Icon(
                  Icons.star,
                  color: AuraColors.red,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      context.tr('Rate Our App'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AuraColors.red,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      context.tr('Enjoying Dark Aura? Leave us a 5-star review!'),
                      style: const TextStyle(
                        color: AuraColors.secondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AuraColors.secondary,
                size: 22,
              ),
            ],
          ),
        ),
      );

  Future<void> _openRate(BuildContext context) async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      try {
        final requested =
            await _homeReviewChannel.invokeMethod<bool>('requestReview');
        if (requested == true) return;
      } on PlatformException {
        // Fall back to App Store url
      } on MissingPluginException {
        // Fall back to App Store url
      }
    }

    final uri = Uri.parse('$kStoreUrl?action=write-review');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _masterToggle(BuildContext context) {
    final active = state.trainingProfileActive;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Semantics(
        button: true,
        label: context.tr(
            active ? 'Turn practice profile off' : 'Turn practice profile on'),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(26),
            onTap: () {
              if (active) {
                state.setTrainingProfileActive(false);
              } else if (state.selectedSettingsCount == 0) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text(context.tr('Activate at least one feature')),
                    backgroundColor: AuraColors.red,
                    behavior: SnackBarBehavior.floating,
                  ));
              } else {
                state.setTrainingProfileActive(true);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeInOut,
              height: 104,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: LinearGradient(
                  colors: active
                      ? const <Color>[Color(0xFFE11D2E), Color(0xFF5A0A12)]
                      : const <Color>[Color(0xFF28282B), Color(0xFF151518)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                    color: active
                        ? const Color(0x88E11D2E)
                        : const Color(0x35FFFFFF),
                    width: 1.8),
                boxShadow: active
                    ? const <BoxShadow>[
                        BoxShadow(
                            color: Color(0x55E11D2E),
                            blurRadius: 28,
                            spreadRadius: 2)
                      ]
                    : const <BoxShadow>[],
              ),
              child: Row(children: <Widget>[
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: Icon(
                    active ? Icons.power_settings_new : Icons.bolt,
                    key: ValueKey<bool>(active),
                    color: Colors.white,
                    size: 42,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: Text(
                          active ? 'ON' : 'OFF',
                          key: ValueKey<bool>(active),
                          style: TextStyle(
                              color: active
                                  ? Colors.white
                                  : const Color(0xFFD8D8DB),
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        context.tr(active
                            ? 'Enabled'
                            : 'Tap to enable'),
                        style: const TextStyle(
                            color: Color(0xFFD8D8DB),
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  width: 66,
                  height: 38,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: active
                        ? const Color(0xAAFFFFFF)
                        : const Color(0x44000000),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0x55FFFFFF)),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutBack,
                    alignment:
                        active ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(color: Color(0x44000000), blurRadius: 6)
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
  Widget _group(BuildContext context, ToggleGroup group) {
    final ready = group.items.where((item) => state.toggle(item.id)).length;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          AuraCard(
            padding: const EdgeInsets.fromLTRB(14, 18, 10, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$ready ${context.tr('of')} ${group.items.length} ${context.tr('ready')}',
                    style: const TextStyle(
                        color: AuraColors.secondary, fontSize: 11),
                  ),
                ),
                const SizedBox(height: 6),
                for (final item in group.items)
                  Row(children: <Widget>[
                    Icon(item.icon, color: AuraColors.red, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                        child: InkWell(
                      onTap: () => _showTip(context, item),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(context.tr(item.title),
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                Text(context.tr(item.subtitle),
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: AuraColors.secondary)),
                              ])),
                    )),
                    IconButton(
                        tooltip: context.tr('Setup tip'),
                        onPressed: () => _showTip(context, item),
                        icon: const Icon(Icons.info_outline,
                            size: 18, color: AuraColors.secondary)),
                    if (!state.isPro &&
                        AuraAds.instance.supportsAds &&
                        !proToggleIds.contains(item.id) &&
                        AuraAds.rewardedToggleIds.contains(item.id))
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Tooltip(
                          message: context.tr('Rewarded ad feature'),
                          child: const Icon(Icons.play_circle_outline,
                              size: 17, color: AuraColors.red),
                        ),
                      ),
                    if (proToggleIds.contains(item.id)) ...<Widget>[
                      const SizedBox(width: 3),
                      _ProFeatureBadge(label: context.tr('Pro')),
                      const SizedBox(width: 3),
                    ],
                    Switch(
                        value: state.toggle(item.id),
                        onChanged: (value) =>
                            _changeToggle(context, item, value)),
                  ]),
              ],
            ),
          ),
          Positioned(
            top: -10,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: AuraColors.red,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x66E11D2E),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  context.tr(group.title),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _changeToggle(
      BuildContext context, SetupToggle item, bool enabled) async {
    if (enabled && !state.isPro && proToggleIds.contains(item.id)) {
      await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => ProScreen(state: state),
      ));
      if (!context.mounted || !state.isPro) return;
      await state.setToggle(item.id, true);
      return;
    }
    if (!enabled ||
        state.isPro ||
        !AuraAds.instance.supportsAds ||
        !AuraAds.rewardedToggleIds.contains(item.id)) {
      await state.setToggle(item.id, enabled);
      return;
    }

    AuraAds.instance.pauseInterstitials();
    try {
      final accepted = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(context.tr('Enable with a rewarded ad?')),
          content: Text(context.tr(
              'Watch a short ad to enable this training option. It turns on only after the reward is confirmed.')),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(context.tr('Not now')),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.pop(dialogContext, true),
              icon: const Icon(Icons.play_arrow, size: 18),
              label: Text(context.tr('Watch ad')),
            ),
          ],
        ),
      );
      if (accepted != true || !context.mounted) return;
      final rewarded = await AuraAds.instance.showRewardedForToggle();
      if (!context.mounted) return;
      if (rewarded) {
        await state.setToggle(item.id, true);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('Feature enabled'))),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(context.tr('Ad is not ready. Try again soon.'))),
        );
      }
    } finally {
      AuraAds.instance.resumeInterstitials();
    }
  }

  void _showTip(BuildContext context, SetupToggle item) =>
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: AuraColors.card,
        showDragHandle: true,
        builder: (context) => Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 28),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(context.tr(item.title),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 10),
                Text(context.tr(item.tip),
                    style: const TextStyle(
                        color: AuraColors.secondary, height: 1.5)),
              ]),
        ),
      );
}

class _ProFeatureBadge extends StatelessWidget {
  const _ProFeatureBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          gradient: const LinearGradient(
            colors: <Color>[
              Color(0xFFFFD700), // Vibrant gold/yellow
              AuraColors.red,    // Red
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(1.0), // Gradient border outline
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF140D0E),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            const Icon(Icons.workspace_premium, size: 12, color: Color(0xFFFFD700)),
            const SizedBox(width: 3),
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800)),
          ]),
        ),
      );
}
