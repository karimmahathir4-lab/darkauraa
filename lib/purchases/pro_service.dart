import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../ads/ad_service.dart';
import '../app_state.dart';

/// RevenueCat configuration for the iOS App Store products.
class AuraProService {
  AuraProService._();

  static final AuraProService instance = AuraProService._();
  static const String _testStoreSdkKey = 'test_nRLPepttlabiiqMpAdpIkWqAAdD';
  static const String _appStoreSdkKey = 'appl_xMtGSCKeaODGxRadNfkAMXwjZhT';
  
  static const String monthlyProductId = 'darkaura_0_99';
  static const String lifetimeProductId = 'lifetime_dark_7_99';
  static const String legacyProductId = 'removeads_2_99';
  static const String entitlementId = 'dark_aura_aim_panel_pro';

  AppState? _state;
  bool _configured = false;
  StoreProduct? _monthlyProduct;
  StoreProduct? _lifetimeProduct;
  Package? _monthlyPackage;
  Package? _lifetimePackage;
  Future<void>? _initializing;

  bool get supportsPurchases => defaultTargetPlatform == TargetPlatform.iOS;
  String get sdkKey => kDebugMode ? _testStoreSdkKey : _appStoreSdkKey;
  StoreProduct? get monthlyProduct => _monthlyProduct;
  StoreProduct? get lifetimeProduct => _lifetimeProduct;

  Future<void> initialize(AppState state) {
    _state = state;
    if (!supportsPurchases || _configured) return Future<void>.value();
    return _initializing ??= _configure();
  }

  Future<void> _configure() async {
    try {
      if (kDebugMode) {
        await Purchases.setLogLevel(LogLevel.debug);
      }
      await Purchases.configure(PurchasesConfiguration(sdkKey));
      _configured = true;
      Purchases.addCustomerInfoUpdateListener(_applyCustomerInfo);
      _applyCustomerInfo(await Purchases.getCustomerInfo());
    } catch (error) {
      if (kDebugMode) {
        debugPrint('RevenueCat configuration failed: $error');
      }
    } finally {
      _initializing = null;
    }
  }

  Future<Map<String, StoreProduct>> loadProducts() async {
    if (!supportsPurchases || !_configured) {
      if (kDebugMode) {
        debugPrint('RevenueCat is not configured for this platform yet.');
      }
      return <String, StoreProduct>{};
    }
    try {
      final offerings = await Purchases.getOfferings();
      for (final offering in offerings.all.values) {
        for (final package in offering.availablePackages) {
          if (package.storeProduct.identifier == monthlyProductId) {
            _monthlyProduct = package.storeProduct;
            _monthlyPackage = package;
          } else if (package.storeProduct.identifier == lifetimeProductId) {
            _lifetimeProduct = package.storeProduct;
            _lifetimePackage = package;
          }
        }
      }

      final neededIds = <String>[];
      if (_monthlyProduct == null) neededIds.add(monthlyProductId);
      if (_lifetimeProduct == null) neededIds.add(lifetimeProductId);

      if (neededIds.isNotEmpty) {
        try {
          final products = await Purchases.getProducts(neededIds);
          for (final p in products) {
            if (p.identifier == monthlyProductId) {
              _monthlyProduct = p;
            } else if (p.identifier == lifetimeProductId) {
              _lifetimeProduct = p;
            }
          }
        } catch (_) {}
      }

      final res = <String, StoreProduct>{};
      if (_monthlyProduct != null) res[monthlyProductId] = _monthlyProduct!;
      if (_lifetimeProduct != null) res[lifetimeProductId] = _lifetimeProduct!;
      return res;
    } catch (error) {
      if (kDebugMode) {
        debugPrint('RevenueCat product lookup failed: $error');
      }
      return <String, StoreProduct>{};
    }
  }

  Future<void> purchaseMonthly() async {
    if (_monthlyPackage != null) {
      final result = await Purchases.purchase(PurchaseParams.package(_monthlyPackage!));
      _applyCustomerInfo(result.customerInfo);
      return;
    }
    final item = _monthlyProduct ?? (await loadProducts())[monthlyProductId];
    if (item == null) throw StateError('The monthly offer is not available yet.');
    final result = await Purchases.purchase(PurchaseParams.storeProduct(item));
    _applyCustomerInfo(result.customerInfo);
  }

  Future<void> purchaseLifetime() async {
    if (_lifetimePackage != null) {
      final result = await Purchases.purchase(PurchaseParams.package(_lifetimePackage!));
      _applyCustomerInfo(result.customerInfo);
      return;
    }
    final item = _lifetimeProduct ?? (await loadProducts())[lifetimeProductId];
    if (item == null) throw StateError('The lifetime offer is not available yet.');
    final result = await Purchases.purchase(PurchaseParams.storeProduct(item));
    _applyCustomerInfo(result.customerInfo);
  }

  Future<void> restore() async {
    if (!_configured) throw StateError('Purchases are not available.');
    _applyCustomerInfo(await Purchases.restorePurchases());
  }

  void _applyCustomerInfo(CustomerInfo info) {
    final active = info.entitlements.active.containsKey(entitlementId);
    _state?.setProEntitled(active);
    AuraAds.instance.setAdsDisabled(active);
  }
}
