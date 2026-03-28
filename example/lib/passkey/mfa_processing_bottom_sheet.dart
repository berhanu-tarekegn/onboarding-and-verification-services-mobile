import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kifiya_rendering_engine_example/passkey/futuristic_auth_theme.dart';

/// Shown once after the first successful OTP: key provisioning and server sync.
Future<void> showAutoMfaEnrollmentSheet(
  BuildContext context, {
  required VoidCallback onComplete,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.72),
    builder: (ctx) => _MfaPipelineSheet(
      title: 'MFA ENROLLMENT',
      footer: 'Securing your device with encrypted keys and policy sync.',
      stepLabels: const [
        'Generating RSA key pair',
        'Syncing RSA with server',
        'MFA configured successfully',
      ],
      stepDelaysMs: const [1050, 1050, 1100],
      headerIcon: Icons.hub_rounded,
      onComplete: () {
        Navigator.of(ctx).pop();
        onComplete();
      },
    ),
  );
}

/// Shown after MFA code is accepted: server challenge and session confirmation.
Future<void> showMfaAuthenticationSheet(
  BuildContext context, {
  required VoidCallback onComplete,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.72),
    builder: (ctx) => _MfaPipelineSheet(
      title: 'MFA AUTHENTICATION',
      footer: 'Establishing a verified session with the identity service.',
      stepLabels: const [
        'Receiving challenge from server',
        'Solving challenge and submitting response',
        'Awaiting server acknowledgment',
      ],
      // Middle step (challenge solve + submit) runs longer than the others.
      stepDelaysMs: const [1000, 2600, 1000],
      headerIcon: Icons.verified_user_rounded,
      onComplete: () {
        Navigator.of(ctx).pop();
        onComplete();
      },
    ),
  );
}

class _MfaPipelineSheet extends StatefulWidget {
  const _MfaPipelineSheet({
    required this.title,
    required this.footer,
    required this.stepLabels,
    required this.stepDelaysMs,
    required this.headerIcon,
    required this.onComplete,
  });

  final String title;
  final String footer;
  final List<String> stepLabels;
  final List<int> stepDelaysMs;
  final IconData headerIcon;
  final VoidCallback onComplete;

  @override
  State<_MfaPipelineSheet> createState() => _MfaPipelineSheetState();
}

class _MfaPipelineSheetState extends State<_MfaPipelineSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  final List<_StepLine> _steps = [];

  @override
  void initState() {
    super.initState();
    assert(widget.stepLabels.length == widget.stepDelaysMs.length);
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    for (var i = 0; i < widget.stepLabels.length; i++) {
      _steps.add(
        _StepLine(label: widget.stepLabels[i], done: false, active: i == 0),
      );
    }
    _runPipeline();
  }

  Future<void> _runPipeline() async {
    for (var i = 0; i < _steps.length; i++) {
      await Future<void>.delayed(
        Duration(milliseconds: widget.stepDelaysMs[i]),
      );
      if (!mounted) return;
      setState(() {
        _steps[i].done = true;
        _steps[i].active = false;
        if (i + 1 < _steps.length) {
          _steps[i + 1].active = true;
        }
      });
    }
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    widget.onComplete();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(left: 12, right: 12, bottom: 8 + bottom),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF152238).withValues(alpha: 0.94),
                  const Color(0xFF0D1B2A).withValues(alpha: 0.97),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: FuturisticAuthTheme.cyanGlow.withValues(alpha: 0.35),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: FuturisticAuthTheme.accent.withValues(alpha: 0.12),
                  blurRadius: 40,
                  spreadRadius: 2,
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _HeaderPulse(animation: _pulse, icon: widget.headerIcon),
                const SizedBox(height: 8),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 3.2,
                    color: FuturisticAuthTheme.accent.withValues(alpha: 0.95),
                  ),
                ),
                const SizedBox(height: 20),
                ...List.generate(_steps.length, (i) {
                  final s = _steps[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _StepRow(line: s),
                  );
                }),
                const SizedBox(height: 8),
                Text(
                  widget.footer,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.38),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepLine {
  _StepLine({required this.label, required this.done, required this.active});

  final String label;
  bool done;
  bool active;
}

class _HeaderPulse extends StatelessWidget {
  const _HeaderPulse({required this.animation, required this.icon});

  final Animation<double> animation;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final t = animation.value;
        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.rotate(
              angle: t * 6.28318 * 0.15,
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      FuturisticAuthTheme.cyanGlow.withValues(alpha: 0.0),
                      FuturisticAuthTheme.cyanGlow.withValues(alpha: 0.85),
                      FuturisticAuthTheme.accent.withValues(alpha: 0.5),
                      FuturisticAuthTheme.cyanGlow.withValues(alpha: 0.0),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: FuturisticAuthTheme.cyanGlow.withValues(
                        alpha: 0.35 + t * 0.2,
                      ),
                      blurRadius: 18 + t * 12,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0B1320).withValues(alpha: 0.92),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: Icon(
                icon,
                size: 32,
                color: Colors.white.withValues(alpha: 0.92),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.line});

  final _StepLine line;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 28,
          height: 28,
          child: line.done
              ? Icon(
                  Icons.check_circle_rounded,
                  color: FuturisticAuthTheme.cyanGlow,
                  size: 26,
                )
              : line.active
              ? const Padding(
                  padding: EdgeInsets.all(2),
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: FuturisticAuthTheme.accent,
                  ),
                )
              : Icon(
                  Icons.radio_button_unchecked_rounded,
                  color: Colors.white.withValues(alpha: 0.22),
                  size: 22,
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            line.label,
            style: TextStyle(
              fontSize: 15,
              height: 1.25,
              fontWeight: line.active ? FontWeight.w600 : FontWeight.w500,
              color: line.done
                  ? Colors.white.withValues(alpha: 0.55)
                  : line.active
                  ? Colors.white.withValues(alpha: 0.95)
                  : Colors.white.withValues(alpha: 0.45),
            ),
          ),
        ),
      ],
    );
  }
}
