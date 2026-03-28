import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Visual tokens shared with [HomeScreen] landing and agent sign-in flow.
abstract final class FuturisticAuthTheme {
  static const accent = Color(0xFFE07A5F);
  static const surfaceTint = Color(0xFF1B263B);
  static const cyanGlow = Color(0xFF4ECDC4);

  static const gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0B1320),
      Color(0xFF0D1B2A),
      Color(0xFF1B263B),
      Color(0xFF152a45),
    ],
    stops: [0.0, 0.32, 0.68, 1.0],
  );

  static SystemUiOverlayStyle get overlayStyle => const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: surfaceTint,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  static Widget background({List<Widget>? extraBlobs}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(decoration: BoxDecoration(gradient: gradient)),
        Positioned(
          top: -100,
          left: -40,
          child: _blob(200, cyanGlow.withValues(alpha: 0.12)),
        ),
        Positioned(
          top: 120,
          right: -80,
          child: _blob(240, accent.withValues(alpha: 0.14)),
        ),
        Positioned(
          bottom: -20,
          left: -30,
          child: _blob(160, const Color(0xFF778DA9).withValues(alpha: 0.2)),
        ),
        if (extraBlobs != null) ...extraBlobs,
      ],
    );
  }

  static Widget _blob(double size, Color color) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }

  static Widget glassPanel({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(24),
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.14),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.08),
                blurRadius: 32,
                spreadRadius: 0,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  static InputDecoration fieldDecoration({
    required String label,
    String? hint,
    Widget? prefix,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
    );
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefix,
      labelStyle: TextStyle(
        color: Colors.white.withValues(alpha: 0.65),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
      ),
      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35)),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.05),
      border: border,
      enabledBorder: border,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: cyanGlow, width: 1.4),
      ),
    );
  }
}
