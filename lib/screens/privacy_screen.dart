import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme.dart';
import '../localization.dart';
import 'widgets.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(context.tr('Privacy Policy'))),
        body: ListView(padding: const EdgeInsets.all(16), children: <Widget>[
          RedGradientHeader(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Text(context.tr('YOUR PRACTICE STAYS YOURS'),
                    style: TextStyle(
                        fontWeight: FontWeight.w900, letterSpacing: 1)),
                SizedBox(height: 6),
                Text(context.tr('Aura Aim keeps its promises simple.'),
                    style: TextStyle(color: Color(0xFFE9C9CC))),
              ])),
          SizedBox(height: 14),
          AuraCard(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Text(context.tr('Plain-language policy'),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                SizedBox(height: 12),
                Text(
                    context.tr(
                        'Your checklist, lesson progress, drill scores, and history are stored on this device. Sample device and performance values are made up. The app does not read or change game or phone settings.'),
                    style:
                        TextStyle(color: AuraColors.secondary, height: 1.55)),
                const SizedBox(height: 8),
                Text(
                    context.tr(
                        'AppLovin may receive device and ad-interaction data to deliver and measure ads. Your ATT choice controls cross-app tracking on Apple devices. For details about AppLovin’s collection and use of information, visit:'),
                    style: const TextStyle(
                        color: AuraColors.secondary, height: 1.55)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => launchUrl(
                        Uri.parse('https://legal.applovin.com/privacy/')),
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: Text(context.tr('AppLovin Privacy Policy')),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                    context.tr(
                        'If you make an in-app purchase, Apple processes the payment and RevenueCat verifies the purchase entitlement. The app does not receive your payment card details.'),
                    style: const TextStyle(
                        color: AuraColors.secondary, height: 1.55)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => launchUrl(
                        Uri.parse('https://www.revenuecat.com/privacy/')),
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: Text(context.tr('RevenueCat Privacy Policy')),
                  ),
                ),
                SizedBox(height: 14),
                Text(
                    context.tr(
                        'You can reset all saved data at any time from Settings. Resetting removes the app’s locally stored progress and preferences.'),
                    style:
                        TextStyle(color: AuraColors.secondary, height: 1.55)),
              ])),
        ]),
      );
}
