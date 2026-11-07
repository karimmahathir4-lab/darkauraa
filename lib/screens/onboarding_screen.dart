import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../ads/ad_service.dart';
import '../app_state.dart';
import '../localization.dart';
import '../purchases/pro_service.dart';
import '../theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({required this.state, super.key});
  final AppState state;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pages = PageController();
  int _page = 0;
  bool _working = false;

  bool get _isApplePlatform => defaultTargetPlatform == TargetPlatform.iOS;

  static const List<(IconData, String, String)> _slides =
      <(IconData, String, String)>[
    (
      Icons.bolt,
      'Practice with purpose',
      'Build steadier aim with short drills, progress tracking, and practical lessons.'
    ),
    (
      Icons.tune,
      'Your setup stays yours',
      'Checklist choices stay in this app. Nothing in your game or phone is changed.'
    ),
    (
      Icons.privacy_tip_outlined,
      'Ads and your choice',
      'Dark Aura uses AppLovin to show ads. If you allow tracking, its ad partners may use identifiers to measure ads and make them more relevant. Ads may still appear if you decline.'
    ),
  ];

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  Future<void> _finish({required bool requestTracking}) async {
    if (_working) return;
    setState(() => _working = true);
    if (requestTracking && _isApplePlatform) {
      try {
        final status =
            await AppTrackingTransparency.trackingAuthorizationStatus;
        if (status == TrackingStatus.notDetermined) {
          await AppTrackingTransparency.requestTrackingAuthorization();
        }
      } catch (_) {
        // ATT is optional; continue to the app if the system request fails.
      }
    }
    await widget.state.completeOnboarding();
    await AuraProService.instance.initialize(widget.state);
    unawaited(AuraAds.instance.initialize());
  }

  void _next() {
    if (_page < _slides.length - 1) {
      _pages.nextPage(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic);
    } else {
      _finish(requestTracking: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final last = _page == _slides.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(Icons.bolt, color: AuraColors.red, size: 22),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text('DARK AURA',
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.3,
                            fontSize: 13)),
                  ),
                  TextButton(
                    onPressed:
                        _working ? null : () => _finish(requestTracking: false),
                    child: Text(context.tr('Skip')),
                  ),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pages,
                  itemCount: _slides.length,
                  onPageChanged: (index) => setState(() => _page = index),
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    final adsSlide = index == _slides.length - 1;
                    final title = adsSlide && !_isApplePlatform
                        ? 'Privacy and control'
                        : slide.$2;
                    final description = adsSlide && !_isApplePlatform
                        ? 'Your progress stays on this device. Nothing in your game or phone is changed.'
                        : slide.$3;
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 78,
                            height: 78,
                            decoration: BoxDecoration(
                              color: const Color(0x22E11D2E),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: AuraColors.redBorder),
                            ),
                            child:
                                Icon(slide.$1, color: AuraColors.red, size: 38),
                          ),
                          const SizedBox(height: 30),
                          Text(context.tr(title),
                              style: const TextStyle(
                                  fontSize: 30,
                                  height: 1.12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -.6)),
                          const SizedBox(height: 14),
                          Text(
                            context.tr(description),
                            style: const TextStyle(
                                fontSize: 15,
                                height: 1.55,
                                color: AuraColors.secondary),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: <Widget>[
                  for (var index = 0; index < _slides.length; index++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 7),
                      width: _page == index ? 22 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: _page == index
                            ? AuraColors.red
                            : const Color(0xFF45454A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  const Spacer(),
                  Text('${_page + 1} / ${_slides.length}',
                      style: const TextStyle(
                          color: AuraColors.secondary, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _working ? null : _next,
                  child: _working
                      ? const SizedBox.square(
                          dimension: 19,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(context.tr(last ? 'Continue' : 'Next')),
                ),
              ),
              if (last && _isApplePlatform) ...<Widget>[
                const SizedBox(height: 7),
                TextButton(
                  onPressed:
                      _working ? null : () => _finish(requestTracking: false),
                  child: Text(context.tr('Continue without tracking')),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
