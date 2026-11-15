import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_state.dart';
import '../localization.dart';
import '../purchases/pro_service.dart';
import '../theme.dart';

class ProScreen extends StatefulWidget {
  const ProScreen({required this.state, super.key});
  final AppState state;

  @override
  State<ProScreen> createState() => _ProScreenState();
}

class _ProScreenState extends State<ProScreen> {
  bool _busy = false;
  bool _loadingPrice = true;
  String? _price;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    if (mounted) {
      setState(() => _loadingPrice = true);
    }
    await AuraProService.instance.initialize(widget.state);
    final product = await AuraProService.instance.loadProduct();
    if (!mounted) return;
    setState(() {
      _price = product?.priceString;
      _loadingPrice = false;
    });
  }

  Future<void> _buy() => _run(AuraProService.instance.purchase,
      successMessage: 'Ads removed. Pro is active.');

  Future<void> _restore() => _run(AuraProService.instance.restore,
      successMessage: 'Purchases restored.');

  Future<void> _openUrl(String value) async {
    await launchUrl(Uri.parse(value), mode: LaunchMode.externalApplication);
  }

  Future<void> _run(Future<void> Function() action,
      {required String successMessage}) async {
    setState(() => _busy = true);
    String? error;
    bool cancelled = false;
    try {
      await action();
    } on PlatformException catch (exception) {
      cancelled = PurchasesErrorHelper.getErrorCode(exception) ==
          PurchasesErrorCode.purchaseCancelledError;
      if (!cancelled) error = 'Store unavailable. Please try again later.';
    } catch (_) {
      error = 'Store unavailable. Please try again later.';
    }
    if (!mounted) return;
    setState(() => _busy = false);
    if (cancelled) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(context.tr(error ??
          (widget.state.isPro ? successMessage : 'No active purchase found.'))),
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.tr('Ad-free experience')),
          automaticallyImplyLeading: false,
          leading: IconButton(
            tooltip: context.tr('Close'),
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            const SizedBox(height: 26),
            Center(
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: const Color(0x1FE11D2E),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0x55E11D2E)),
                ),
                child: const Icon(Icons.block, color: AuraColors.red, size: 42),
              ),
            ),
            const SizedBox(height: 22),
            Text(context.tr('Join ad free experience'),
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
            const SizedBox(height: 9),
            Text(
              context.tr(
                  'Train with fewer interruptions and keep your focus on practice.'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AuraColors.secondary, height: 1.5),
            ),
            const SizedBox(height: 28),
            _planComparison(context),
            const SizedBox(height: 22),
            if (_loadingPrice)
              const SizedBox.square(
                dimension: 30,
                child: Center(
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AuraColors.red),
                ),
              )
            else
              Text(
                _price ?? context.tr('Price unavailable'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1),
              ),
            const SizedBox(height: 5),
            Text(
              widget.state.isPro
                  ? context.tr('Pro is active')
                  : context.tr('One-time purchase'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AuraColors.secondary, fontSize: 13),
            ),
            if (!_loadingPrice && _price == null)
              TextButton(
                onPressed: _loadProduct,
                child: Text(context.tr('Try again')),
              ),
            const SizedBox(height: 20),
            if (!widget.state.isPro)
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _busy || _loadingPrice ? null : _buy,
                  child: _busy
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(context.tr('Continue')),
                ),
              ),
            TextButton(
              onPressed: _busy ? null : _restore,
              child: Text(context.tr('Restore purchases')),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: () => _openUrl(
                      'https://handcraft-studios.blogspot.com/p/privacy-policy.html'),
                  child: Text(context.tr('Privacy Policy')),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => _openUrl(
                      'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/'),
                  child: Text(context.tr('Terms of Use')),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              context.tr(
                  'Payment is handled securely by Apple. This is a one-time in-app purchase, not a subscription.'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AuraColors.secondary, fontSize: 12),
            ),
          ],
        ),
      );

  Widget _planComparison(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AuraColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AuraColors.redBorder),
        ),
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            Expanded(
              flex: 5,
              child: Text(context.tr('Compare plans'),
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
            ),
            Expanded(
                flex: 2,
                child: Text(context.tr('Free'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: AuraColors.secondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700))),
            Expanded(
                flex: 2,
                child: Text(context.tr('Pro'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: AuraColors.red,
                        fontSize: 11,
                        fontWeight: FontWeight.w800))),
          ]),
          const Divider(height: 18, color: Color(0x2FFFFFFF)),
          _comparisonRow(context, 'Ad-free experience', 'With ads'),
          _comparisonRow(context, 'All Pro features', 'Some locked'),
          _comparisonRow(context, 'Edit Profiles', 'View & switch'),
          _comparisonRow(context, 'Drill time', 'Up to 60 sec',
              proValue: 'Unlimited'),
        ]),
      );

  Widget _comparisonRow(BuildContext context, String feature, String freeValue,
          {String proValue = 'Included'}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(children: <Widget>[
          Expanded(
            flex: 5,
            child:
                Text(context.tr(feature), style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            flex: 2,
            child: Text(context.tr(freeValue),
                textAlign: TextAlign.center,
                style:
                    const TextStyle(color: AuraColors.secondary, fontSize: 10)),
          ),
          Expanded(
            flex: 2,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.workspace_premium,
                      color: AuraColors.red, size: 13),
                  const SizedBox(width: 3),
                  Flexible(
                    child: Text(context.tr(proValue),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600)),
                  ),
                ]),
          ),
        ]),
      );
}
