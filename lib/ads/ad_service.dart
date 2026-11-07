import 'dart:async';

import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// AppLovin configuration supplied for the iOS app in the MAX dashboard.
class AuraAds {
  AuraAds._();

  static final AuraAds instance = AuraAds._();

  static const String sdkKey =
      '8RHCMxxZPei--AGwtM3E6OEev0RW51t-s1RrGEr0puTkrPT7XC7AEHoaUa2FCmJ3PTAJSVW2AeHBgIoA4MpNS-';
  static const String interstitialUnitId = '8219c18d887b7873';
  static const String rewardedUnitId = '8e6076993babb48f';

  static const Set<String> rewardedToggleIds = <String>{
    'crosshair',
    'aim_lock',
    'fps_live',
    'ram_live',
    'ping_live',
    'hit_markers',
  };

  bool _initialized = false;
  bool _adsDisabled = false;
  bool _initializing = false;
  int _tapCount = 0;
  int _interstitialRetry = 0;
  int _rewardedRetry = 0;
  int _pauseDepth = 0;
  Timer? _interstitialRetryTimer;
  Timer? _rewardedRetryTimer;
  Completer<bool>? _rewardResult;
  final Map<int, _TapStart> _pointerStarts = <int, _TapStart>{};

  bool get supportsAds => defaultTargetPlatform == TargetPlatform.iOS;
  bool get isInitialized => _initialized;

  void setAdsDisabled(bool disabled) => _adsDisabled = disabled;

  Future<void> initialize() async {
    if (!supportsAds || _initialized || _initializing) return;
    _initializing = true;
    AppLovinMAX.setInterstitialListener(InterstitialListener(
      onAdLoadedCallback: (_) => _interstitialRetry = 0,
      onAdLoadFailedCallback: (adUnitId, _) => _retryInterstitial(adUnitId),
      onAdDisplayedCallback: (_) {},
      onAdDisplayFailedCallback: (_, __) {
        _interstitialRetryTimer?.cancel();
        AppLovinMAX.loadInterstitial(interstitialUnitId);
      },
      onAdClickedCallback: (_) {},
      onAdHiddenCallback: (_) =>
          AppLovinMAX.loadInterstitial(interstitialUnitId),
    ));
    AppLovinMAX.setRewardedAdListener(RewardedAdListener(
      onAdLoadedCallback: (_) => _rewardedRetry = 0,
      onAdLoadFailedCallback: (adUnitId, _) => _retryRewarded(adUnitId),
      onAdDisplayedCallback: (_) {},
      onAdDisplayFailedCallback: (_, __) => _finishReward(false),
      onAdClickedCallback: (_) {},
      onAdReceivedRewardCallback: (_, __) => _finishReward(true),
      onAdHiddenCallback: (_) {
        _finishReward(false);
        AppLovinMAX.loadRewardedAd(rewardedUnitId);
      },
    ));

    try {
      final configuration = await AppLovinMAX.initialize(sdkKey);
      if (configuration == null) return;
      _initialized = true;
      AppLovinMAX.loadInterstitial(interstitialUnitId);
      AppLovinMAX.loadRewardedAd(rewardedUnitId);
    } catch (_) {
      // A network or SDK failure should not prevent the app from opening.
      _initialized = false;
    } finally {
      _initializing = false;
    }
  }

  void pauseInterstitials() => _pauseDepth++;

  void resumeInterstitials() {
    if (_pauseDepth > 0) _pauseDepth--;
  }

  void pointerDown(PointerDownEvent event) {
    _pointerStarts[event.pointer] = _TapStart(
      event.position,
      event.timeStamp,
      _pauseDepth == 0 && _initialized,
    );
  }

  void pointerUp(PointerUpEvent event) {
    final start = _pointerStarts.remove(event.pointer);
    if (_adsDisabled || start == null || !start.canCount || _pauseDepth > 0) {
      return;
    }
    if ((event.position - start.position).distance > 14) return;
    if (event.timeStamp - start.timeStamp > const Duration(milliseconds: 700)) {
      return;
    }
    _tapCount++;
    if (_tapCount >= 4) {
      _tapCount = 0;
      unawaited(_showInterstitialIfReady());
    }
  }

  void pointerCancel(PointerCancelEvent event) {
    _pointerStarts.remove(event.pointer);
  }

  Future<bool> showRewardedForToggle() async {
    if (!_initialized || _adsDisabled) return false;
    final ready = await AppLovinMAX.isRewardedAdReady(rewardedUnitId);
    if (ready != true || _rewardResult != null) return false;

    final result = Completer<bool>();
    _rewardResult = result;
    try {
      AppLovinMAX.showRewardedAd(rewardedUnitId);
      return await result.future.timeout(const Duration(minutes: 3));
    } on TimeoutException {
      return false;
    } catch (_) {
      return false;
    } finally {
      if (identical(_rewardResult, result)) _rewardResult = null;
    }
  }

  Future<void> _showInterstitialIfReady() async {
    if (!_initialized || _adsDisabled || _pauseDepth > 0) return;
    try {
      final ready = await AppLovinMAX.isInterstitialReady(interstitialUnitId);
      if (ready == true && _pauseDepth == 0) {
        AppLovinMAX.showInterstitial(interstitialUnitId);
      }
    } catch (_) {
      // Do not interrupt an app interaction if the ad SDK is unavailable.
    }
  }

  void _retryInterstitial(String adUnitId) {
    _interstitialRetry++;
    _interstitialRetryTimer?.cancel();
    final seconds = 1 << _interstitialRetry.clamp(1, 6).toInt();
    _interstitialRetryTimer = Timer(Duration(seconds: seconds),
        () => AppLovinMAX.loadInterstitial(adUnitId));
  }

  void _retryRewarded(String adUnitId) {
    _rewardedRetry++;
    _rewardedRetryTimer?.cancel();
    final seconds = 1 << _rewardedRetry.clamp(1, 6).toInt();
    _rewardedRetryTimer = Timer(
        Duration(seconds: seconds), () => AppLovinMAX.loadRewardedAd(adUnitId));
  }

  void _finishReward(bool rewarded) {
    final result = _rewardResult;
    if (result != null && !result.isCompleted) result.complete(rewarded);
  }
}

class _TapStart {
  const _TapStart(this.position, this.timeStamp, this.canCount);
  final Offset position;
  final Duration timeStamp;
  final bool canCount;
}

class AdsExcludedTapArea extends StatelessWidget {
  const AdsExcludedTapArea({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => AuraAds.instance.pauseInterstitials(),
        onPointerUp: (_) => AuraAds.instance.resumeInterstitials(),
        onPointerCancel: (_) => AuraAds.instance.resumeInterstitials(),
        child: child,
      );
}
