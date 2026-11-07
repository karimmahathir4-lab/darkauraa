import 'dart:math';

import 'package:flutter/material.dart';

import '../app_state.dart';
import '../data/toggles.dart';
import '../models/crosshair_style.dart';
import '../models/profile.dart';
import '../theme.dart';
import '../trainer_store.dart';
import '../widgets/common.dart';
import '../screens/widgets.dart';
import '../widgets/crosshair_painter.dart';
import '../localization.dart';
import 'profile_components.dart';

class ProfilesScreen extends StatefulWidget {
  const ProfilesScreen({required this.state, super.key});
  final AppState state;

  @override
  State<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  late final PageController _page = PageController(
    viewportFraction: 0.88,
    initialPage: max(
      0,
      widget.state.profiles
          .indexWhere((p) => p.id == widget.state.activeProfileId),
    ),
  );

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  Future<void> _saveNew() async {
    final name = await showProfileNameDialog(
      context,
      title: context.tr('Save current setup'),
      initial: '${context.tr('My setup')} ${widget.state.profiles.length + 1}',
    );
    if (name != null) widget.state.saveAsNewProfile(name);
  }

  Future<void> _import() async {
    final p = await showProfileImportDialog(context);
    if (p == null) return;
    widget.state.importProfile(p);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${context.tr('Imported')} ${p.name}')));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([widget.state, trainerStore]),
      builder: (context, _) {
        final accent = Theme.of(context).colorScheme.primary;
        final profiles = widget.state.profiles;
        final activeIdx =
            profiles.indexWhere((p) => p.id == widget.state.activeProfileId);

        // Keep the carousel in sync when the profile changes elsewhere
        // (floating panel, import, save, delete).
        if (activeIdx >= 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || !_page.hasClients) return;
            final cur = (_page.page ?? activeIdx.toDouble()).round();
            if (cur != activeIdx && !_page.position.isScrollingNotifier.value) {
              _page.jumpToPage(activeIdx);
            }
          });
        }

        final active = widget.state.activeProfile;

        return ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            12,
            16,
            MediaQuery.paddingOf(context).bottom + 100,
          ),
          children: [
            Row(
              children: [
                Text(context.tr('Profiles'),
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w900)),
                const Spacer(),
                Text('${profiles.length} ${context.tr('saved')}',
                    style: const TextStyle(color: Colors.white54)),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              context.tr(
                  'Swipe a card to switch. Crosshair and sensitivity change instantly.'),
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 14),
            if (profiles.isEmpty)
              GlassCard(
                child: Text(
                  context.tr(
                      'No profiles yet. Tap "Save current setup" to create one.'),
                  style: const TextStyle(color: Colors.white70),
                ),
              )
            else ...[
              SizedBox(
                height: 300,
                child: PageView.builder(
                  controller: _page,
                  itemCount: profiles.length,
                  onPageChanged: (i) {
                    if (i < 0 || i >= widget.state.profiles.length) return;
                    final p = widget.state.profiles[i];
                    if (p.id != widget.state.activeProfileId) {
                      widget.state.tap();
                      widget.state.applyProfile(p);
                    }
                  },
                  itemBuilder: (context, i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ProfileCard(
                      profile: profiles[i],
                      state: widget.state,
                      active: profiles[i].id == widget.state.activeProfileId,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < profiles.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == activeIdx ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: i == activeIdx ? accent : Colors.white24,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                ],
              ),
            ],
            if (active != null && widget.state.isDirty) ...[
              const SizedBox(height: 14),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.edit_note, color: Color(0xFFFACC15)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${context.tr('Unsaved changes on')} ${active.name}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              widget.state.tap();
                              widget.state.applyProfile(active);
                            },
                            child: Text(context.tr('Revert')),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              widget.state.tap();
                              widget.state.updateActiveProfile();
                            },
                            child: Text(context.tr('Update profile')),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            if (active != null) ...[
              SectionTitle(context.tr('Tune active profile')),
              _tuningCard(context, widget.state),
            ],
            SectionTitle(context.tr('Manage')),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _saveNew,
                icon: const Icon(Icons.add),
                label: Text(context.tr('Save current setup')),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _import,
                icon: const Icon(Icons.download),
                label: Text(context.tr('Import from code')),
              ),
            ),
            SectionTitle(context.tr('Profile Lab')),
            _lab(context, accent, profiles),
          ],
        );
      },
    );
  }

  Widget _tuningCard(BuildContext context, AppState state) => GlassCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(context.tr('Crosshair style'),
              style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final style in CrosshairStyle.values)
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () =>
                    state.setProfileValue('crosshair_style', style.label),
                child: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: style == state.crosshairStyle
                        ? const Color(0x3328D17C)
                        : Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: style == state.crosshairStyle
                          ? AuraColors.red
                          : Colors.white24,
                    ),
                  ),
                  child: CustomPaint(
                    size: const Size.square(52),
                    painter: CrosshairPainter(
                      style: style,
                      size: state.crosshairSize,
                      thickness: state.crosshairThickness,
                      gap: state.crosshairGap,
                      opacity: state.crosshairOpacity,
                      color: state.crosshairColor,
                    ),
                  ),
                ),
              ),
          ]),
          const SizedBox(height: 10),
          Text(context.tr('Crosshair color'),
              style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Wrap(spacing: 5, children: [
            for (final entry in trainingOverlayColors.entries)
              IconButton(
                tooltip: entry.key,
                visualDensity: VisualDensity.compact,
                onPressed: () =>
                    state.setProfileValue('crosshair_color', entry.key),
                icon: Icon(Icons.circle, color: Color(entry.value), size: 22),
              ),
          ]),
          _profileSlider(
              context, state, 'Size', 'crosshair_size', 8, 80, ' px'),
          _profileSlider(
              context, state, 'Thickness', 'crosshair_thickness', 1, 8, ' px'),
          _profileSlider(context, state, 'Gap', 'crosshair_gap', 0, 20, ' px'),
          _profileSlider(
              context, state, 'Opacity', 'crosshair_opacity', .1, 1, '',
              fractionDigits: 2),
          const SizedBox(height: 8),
          Text(context.tr('Sensitivity'),
              style: const TextStyle(fontWeight: FontWeight.w700)),
          for (final key in kSensitivityKeys)
            _sensitivitySlider(context, state, key),
        ]),
      );

  Widget _profileSlider(BuildContext context, AppState state, String label,
      String key, double min, double max, String suffix,
      {int fractionDigits = 0}) {
    final fallback = switch (key) {
      'crosshair_size' => 32.0,
      'crosshair_thickness' => 2.0,
      'crosshair_gap' => 5.0,
      _ => .9,
    };
    final value = (state.profileValue(key) as num?)?.toDouble() ?? fallback;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(
            child: Text(context.tr(label),
                style: const TextStyle(color: Colors.white70, fontSize: 12))),
        Text('${value.toStringAsFixed(fractionDigits)}$suffix',
            style: const TextStyle(color: Colors.white54, fontSize: 11)),
      ]),
      Slider(
        min: min,
        max: max,
        value: value.clamp(min, max),
        onChanged: (next) => state.updateProfileValue(key, next),
        onChangeEnd: (_) => state.saveProfileValues(),
      ),
    ]);
  }

  Widget _sensitivitySlider(BuildContext context, AppState state, String key) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
              child: Text(context.tr(key),
                  style: const TextStyle(color: Colors.white70, fontSize: 12))),
          Text('${(state.sensitivity[key] ?? 70).round()}',
              style: const TextStyle(color: Colors.white54, fontSize: 11)),
        ]),
        Slider(
          min: 0,
          max: 100,
          value: (state.sensitivity[key] ?? 70).clamp(0, 100),
          onChanged: (value) => state.setSensitivity(key, value),
          onChangeEnd: (_) => state.saveProfileValues(),
        ),
      ]);

  /// Ranks profiles by their best Aim Trainer score.
  Widget _lab(BuildContext context, Color accent, List<Profile> profiles) {
    if (profiles.isEmpty) {
      return const SizedBox.shrink();
    }
    final ranked = [...profiles]..sort((a, b) =>
        (trainerStore.profileBest[b.id] ?? 0)
            .compareTo(trainerStore.profileBest[a.id] ?? 0));
    final top = ranked
        .map((p) => trainerStore.profileBest[p.id] ?? 0)
        .fold<int>(1, (a, b) => max(a, b));

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr(
                'Play the Aim Trainer with different profiles to see which setup scores best.'),
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < ranked.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 22,
                    child: Text('${i + 1}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.white54)),
                  ),
                  SizedBox(
                    width: 92,
                    child: Text(ranked[i].name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: LinearProgressIndicator(
                        value:
                            (trainerStore.profileBest[ranked[i].id] ?? 0) / top,
                        minHeight: 8,
                        backgroundColor: Colors.white12,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(ranked[i].color),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 44,
                    child: Text(
                      trainerStore.profileBest[ranked[i].id] == null
                          ? '-'
                          : '${trainerStore.profileBest[ranked[i].id]}',
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(color: accent, fontWeight: FontWeight.w800),
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
