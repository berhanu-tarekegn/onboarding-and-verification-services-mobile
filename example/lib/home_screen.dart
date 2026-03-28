import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kifiya_rendering_engine/src/providers/form_providers.dart';
import 'package:kifiya_rendering_engine_example/form_data_source.dart';
import 'package:kifiya_rendering_engine_example/form_screen.dart';
import 'package:kifiya_rendering_engine_example/form_session_providers.dart';
import 'package:kifiya_rendering_engine_example/passkey/passkey_login_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const _accent = Color(0xFFE07A5F);
  static const _surfaceTint = Color(0xFF1B263B);

  void _openUserOnboarding(BuildContext context, WidgetRef ref) {
    ref.invalidate(formControllerProvider);
    ref.read(formErrorsProvider.notifier).state = {};
    ref.invalidate(remoteKybFormSessionProvider);
    ref.read(remoteKybStepProvider.notifier).state = 1;
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (context) =>
            const FormScreen(source: FormDataSource.remoteKybDemo),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topInset = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: _surfaceTint,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            const _LandingBackground(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: topInset > 0 ? 8 : 24),
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 48,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Welcome to our smart onboarding mobile application',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        height: 1.25,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        color: Colors.white.withValues(alpha: 0.98),
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Secure onboarding and intelligent case workflows for your organization.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.45,
                        color: Colors.white.withValues(alpha: 0.78),
                      ),
                    ),
                    const Spacer(),
                    _LandingCTA(
                      label: 'Try as an agent',
                      icon: Icons.badge_outlined,
                      filled: false,
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => const PasskeyLoginScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    _LandingCTA(
                      label: 'Try as a user',
                      icon: Icons.person_outline_rounded,
                      filled: true,
                      onPressed: () => _openUserOnboarding(context, ref),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LandingBackground extends StatelessWidget {
  const _LandingBackground();

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
              colors: [
                Color(0xFF0B1320),
                Color(0xFF0D1B2A),
                Color(0xFF1B263B),
                Color(0xFF243B53),
              ],
              stops: [0.0, 0.35, 0.72, 1.0],
            ),
          ),
        ),
        Positioned(
          top: -80,
          right: -60,
          child: _GlowBlob(
            size: 220,
            color: const Color(0xFF3D5A80).withValues(alpha: 0.45),
          ),
        ),
        Positioned(
          bottom: 120,
          left: -40,
          child: _GlowBlob(
            size: 180,
            color: HomeScreen._accent.withValues(alpha: 0.18),
          ),
        ),
        Positioned(
          bottom: -30,
          right: 20,
          child: _GlowBlob(
            size: 140,
            color: const Color(0xFF778DA9).withValues(alpha: 0.22),
          ),
        ),
      ],
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}

class _LandingCTA extends StatelessWidget {
  const _LandingCTA({
    required this.label,
    required this.icon,
    required this.filled,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14);

    if (filled) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 22),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: HomeScreen._accent,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: radius),
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 22),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(
          color: Colors.white.withValues(alpha: 0.55),
          width: 1.5,
        ),
        backgroundColor: Colors.white.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
    );
  }
}
