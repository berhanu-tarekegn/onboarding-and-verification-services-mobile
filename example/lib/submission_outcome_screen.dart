import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_screen.dart';
import 'theme/futuristic_mesh_background.dart';

/// Shown after a remote form submission. Success state uses a futuristic layout.
class SubmissionOutcomeScreen extends StatefulWidget {
  const SubmissionOutcomeScreen({
    super.key,
    required this.isSuccess,
    this.message,
  });

  final bool isSuccess;
  final String? message;

  @override
  State<SubmissionOutcomeScreen> createState() =>
      _SubmissionOutcomeScreenState();
}

class _SubmissionOutcomeScreenState extends State<SubmissionOutcomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entrance;
  late final AnimationController _pulse;
  late final AnimationController _ringSpin;

  late final Animation<double> _sealScale;
  late final Animation<double> _sealOpacity;
  late final Animation<double> _iconPop;
  late final Animation<double> _titleReveal;
  late final Animation<double> _headlineReveal;
  late final Animation<double> _bodyReveal;
  late final Animation<double> _buttonReveal;

  static const _cyan = Color(0xFF00E5FF);
  static const _violet = Color(0xFF7C4DFF);
  static const _bgBot = Color(0xFF080C18);

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1650),
    );
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _ringSpin = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();

    _sealScale = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
    );
    _sealOpacity = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );
    _iconPop = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.12, 0.52, curve: Curves.elasticOut),
    );
    _titleReveal = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.28, 0.52, curve: Curves.easeOutCubic),
    );
    _headlineReveal = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.38, 0.62, curve: Curves.easeOutCubic),
    );
    _bodyReveal = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.48, 0.72, curve: Curves.easeOutCubic),
    );
    _buttonReveal = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.58, 0.92, curve: Curves.easeOutCubic),
    );

    _entrance.forward();
  }

  @override
  void dispose() {
    _entrance.dispose();
    _pulse.dispose();
    _ringSpin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isSuccess) {
      return _simpleFailure(context);
    }
    return _futuristicSuccess(context);
  }

  Widget _simpleFailure(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Submission failed'),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          onPressed: _goHome,
          icon: const Icon(Icons.close),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.red.shade700),
              const SizedBox(height: 20),
              Text(
                widget.message ?? 'Something went wrong',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              FilledButton(onPressed: _goHome, child: const Text('Back to home')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _futuristicSuccess(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: FuturisticMeshBackground.bgTop,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: _bgBot,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        leading: IconButton(
          onPressed: _goHome,
          icon: Icon(Icons.close, color: Colors.white.withValues(alpha: 0.85)),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const FuturisticMeshBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _entrance,
                      _pulse,
                      _ringSpin,
                    ]),
                    builder: (context, child) {
                      final tPulse = CurvedAnimation(
                        parent: _pulse,
                        curve: Curves.easeInOut,
                      ).value;
                      final breathe = 1.0 + tPulse * 0.035;
                      final ringAngle = _ringSpin.value * 2 * math.pi;
                      return Opacity(
                        opacity: _sealOpacity.value,
                        child: Transform.scale(
                          scale: _sealScale.value * breathe,
                          alignment: Alignment.center,
                          child: _glowingSeal(
                            iconScale: _iconPop.value,
                            ringRotation: ringAngle,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 36),
                  FadeTransition(
                    opacity: _titleReveal,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.15),
                        end: Offset.zero,
                      ).animate(_titleReveal),
                      child: Text(
                        'TRANSMISSION COMPLETE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _cyan.withValues(alpha: 0.85),
                          letterSpacing: 5,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  FadeTransition(
                    opacity: _headlineReveal,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.12),
                        end: Offset.zero,
                      ).animate(_headlineReveal),
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFFE8F4FF),
                            _cyan,
                            Color(0xFFB8C5FF),
                          ],
                        ).createShader(bounds),
                        child: const Text(
                          'Submission secured',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            height: 1.2,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: _bodyReveal,
                    child: Text(
                      'Your responses are encrypted in transit and\nregistered on the verification mesh.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                  ),
                  const Spacer(flex: 3),
                  FadeTransition(
                    opacity: _buttonReveal,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(_buttonReveal),
                      child: _chromeButton(
                        label: 'RETURN TO HUB',
                        onPressed: _goHome,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glowingSeal({
    required double iconScale,
    required double ringRotation,
  }) {
    const sealSize = 168.0;
    const inner = 132.0;
    return SizedBox(
      width: sealSize,
      height: sealSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: sealSize,
            height: sealSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _cyan.withValues(alpha: 0.35),
                  blurRadius: 48,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: _violet.withValues(alpha: 0.2),
                  blurRadius: 64,
                  spreadRadius: -8,
                ),
              ],
            ),
          ),
          Container(
            width: inner,
            height: inner,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _cyan.withValues(alpha: 0.45),
                width: 1.5,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1a2338).withValues(alpha: 0.95),
                  const Color(0xFF0d1528).withValues(alpha: 0.98),
                ],
              ),
            ),
            child: Transform.scale(
              scale: iconScale.clamp(0.0, 1.0),
              child: Icon(
                Icons.verified_rounded,
                size: 72,
                color: _cyan.withValues(alpha: 0.95),
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: OrbitalRingPainter(
                color: _cyan.withValues(alpha: 0.35),
                rotation: ringRotation,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chromeButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: _cyan.withValues(alpha: 0.55), width: 1.2),
            gradient: LinearGradient(
              colors: [
                _cyan.withValues(alpha: 0.12),
                _violet.withValues(alpha: 0.08),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: _cyan.withValues(alpha: 0.15),
                blurRadius: 16,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home_rounded,
                    size: 18, color: _cyan.withValues(alpha: 0.9)),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    letterSpacing: 3,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }
}
