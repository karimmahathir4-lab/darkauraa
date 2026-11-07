import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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

const String kAppName = 'Dark Aura Aim Panel';
const String kStoreUrl =
    'https://play.google.com/store/apps/details?id=com.example.auraaim';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState();
  await state.load();
  await trainerStore.load();
  unawaited(AuraProService.instance.initialize(state));
  if (state.onboardingComplete)
    unawaited(_initializeAdsAfterPurchaseCheck(state));
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
                ? AuraShell(state: state)
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
                        image: const DecorationImage(
                          image: AssetImage('assets/aura_red_icon.png'),
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.state.initialPaywallSeen) return;
      unawaited(widget.state.markInitialPaywallSeen());
      Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => ProScreen(state: widget.state),
      ));
    });
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
            title: const SizedBox.shrink(),
            actions: <Widget>[
              AdsExcludedTapArea(
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ProScreen(state: widget.state),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: widget.state.isPro
                        ? const Color(0xFFFFD66B)
                        : AuraColors.red,
                    backgroundColor: const Color(0x14E11D2E),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                    minimumSize: const Size(0, 44),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: BorderSide(
                      color: widget.state.isPro
                          ? const Color(0xAAFFD66B)
                          : AuraColors.red,
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(widget.state.isPro ? 'PRO' : context.tr('Pro'),
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, height: 1)),
                      Text(
                          widget.state.isPro
                              ? context.tr('Active')
                              : context.tr('Remove ads'),
                          style: const TextStyle(fontSize: 9, height: 1.2)),
                    ],
                  ),
                ),
              ),
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
      Stack(fit: StackFit.expand, children: <Widget>[
        const ColoredBox(color: AuraColors.background),
        Positioned(
            left: -170,
            top: 10,
            child: _GlowOrb(size: 380, color: Color(0x12E11D2E))),
        Positioned(
            right: -220,
            bottom: 15,
            child: _GlowOrb(size: 440, color: Color(0x105A0A12))),
        const DecoratedBox(
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
