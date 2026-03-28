import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Dark mesh + grid used by success screen and KYB form for visual continuity.
class FuturisticMeshBackground extends StatelessWidget {
  const FuturisticMeshBackground({super.key});

  static const bgTop = Color(0xFF060814);
  static const bgMid = Color(0xFF0C1224);
  static const bgBot = Color(0xFF080C18);
  static const cyan = Color(0xFF00E5FF);
  static const violet = Color(0xFF7C4DFF);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [bgTop, bgMid, bgBot],
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: FuturisticGridPainter(),
            );
          },
        ),
        Positioned(
          top: -120,
          right: -80,
          child: IgnorePointer(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    cyan.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -60,
          left: -40,
          child: IgnorePointer(
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    violet.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FuturisticGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.045)
      ..strokeWidth = 1;

    const spacing = 42.0;
    for (double x = 0; x < size.width + spacing; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height + spacing; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    final diag = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.04)
      ..strokeWidth = 1;
    for (double i = -size.height; i < size.width; i += 80) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height * 0.9, size.height),
        diag,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Slowly rotating arcs around a center (success seal decoration).
class OrbitalRingPainter extends CustomPainter {
  OrbitalRingPainter({
    required this.color,
    this.rotation = 0,
  });

  final Color color;
  final double rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.shortestSide / 2;
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(rotation);
    canvas.translate(-c.dx, -c.dy);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r * 0.92),
      -math.pi / 3,
      math.pi * 1.2,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r * 1.05),
      math.pi * 0.4,
      math.pi * 1.1,
      false,
      paint..color = color.withValues(alpha: 0.5),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant OrbitalRingPainter oldDelegate) =>
      oldDelegate.rotation != rotation || oldDelegate.color != color;
}
