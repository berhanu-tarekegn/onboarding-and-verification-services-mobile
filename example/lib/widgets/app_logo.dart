import 'package:flutter/material.dart';

/// Official Kifiya mark — square asset with slight zoom/crop so the wordmark fills the frame.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 56,
    /// >1.0 crops outer padding (matches “slightly zoomed” launcher treatment).
    this.zoom = 1.14,
    this.borderRadius = 12,
  });

  final double size;
  final double zoom;
  final double borderRadius;

  static const assetPath =
      'assets/branding/kifiya_financial_technology_plc_logo.jpeg';

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(borderRadius);
    return ClipRRect(
      borderRadius: r,
      child: SizedBox(
        width: size,
        height: size,
        child: ClipRect(
          child: Transform.scale(
            scale: zoom,
            alignment: Alignment.center,
            child: Image.asset(
              assetPath,
              fit: BoxFit.cover,
              width: size,
              height: size,
              filterQuality: FilterQuality.high,
              gaplessPlayback: true,
            ),
          ),
        ),
      ),
    );
  }
}
