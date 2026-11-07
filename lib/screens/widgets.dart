import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../theme.dart';

class AuraCard extends StatelessWidget {
  const AuraCard(
      {required this.child,
      this.padding = const EdgeInsets.all(16),
      super.key});
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Color(0xE61D1D20), Color(0xD9101012)],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0x20FFFFFF)),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                    color: Color(0x30000000),
                    blurRadius: 28,
                    offset: Offset(0, 12)),
              ],
            ),
            child: child,
          ),
        ),
      );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {this.icon, super.key});
  final String title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Row(children: <Widget>[
        if (icon != null) ...<Widget>[
          Icon(icon, color: AuraColors.red, size: 18),
          const SizedBox(width: 8),
        ],
        Expanded(
            child: Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: -0.2))),
      ]);
}

class RedGradientHeader extends StatelessWidget {
  const RedGradientHeader({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
              colors: <Color>[Color(0xFFE11D2E), Color(0xFF74121C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          border: Border.all(color: const Color(0x30FFFFFF)),
          boxShadow: const <BoxShadow>[
            BoxShadow(
                color: Color(0x24E11D2E),
                blurRadius: 30,
                offset: Offset(0, 12)),
          ],
        ),
        child: child,
      );
}
