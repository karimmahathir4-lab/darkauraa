import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_state.dart';
import '../localization.dart';
import '../purchases/pro_service.dart';
import '../theme.dart';

enum PaywallPlan { monthly, lifetime }

class ProScreen extends StatefulWidget {
  const ProScreen({required this.state, super.key});
  final AppState state;

  @override
  State<ProScreen> createState() => _ProScreenState();
}

class _ProScreenState extends State<ProScreen> {
  PaywallPlan _selectedPlan = PaywallPlan.monthly;
  bool _busy = false;
  bool _loading = true;
  String _monthlyPrice = '\$0.99';
  String _lifetimePrice = '\$7.99';
  String? _monthlyTitle;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _loading = true);
    await AuraProService.instance.initialize(widget.state);
    final products = await AuraProService.instance.loadProducts();
    if (!mounted) return;

    final monthly = products[AuraProService.monthlyProductId] ??
        AuraProService.instance.monthlyProduct;
    final lifetime = products[AuraProService.lifetimeProductId] ??
        AuraProService.instance.lifetimeProduct;

    setState(() {
      if (monthly != null) {
        _monthlyPrice = monthly.priceString;
        _monthlyTitle = monthly.title;
      }
      if (lifetime != null) {
        _lifetimePrice = lifetime.priceString;
      }
      _loading = false;
    });
  }

  Future<void> _buy() async {
    if (_selectedPlan == PaywallPlan.monthly) {
      await _run(AuraProService.instance.purchaseMonthly,
          successMessage: 'Monthly subscription activated! Pro is active.');
    } else {
      await _run(AuraProService.instance.purchaseLifetime,
          successMessage: 'Lifetime access activated! Pro is active.');
    }
  }

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
    if (widget.state.isPro) {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom;
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D10),
      body: Stack(
        children: <Widget>[
          // Background ambient gradient glow
          Positioned(
            top: -60,
            left: 0,
            right: 0,
            height: 380,
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 0.9,
                  colors: <Color>[
                    Color(0x35E11D2E),
                    Color(0x155A0A12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: <Widget>[
                // Header bar with close button
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        tooltip: context.tr('Close'),
                        icon: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0x3326262B),
                          ),
                          child: const Icon(Icons.close,
                              color: Colors.white70, size: 18),
                        ),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    children: <Widget>[
                      // Hero Icon badge
                      Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: <Widget>[
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                gradient: const LinearGradient(
                                  colors: <Color>[
                                    Color(0xFFFFB300),
                                    Color(0xFFE11D2E),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                    color: Color(0x66E11D2E),
                                    blurRadius: 28,
                                    spreadRadius: 2,
                                  ),
                                  BoxShadow(
                                    color: Color(0x44FFB300),
                                    blurRadius: 18,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(3),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.asset(
                                  'assets/paywall_rabbit_crown.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Golden crown badge in top-right corner
                            Positioned(
                              top: -6,
                              right: -6,
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFFFC107),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Color(0x88FFC107),
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.workspace_premium,
                                  color: Color(0xFF221100),
                                  size: 21,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      // Title & Subtitle with creative aura styling
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: <Color>[
                            Color(0xFFFFD54F),
                            Colors.white,
                            Color(0xFFFF303E),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: const Text(
                          'UNLEASH GOD AIM',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0x22E11D2E),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0x44E11D2E)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Icon(Icons.bolt,
                                  color: Color(0xFFFFB300), size: 16),
                              const SizedBox(width: 5),
                              Text(
                                context.tr('Elite Tools · Zero Limits · Instant Dominance'),
                                style: const TextStyle(
                                  color: Color(0xFFE2E2E8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Feature Comparison Card
                      _buildFeaturesTable(context),
                      const SizedBox(height: 22),

                      // Pricing Offer Cards (Monthly vs Lifetime)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: _buildOfferCard(
                              title: context.tr('MONTHLY'),
                              price: _monthlyPrice,
                              subtitle: context.tr('billed monthly'),
                              badgeText: context.tr('POPULAR'),
                              badgeColor: AuraColors.red,
                              selected: _selectedPlan == PaywallPlan.monthly,
                              onTap: () => setState(
                                  () => _selectedPlan = PaywallPlan.monthly),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildOfferCard(
                              title: context.tr('LIFETIME'),
                              price: _lifetimePrice,
                              subtitle: context.tr('one-time purchase'),
                              badgeText: context.tr('BEST VALUE'),
                              badgeColor: const Color(0xFFFF9800),
                              selected: _selectedPlan == PaywallPlan.lifetime,
                              onTap: () => setState(
                                  () => _selectedPlan = PaywallPlan.lifetime),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),

                      // CTA Button
                      SizedBox(
                        height: 58,
                        child: ElevatedButton(
                          onPressed: _busy ? null : _buy,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AuraColors.red,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFF6B1822),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 8,
                            shadowColor: const Color(0x88E11D2E),
                          ),
                          child: _busy
                              ? const SizedBox.square(
                                  dimension: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Icon(Icons.workspace_premium,
                                        size: 22),
                                    const SizedBox(width: 8),
                                    Text(
                                      _selectedPlan == PaywallPlan.monthly
                                          ? context.tr('START MONTHLY')
                                          : context.tr('GET LIFETIME ACCESS'),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Subscription subtitle info
                      Center(
                        child: Text(
                          _selectedPlan == PaywallPlan.monthly
                              ? '${_monthlyTitle ?? "Dark Aura Panel Pro Monthly"} · 1 month · $_monthlyPrice'
                              : 'Dark Aura Lifetime Pro · $_lifetimePrice',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF9E9EA8),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Links: Restore Purchases | Privacy Policy | Terms of Use
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextButton(
                            onPressed: _busy ? null : _restore,
                            style: TextButton.styleFrom(
                              foregroundColor: AuraColors.red,
                              visualDensity: VisualDensity.compact,
                            ),
                            child: Text(
                              context.tr('Restore Purchases'),
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const Text('·',
                              style: TextStyle(color: Colors.white38)),
                          TextButton(
                            onPressed: () => _openUrl(
                                'https://handcraft-studios.blogspot.com/p/privacy-policy.html'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white70,
                              visualDensity: VisualDensity.compact,
                            ),
                            child: Text(
                              context.tr('Privacy Policy'),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          const Text('·',
                              style: TextStyle(color: Colors.white38)),
                          TextButton(
                            onPressed: () => _openUrl(
                                'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white70,
                              visualDensity: VisualDensity.compact,
                            ),
                            child: Text(
                              context.tr('Terms of Use'),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Legal Disclaimer
                      Text(
                        _selectedPlan == PaywallPlan.monthly
                            ? context.tr(
                                'This subscription renews automatically every month unless cancelled at least 24 hours before the end of the current billing period. Payment will be charged to your Apple ID account.')
                            : context.tr(
                                'One-time payment charged to your Apple ID account. Unlocks all current and future Pro features permanently.'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF6E6E78),
                          fontSize: 10,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: bottomPadding),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesTable(BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: <Color>[
              Color(0x88E11D2E),
              Color(0x33FFB300),
              Color(0x22E11D2E),
              Color(0x15FFFFFF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x44000000),
              blurRadius: 20,
              offset: Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(1.5),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF131317),
            borderRadius: BorderRadius.circular(20.5),
          ),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          children: <Widget>[
            // Header Row: PRO | FREE
            const Row(
              children: <Widget>[
                Spacer(),
                SizedBox(
                  width: 54,
                  child: Text(
                    'PRO',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AuraColors.red,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                SizedBox(
                  width: 54,
                  child: Text(
                    'FREE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF7A7A85),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 18, color: Color(0x1EFFFFFF)),
            _featureRow(
              icon: Icons.tune,
              name: context.tr('Main Tools'),
              proEnabled: true,
              freeEnabled: true,
            ),
            const Divider(height: 16, color: Color(0x14FFFFFF)),
            _featureRow(
              icon: Icons.developer_board,
              name: context.tr('Device Infos'),
              proEnabled: true,
              freeEnabled: true,
            ),
            const Divider(height: 16, color: Color(0x14FFFFFF)),
            _featureRow(
              icon: Icons.build_circle_outlined,
              name: context.tr('Extra Tools'),
              proEnabled: true,
              freeEnabled: false,
            ),
            const Divider(height: 16, color: Color(0x14FFFFFF)),
            _featureRow(
              icon: Icons.block,
              name: context.tr('Ad-free Experience'),
              proEnabled: true,
              freeEnabled: false,
            ),
          ],
        ),
      ),
    );

  Widget _featureRow({
    required IconData icon,
    required String name,
    required bool proEnabled,
    required bool freeEnabled,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 19, color: AuraColors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              width: 54,
              child: Center(
                child: proEnabled
                    ? Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AuraColors.red,
                        ),
                        child: const Icon(Icons.check,
                            size: 13, color: Colors.white),
                      )
                    : const Text('—',
                        style: TextStyle(color: Color(0xFF6E6E78))),
              ),
            ),
            SizedBox(
              width: 54,
              child: Center(
                child: freeEnabled
                    ? Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF22C55E),
                        ),
                        child: const Icon(Icons.check,
                            size: 13, color: Colors.white),
                      )
                    : const Text('—',
                        style: TextStyle(
                            color: Color(0xFF6E6E78),
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      );

  Widget _buildOfferCard({
    required String title,
    required String price,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    required bool selected,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              height: 148,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: selected
                    ? const LinearGradient(
                        colors: <Color>[
                          Color(0xFFFF303E),
                          Color(0xFFFFB300),
                          Color(0xFF5A0A12),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : const LinearGradient(
                        colors: <Color>[
                          Color(0x33FFFFFF),
                          Color(0x10FFFFFF),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                boxShadow: selected
                    ? const <BoxShadow>[
                        BoxShadow(
                          color: Color(0x55E11D2E),
                          blurRadius: 20,
                          offset: Offset(0, 4),
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              padding: const EdgeInsets.all(1.8),
              child: Container(
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF1F1216)
                      : const Color(0xFF141418),
                  borderRadius: BorderRadius.circular(20.2),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 6),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selected
                            ? const Color(0xFFFF5252)
                            : const Color(0xFFA0A0AC),
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _loading
                        ? const SizedBox.square(
                            dimension: 26,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: AuraColors.red,
                            ),
                          )
                        : Text(
                            price,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 27,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.6,
                            ),
                          ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selected
                            ? const Color(0xFFD0B8C0)
                            : const Color(0xFF82828F),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Tag badge on top
            Positioned(
              top: -9,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: badgeColor.withValues(alpha: 0.6),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.9,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
