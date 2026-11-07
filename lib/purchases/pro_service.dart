import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../ads/ad_service.dart';
import '../app_state.dart';

/// RevenueCat configuration for the iOS App Store product.
class AuraProService {
  AuraProService._();

  static final AuraProService instance = AuraProService._();
  static const String sdkKey = 'appl_xMtGSCKeaODGxRadNfkAMXwjZhT';
  static const String productId = 'removeads_2_99';
  static const String entitlementId = 'dark_aura_aim_panel_pro';

  AppState? _state;
  bool _configured = false;
  StoreProduct? _product;
  Future<void>? _initializing;

  bool get supportsPurchases => defaultTargetPlatform == TargetPlatform.iOS;
  StoreProduct? get product => _product;

  Future<void> initialize(AppState state) {
    _state = state;
    if (!supportsPurchases || _configured) return Future<void>.value();
    return _initializing ??= _configure();
  }

  Future<void> _configure() async {
    try {
      await Purchases.configure(PurchasesConfiguration(sdkKey));
      _configured = true;
      Purchases.addCustomerInfoUpdateListener(_applyCustomerInfo);
      _applyCustomerInfo(await Purchases.getCustomerInfo());
    } catch (_) {
      // Store configuration failures should not prevent the app from opening.
    } finally {
      _initializing = null;
    }
  }

  Future<StoreProduct?> loadProduct() async {
    if (!supportsPurchases || !_configured) return null;
    try {
      final products = await Purchases.getProducts(
        <String>[productId],
        productCategory: ProductCategory.nonSubscription,
      );
      _product = products
          .where((product) => product.identifier == productId)
          .firstOrNull;
      return _product;
    } catch (_) {
      return null;
    }
  }

  Future<void> purchase() async {
    final item = _product ?? await loadProduct();
    if (item == null) throw StateError('The product is not available yet.');
    _applyCustomerInfo(await Purchases.purchaseStoreProduct(item));
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
