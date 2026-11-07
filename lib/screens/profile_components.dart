import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../app_state.dart';
import '../localization.dart';
import '../models/crosshair_style.dart';
import '../models/profile.dart';
import '../theme.dart';
import '../trainer_store.dart';
import '../widgets/common.dart';
import '../widgets/crosshair_painter.dart';

Future<Profile?> showProfileImportDialog(BuildContext context) =>
    showDialog<Profile>(
      context: context,
      builder: (_) => const _ImportDialog(),
    );

class ProfileCard extends StatelessWidget {
  const ProfileCard({required this.profile, required this.state, required this.active, super.key});

  final Profile profile;
  final AppState state;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final best = trainerStore.profileBest[profile.id];
    final sessions = trainerStore.profileSessions[profile.id] ?? 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: active ? profile.color.fade(0.9) : Colors.white.fade(0.06),
          width: active ? 2 : 1,
        ),
        boxShadow: active
            ? [BoxShadow(color: profile.color.fade(0.25), blurRadius: 18)]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Crosshair preview
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF1B1035), Color(0xFF0F172A)],
                  ),
                ),
                child: CustomPaint(
                  size: const Size.square(100),
                  painter: CrosshairPainter(
                    style: profile.style,
                    size: profile.size,
                    thickness: profile.thickness,
                    gap: profile.gap,
                    opacity: profile.opacity,
                    color: profile.color,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            profile.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                        ),
                        if (active) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: profile.color.fade(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(context.tr('ACTIVE'),
                                style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: profile.color)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${context.tr(profile.style.label)} - ${profile.size.round()} px',
                      style:
                          const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    _MiniBar('General', profile.sensitivity['General'] ?? 0,
                        profile.color),
                    _MiniBar('Red Dot', profile.sensitivity['Red Dot'] ?? 0,
                        profile.color),
                    _MiniBar('AWM', profile.sensitivity['AWM Scope'] ?? 0,
                        profile.color),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.emoji_events_outlined,
                  size: 16, color: Colors.white54),
              const SizedBox(width: 6),
              Text(
                best == null
                    ? context.tr('No trainer score yet')
                    : '${context.tr('Best')} $best - $sessions ${context.tr('sessions')}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _IconBtn(Icons.edit_outlined, context.tr('Rename'), () async {
                final name = await showProfileNameDialog(context,
                    title: context.tr('Rename profile'), initial: profile.name);
                if (name != null) state.renameProfile(profile, name);
              }),
              _IconBtn(Icons.copy_outlined, context.tr('Duplicate'), () {
                state.tap();
                state.duplicateProfile(profile);
              }),
              _IconBtn(Icons.qr_code_2, context.tr('Share code / QR'),
                  () => showProfileShareDialog(context, profile)),
              _IconBtn(Icons.delete_outline, context.tr('Delete'), () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: kSurfaceHigh,
                    title: Text('${context.tr('Delete')} ${profile.name}?'),
                    content: Text(context.tr('This cannot be undone.')),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: Text(context.tr('Cancel')),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: Text(context.tr('Delete')),
                      ),
                    ],
                  ),
                );
                if (ok == true) state.deleteProfile(profile);
              }),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniBar extends StatelessWidget {
  const _MiniBar(this.label, this.value, this.color);

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            child: Text(label,
                style: const TextStyle(fontSize: 11, color: Colors.white54)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (value / 100).clamp(0.0, 1.0).toDouble(),
                minHeight: 6,
                backgroundColor: Colors.white12,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 24,
            child: Text('${value.round()}',
                textAlign: TextAlign.right,
                style:
                    const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn(this.icon, this.tooltip, this.onPressed);

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}

// ======================= Dialogs =======================

Future<String?> showProfileNameDialog(
  BuildContext context, {
  required String title,
  required String initial,
  String confirm = 'Save',
}) {
  return showDialog<String>(
    context: context,
    builder: (_) =>
        _NameDialog(title: title, initial: initial, confirm: confirm),
  );
}

class _NameDialog extends StatefulWidget {
  const _NameDialog({
    required this.title,
    required this.initial,
    required this.confirm,
  });

  final String title;
  final String initial;
  final String confirm;

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  late final TextEditingController _c =
      TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _submit() {
    final t = _c.text.trim();
    if (t.isNotEmpty) Navigator.of(context).pop(t);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kSurfaceHigh,
      title: Text(widget.title),
      content: TextField(
        controller: _c,
        autofocus: true,
        maxLength: 20,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: context.tr('Profile name'),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.tr('Cancel')),
        ),
        FilledButton(
            onPressed: _submit, child: Text(context.tr(widget.confirm))),
      ],
    );
  }
}

Future<void> showProfileShareDialog(BuildContext context, Profile p) {
  final code = p.toShareCode();
  final messenger = ScaffoldMessenger.of(context);

  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: kSurfaceHigh,
      title: Text('${context.tr('Share')} ${p.name}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: QrImageView(
                data: code,
                version: QrVersions.auto,
                size: 220,
                padding: EdgeInsets.zero,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SelectableText(
                code,
                style: const TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: code));
            Navigator.of(ctx).pop();
            messenger.showSnackBar(
              SnackBar(content: Text(context.tr('Code copied'))),
            );
          },
          child: Text(context.tr('Copy code')),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(context.tr('Close')),
        ),
      ],
    ),
  );
}

class _ImportDialog extends StatefulWidget {
  const _ImportDialog();

  @override
  State<_ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends State<_ImportDialog> {
  final TextEditingController _c = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (!mounted) return;
    final text = data?.text;
    if (text != null) {
      setState(() {
        _c.text = text;
        _error = null;
      });
    }
  }

  void _import() {
    final p = Profile.fromShareCode(_c.text);
    if (p == null) {
      setState(
          () => _error = context.tr('That is not a valid Aura profile code.'));
    } else {
      Navigator.of(context).pop(p);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kSurfaceHigh,
      title: Text(context.tr('Import profile')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _c,
            maxLines: 4,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: context.tr('Paste an FFP1: code'),
              errorText: _error,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _paste,
              icon: const Icon(Icons.paste, size: 18),
              label: Text(context.tr('Paste')),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.tr('Cancel')),
        ),
        FilledButton(onPressed: _import, child: Text(context.tr('Import'))),
      ],
    );
  }
}
