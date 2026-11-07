import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../ads/ad_service.dart';
import '../app_state.dart';

/// RevenueCat configuration for the iOS App Store product.
class AuraProService {
  AuraProService._();

  static final AuraProService instance = AuraProService._();
  static const String _testStoreSdkKey = 'test_nRLPepttlabiiqMpAdpIkWqAAdD';
  static const String _appStoreSdkKey = 'appl_xMtGSCKeaODGxRadNfkAMXwjZhT';
  static const String productId = 'removeads_2_99';
  static const String entitlementId = 'dark_aura_aim_panel_pro';

  AppState? _state;
  bool _configured = false;
  StoreProduct? _product;
  Future<void>? _initializing;

  bool get supportsPurchases => defaultTargetPlatform == TargetPlatform.iOS;
  String get sdkKey => kDebugMode ? _testStoreSdkKey : _appStoreSdkKey;
  StoreProduct? get product => _product;

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

  Future<StoreProduct?> loadProduct() async {
    if (!supportsPurchases || !_configured) {
      if (kDebugMode) {
        debugPrint('RevenueCat is not configured for this platform yet.');
      }
      return null;
    }
    try {
      final offerings = await Purchases.getOfferings();
      for (final offering in offerings.all.values) {
        for (final package in offering.availablePackages) {
          if (package.storeProduct.identifier == productId) {
            _product = package.storeProduct;
            return _product;
          }
        }
      }

      final products = await Purchases.getProducts(
        <String>[productId],
        productCategory: ProductCategory.nonSubscription,
      );
      _product = products
          .where((product) => product.identifier == productId)
          .firstOrNull;
      return _product;
    } catch (error) {
      if (kDebugMode) {
        debugPrint('RevenueCat product lookup failed: $error');
      }
      return null;
    }
  }

  Future<void> purchase() async {
    final item = _product ?? await loadProduct();
    if (item == null) throw StateError('The product is not available yet.');
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
