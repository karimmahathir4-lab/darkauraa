import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'ads/ad_service.dart';
import 'app_state.dart';
import 'trainer_store.dart';
import 'screens/home_screen.dart';
import 'screens/device_info_screen.dart';
import 'screens/learning_screen.dart';
import 'screens/profile_controls_sheet.dart';
import 'screens/settings_screen.dart';
import 'screens/profiles_screen.dart';
import 'screens/trainer_screen.dart';
import 'screens/onboarding_screen.dart';
import 'theme.dart';
import 'localization.dart';
import 'purchases/pro_service.dart';
import 'screens/pro_screen.dart';

const String kAppName = 'Dark Aura Panel';
const String kStoreUrl = 'https://apps.apple.com/us/app/id6831959156';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState();
  await state.load();
  await trainerStore.load();
  unawaited(AuraProService.instance.initialize(state));
  runApp(AuraApp(state: state));
}

Future<void> _initializeAdsAfterPurchaseCheck(AppState state) async {
  await AuraProService.instance.initialize(state);
  await AuraAds.instance.initialize();
}

class AuraApp extends StatelessWidget {
  const AuraApp({required this.state, super.key});
  final AppState state;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: state,
      builder: (context, _) => MaterialApp(
            title: kAppName,
            locale: Locale(
                state.languageCode,
                switch (state.languageCode) {
                  'pt' => 'BR',
                  'es' => 'ES',
                  'ar' => 'SA',
                  _ => 'US',
                }),
            supportedLocales: AuraLocalizations.supportedLocales,
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              AuraLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            navigatorKey: _rootNavigatorKey,
            debugShowCheckedModeBanner: false,
            theme: buildAuraTheme(),
            builder: (context, child) => Directionality(
              textDirection: state.languageCode == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Listener(
                behavior: HitTestBehavior.translucent,
                onPointerDown: AuraAds.instance.pointerDown,
                onPointerUp: AuraAds.instance.pointerUp,
                onPointerCancel: AuraAds.instance.pointerCancel,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    child ?? const SizedBox.shrink(),
                    if (state.onboardingComplete)
                      _DraggableProfileIcon(
                          state: state, navigatorKey: _rootNavigatorKey),
                  ],
                ),
              ),
            ),
            home: state.onboardingComplete
                ? AppLoadingGate(
                    child: AuraShell(state: state),
                  )
                : OnboardingScreen(state: state),
          ));
}

class _DraggableProfileIcon extends StatefulWidget {
  const _DraggableProfileIcon(
      {required this.state, required this.navigatorKey});
  final AppState state;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  State<_DraggableProfileIcon> createState() => _DraggableProfileIconState();
}

class _DraggableProfileIconState extends State<_DraggableProfileIcon> {
  Offset? _position;
  double _dragDistance = 0;
  bool _panelOpen = false;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: widget.state,
        builder: (context, _) {
          if (!widget.state.trainingProfileActive || _panelOpen) {
            return const SizedBox.shrink();
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              const size = 58.0;
              final maxLeft = (constraints.maxWidth - size)
                  .clamp(0.0, double.infinity)
                  .toDouble();
              final maxTop = (constraints.maxHeight - size)
                  .clamp(0.0, double.infinity)
                  .toDouble();
              final position = _position ?? Offset(maxLeft - 10, maxTop * .56);
              final left = position.dx.clamp(0.0, maxLeft).toDouble();
              final top = position.dy.clamp(0.0, maxTop).toDouble();
              return Stack(children: <Widget>[
                Positioned(
                  left: left,
                  top: top,
                  child: GestureDetector(
                    onPanStart: (_) => _dragDistance = 0,
                    onPanUpdate: (details) {
                      _dragDistance += details.delta.distance;
                      setState(() => _position = Offset(
                            (left + details.delta.dx)
                                .clamp(0.0, maxLeft)
                                .toDouble(),
                            (top + details.delta.dy)
                                .clamp(0.0, maxTop)
                                .toDouble(),
                          ));
                    },
                    onTap: () {
                      if (_dragDistance < 8) _openProfile();
                    },
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(
                            color: const Color(0xFFE11D2E), width: 2),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(color: Color(0x88E11D2E), blurRadius: 18),
                          BoxShadow(color: Color(0xAA000000), blurRadius: 8),
                        ],
                        image: DecorationImage(
                          image: AssetImage(
                            widget.state.currentAppIcon == 'ProIcon'
                                ? 'assets/pro_rabbit_icon.png'
                                : 'assets/aura_red_icon.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ]);
            },
          );
        },
      );

  Future<void> _openProfile() async {
    final context = widget.navigatorKey.currentContext;
    if (context == null) return;
    setState(() => _panelOpen = true);
    await showProfileControls(context, widget.state);
    if (mounted) setState(() => _panelOpen = false);
  }
}

class AuraShell extends StatefulWidget {
  const AuraShell({required this.state, super.key});
  final AppState state;

  @override
  State<AuraShell> createState() => _AuraShellState();
}

class _AuraShellState extends State<AuraShell> {
  int _tab = 0;
  Timer? _rateUsTimer;

  @override
  void initState() {
    super.initState();
    unawaited(_initializeAdsAfterPurchaseCheck(widget.state));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.state.initialPaywallSeen) {
        _startRateUsCountdown();
        return;
      }
      unawaited(widget.state.markInitialPaywallSeen());
      unawaited(_showInitialPaywallThenStartRateUsCountdown());
    });
  }

