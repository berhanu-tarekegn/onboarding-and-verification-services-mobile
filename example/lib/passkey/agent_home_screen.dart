import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kifiya_rendering_engine_example/core/di/injection.dart';
import 'package:kifiya_rendering_engine_example/passkey/futuristic_auth_theme.dart';

/// Agent workspace after sign-in (OTP enrollment or MFA verification).
class AgentHomeScreen extends ConsumerWidget {
  const AgentHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: FuturisticAuthTheme.overlayStyle,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1320),
        body: Stack(
          fit: StackFit.expand,
          children: [
            FuturisticAuthTheme.background(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: FuturisticAuthTheme.cyanGlow.withValues(
                              alpha: 0.15,
                            ),
                            border: Border.all(
                              color: FuturisticAuthTheme.cyanGlow.withValues(
                                alpha: 0.35,
                              ),
                            ),
                          ),
                          child: Icon(
                            Icons.support_agent_rounded,
                            color: Colors.white.withValues(alpha: 0.92),
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Agent workspace',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.4,
                                  color: Colors.white.withValues(alpha: 0.96),
                                ),
                              ),
                              Text(
                                'Queues, reviews, and escalations in one place.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withValues(alpha: 0.52),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    FuturisticAuthTheme.glassPanel(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Today',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                              color: FuturisticAuthTheme.accent.withValues(
                                alpha: 0.95,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _StatRow(
                            label: 'Pending reviews',
                            value: '12',
                            icon: Icons.inbox_outlined,
                          ),
                          const Divider(height: 22, color: Colors.white24),
                          _StatRow(
                            label: 'Escalations',
                            value: '3',
                            icon: Icons.flag_outlined,
                          ),
                          const Divider(height: 22, color: Colors.white24),
                          _StatRow(
                            label: 'SLA on track',
                            value: '94%',
                            icon: Icons.timer_outlined,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: const Color(0xFF152238),
                            title: Text(
                              'Reset MFA?',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.95),
                              ),
                            ),
                            content: Text(
                              'Your next agent sign-in will use SMS verification again, then you can enroll MFA.',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.75),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: const Text('Reset MFA'),
                              ),
                            ],
                          ),
                        );
                        if (confirmed != true || !context.mounted) return;
                        await ref
                            .read(agentAuthStorageProvider)
                            .resetMfaEnrollment();
                        if (!context.mounted) return;
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                      icon: const Icon(Icons.phonelink_erase_rounded, size: 20),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Reset MFA'),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white.withValues(alpha: 0.88),
                        side: BorderSide(
                          color: FuturisticAuthTheme.cyanGlow.withValues(
                            alpha: 0.45,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () async {
                        await ref
                            .read(agentAuthStorageProvider)
                            .clearAgentSession();
                        if (!context.mounted) return;
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                      icon: const Icon(Icons.logout_rounded, size: 20),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Sign out'),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white.withValues(alpha: 0.88),
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.35),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
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

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.55), size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withValues(alpha: 0.78),
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.95),
          ),
        ),
      ],
    );
  }
}
