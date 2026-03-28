import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kifiya_rendering_engine_example/core/di/injection.dart';
import 'package:kifiya_rendering_engine_example/passkey/futuristic_auth_theme.dart';
import 'package:kifiya_rendering_engine_example/passkey/passkey_mfa_verify_screen.dart';
import 'package:kifiya_rendering_engine_example/passkey/passkey_otp_screen.dart';

/// Sign-in: password → SMS OTP [first login only] or MFA handshake + code [after].
class PasskeyLoginScreen extends ConsumerStatefulWidget {
  const PasskeyLoginScreen({super.key});

  @override
  ConsumerState<PasskeyLoginScreen> createState() => _PasskeyLoginScreenState();
}

class _PasskeyLoginScreenState extends ConsumerState<PasskeyLoginScreen> {
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _obscure = true;
  var _signingIn = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _signingIn = true);
    await Future<void>.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;
    setState(() => _signingIn = false);
    final raw = _phoneCtrl.text.replaceAll(RegExp(r'\D'), '');
    final firstLoginDone = ref
        .read(agentAuthStorageProvider)
        .hasCompletedFirstLogin;
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => firstLoginDone
            ? PasskeyMfaVerifyScreen(phoneDigits: raw)
            : PasskeyOtpScreen(phoneDigits: raw),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: FuturisticAuthTheme.overlayStyle,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1320),
        body: Stack(
          fit: StackFit.expand,
          children: [
            FuturisticAuthTheme.background(),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 8,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: IconButton.styleFrom(
                            foregroundColor: Colors.white.withValues(
                              alpha: 0.9,
                            ),
                          ),
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: FuturisticAuthTheme.accent.withValues(
                                alpha: 0.2,
                              ),
                              border: Border.all(
                                color: FuturisticAuthTheme.cyanGlow.withValues(
                                  alpha: 0.45,
                                ),
                              ),
                            ),
                            child: const Icon(
                              Icons.lock_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sign in',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.4,
                                    color: Colors.white.withValues(alpha: 0.96),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Use your work phone number and password.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    height: 1.3,
                                    color: Colors.white.withValues(alpha: 0.55),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      FuturisticAuthTheme.glassPanel(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Credentials',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.6,
                                color: FuturisticAuthTheme.cyanGlow.withValues(
                                  alpha: 0.95,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _phoneCtrl,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                letterSpacing: 0.5,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[\d+\s\-]'),
                                ),
                                LengthLimitingTextInputFormatter(18),
                              ],
                              decoration: FuturisticAuthTheme.fieldDecoration(
                                label: 'Phone',
                                hint: '+251 9XX XXX XXX',
                                prefix: Icon(
                                  Icons.phone_android_rounded,
                                  color: Colors.white.withValues(alpha: 0.55),
                                  size: 22,
                                ),
                              ),
                              validator: (v) {
                                final d = (v ?? '').replaceAll(
                                  RegExp(r'\D'),
                                  '',
                                );
                                if (d.length < 9) {
                                  return 'Enter a valid phone number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _passwordCtrl,
                              obscureText: _obscure,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              decoration:
                                  FuturisticAuthTheme.fieldDecoration(
                                    label: 'Password',
                                    hint: '••••••••',
                                    prefix: Icon(
                                      Icons.lock_outline_rounded,
                                      color: Colors.white.withValues(
                                        alpha: 0.55,
                                      ),
                                      size: 22,
                                    ),
                                  ).copyWith(
                                    suffixIcon: IconButton(
                                      onPressed: () =>
                                          setState(() => _obscure = !_obscure),
                                      icon: Icon(
                                        _obscure
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: Colors.white.withValues(
                                          alpha: 0.45,
                                        ),
                                      ),
                                    ),
                                  ),
                              validator: (v) {
                                if ((v ?? '').length < 8) {
                                  return 'Password must be at least 8 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 22),
                            FilledButton(
                              onPressed: _signingIn ? null : _continue,
                              style: FilledButton.styleFrom(
                                backgroundColor: FuturisticAuthTheme.accent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: _signingIn
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.4,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Continue to verification',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          'After your first sign-in, multi-factor authentication secures your account.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