  Future<void> _showInitialPaywallThenStartRateUsCountdown() async {
    await Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => ProScreen(state: widget.state),
    ));
    if (mounted) _startRateUsCountdown();
  }

  void _startRateUsCountdown() {
    _rateUsTimer?.cancel();
    _rateUsTimer = Timer(const Duration(seconds: 15), _requestFirstLaunchReview);
  }

  Future<void> _requestFirstLaunchReview() async {
    if (!mounted) return;

    // Wait until the main app screen is visible (for example, after the
    // first-launch Pro screen has been dismissed) before showing a native UI.
    if (ModalRoute.of(context)?.isCurrent != true) {
      _rateUsTimer = Timer(const Duration(seconds: 1), _requestFirstLaunchReview);
      return;
    }

    const requestedKey = 'rate_us_prompt_requested';
    final preferences = await SharedPreferences.getInstance();
    if (!mounted || preferences.getBool(requestedKey) == true) return;

    // Store before requesting: the OS may suppress the prompt, and the app
    // should still make this first-launch request only once.
    await preferences.setBool(requestedKey, true);
    try {
      final review = InAppReview.instance;
      if (await review.isAvailable()) {
        await review.requestReview();
      }
    } catch (_) {
      // Native review availability is controlled by the platform/store.
    }
  }

  @override
  void dispose() {
    _rateUsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: widget.state,
        builder: (context, _) => Scaffold(
          extendBody: true,
          appBar: AppBar(
            titleSpacing: 0,
            toolbarHeight: 66,
            automaticallyImplyLeading: false,
            leadingWidth: 120,
            leading: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: AdsExcludedTapArea(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: <Color>[
                          Color(0xFFFFD700), // Vibrant gold/yellow
                          AuraColors.red,    // Red
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(1.2), // Gradient border outline
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF140D0E),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(9),
                          onTap: widget.state.isPro
                              ? null
                              : () => Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) =>
                                          ProScreen(state: widget.state),
                                    ),
                                  ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Icon(
                                  Icons.workspace_premium,
                                  color: Color(0xFFFFD700), // Yellow icon
                                  size: 18,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  widget.state.isPro ? 'PRO' : context.tr('Get Pro'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            title: const SizedBox.shrink(),
            actions: <Widget>[
              AdsExcludedTapArea(
                child: IconButton(
                  tooltip: context.tr('Settings'),
                  icon: const Icon(Icons.settings_outlined),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: AuraColors.red,
                    side: BorderSide.none,
                    shape: const CircleBorder(),
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => SettingsScreen(state: widget.state),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: Stack(
            children: <Widget>[
              const Positioned.fill(child: _AmbientGlassBackground()),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 920),
                  child: SizedBox.expand(
                    child: IndexedStack(
                      index: _tab,
                      children: <Widget>[
                        HomeScreen(
                            state: widget.state,
                            onActivateTraining: _activateSelectedTraining),
                        TrainerScreen(state: widget.state),
                        DeviceInfoScreen(state: widget.state),
                        LearningScreen(state: widget.state),
                        ProfilesScreen(state: widget.state),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _GlassNavigationBar(
            selectedIndex: _tab,
            onSelected: (index) => setState(() => _tab = index),
          ),
        ),
      );

  void _activateSelectedTraining() {
    widget.state.setTrainingProfileActive(true);
    setState(() => _tab = 1);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(
            context.tr('Selected practice preferences activated in Training')),
        backgroundColor: AuraColors.red,
        behavior: SnackBarBehavior.floating,
      ));
  }
}

class _AmbientGlassBackground extends StatelessWidget {
  const _AmbientGlassBackground();
  @override
  Widget build(BuildContext context) =>
      const Stack(fit: StackFit.expand, children: <Widget>[
        ColoredBox(color: AuraColors.background),
        Positioned(
            left: -170,
            top: 10,
            child: _GlowOrb(size: 380, color: Color(0x12E11D2E))),
        Positioned(
            right: -220,
            bottom: 15,
            child: _GlowOrb(size: 440, color: Color(0x105A0A12))),
        DecoratedBox(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
              Color(0x08FFFFFF),
              Color(0x000A0A0A),
              Color(0x22000000)
            ]))),
      ]);
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) => ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 55, sigmaY: 55),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                  colors: <Color>[color, const Color(0x000A0A0A)])),
        ),
      );
}

class _GlassNavigationBar extends StatelessWidget {
  const _GlassNavigationBar(
      {required this.selectedIndex, required this.onSelected});
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const List<(IconData, IconData, String)> _items =
      <(IconData, IconData, String)>[
    (Icons.dashboard_outlined, Icons.dashboard, 'Home'),
    (Icons.track_changes_outlined, Icons.track_changes, 'Trainer'),
    (Icons.smartphone_outlined, Icons.smartphone, 'Device'),
    (Icons.menu_book_outlined, Icons.menu_book, 'Learn'),
    (Icons.style_outlined, Icons.style, 'Profiles'),
  ];

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(13, 3, 13, 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                height: 68,
                decoration: BoxDecoration(
                  color: const Color(0xE618181B),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0x20FFFFFF)),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                        color: Color(0x44000000),
                        blurRadius: 20,
                        offset: Offset(0, 7))
                  ],
                ),
                child: Row(children: <Widget>[
                  for (var i = 0; i < _items.length; i++)
                    Expanded(child: _navItem(context, i, _items[i])),
                ]),
              ),
            ),
          ),
        ),
      );

  Widget _navItem(
      BuildContext context, int index, (IconData, IconData, String) item) {
    final selected = selectedIndex == index;
    return Semantics(
      button: true,
      selected: selected,
      label: context.tr(item.$3),
      child: InkWell(
        onTap: () => onSelected(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: selected ? const Color(0x24FFFFFF) : Colors.transparent,
            borderRadius: BorderRadius.circular(19),
            border:
                selected ? Border.all(color: const Color(0x18FFFFFF)) : null,
          ),
          child: Center(
            child: Icon(
              selected ? item.$2 : item.$1,
              size: 22,
              color: selected ? AuraColors.red : const Color(0xFF88888E),
            ),
          ),
        ),
      ),
    );
  }
}

class AppLoadingGate extends StatefulWidget {
  const AppLoadingGate({required this.child, super.key});
  final Widget child;

  @override
  State<AppLoadingGate> createState() => _AppLoadingGateState();
}

class _AppLoadingGateState extends State<AppLoadingGate> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _loading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loading) {
      return widget.child;
    }
    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0E),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const ColoredBox(color: Color(0xFF0C0C0E)),
          Positioned(
            left: -80,
            top: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x22E11D2E),
              ),
            ),
          ),
          Positioned(
            right: -100,
            bottom: -100,
            child: Container(
              width: 360,
              height: 360,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x185A0A12),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 104,
                  height: 104,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: const Color(0xFFE11D2E),
                      width: 2.2,
                    ),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x66E11D2E),
                        blurRadius: 28,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: Color(0xAA000000),
                        blurRadius: 14,
                        offset: Offset(0, 6),
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage('assets/aura_red_icon.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const SizedBox.square(
                  dimension: 26,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AuraColors.red,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  context.tr('Loading Panel...'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
