import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kifiya_rendering_engine_example/core/di/injection.dart';
import 'package:kifiya_rendering_engine_example/passkey/agent_home_screen.dart';
import 'package:kifiya_rendering_engine_example/passkey/futuristic_auth_theme.dart';
import 'package:kifiya_rendering_engine_example/passkey/mfa_processing_bottom_sheet.dart';

/// After [hasCompletedFirstLogin]: server handshake sheet, then same 6-digit UX as SMS OTP.
class PasskeyMfaVerifyScreen extends ConsumerStatefulWidget {
  const PasskeyMfaVerifyScreen({super.key, required this.phoneDigits});

  final String phoneDigits;

  @override
  ConsumerState<PasskeyMfaVerifyScreen> createState() =>
      _PasskeyMfaVerifyScreenState();
}

class _PasskeyMfaVerifyScreenState
    extends ConsumerState<PasskeyMfaVerifyScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  var _busy = false;
  var _handshakeComplete = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _runHandshake());
  }

  Future<void> _runHandshake() async {
    if (!mounted) return;
    await showMfaAuthenticationSheet(context, onComplete: () {});
    if (!mounted) return;
    setState(() => _handshakeComplete = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _maskedPhone {
    final d = widget.phoneDigits;
    if (d.length <= 4) return '••••';
    return '•••• ${d.substring(d.length - 4)}';
  }

  void _onDigitChanged(int index, String value) {
    if (value.length > 1) {
      final last = value.substring(value.length - 1);
      _controllers[index].text = last;
      _controllers[index].selection = TextSelection.collapsed(offset: 1);
    }
    if (value.isEmpty) {
      if (index > 0) _focusNodes[index - 1].requestFocus();
    } else if (index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    setState(() {});
  }

  Future<void> _verify() async {
    final entered = _controllers.map((c) => c.text).join();
    if (entered.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Enter the 6-digit code'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade800.withValues(alpha: 0.92),
        ),
      );
      return;
    }

    final expected = ref.read(agentAuthStorageProvider).savedMfaCode;
    if (expected == null || entered != expected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            expected == null
                ? 'Enrollment missing. Complete SMS verification on first sign-in.'
                : 'That code didn’t match. Try again.',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade800.withValues(alpha: 0.92),
        ),
      );
      return;
    }

    setState(() => _busy = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _busy = false);

    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (context) => const AgentHomeScreen()),
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
              child: !_handshakeComplete
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.8,
                              color: FuturisticAuthTheme.accent,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Establishing secure session…',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: _busy
                                  ? null
                                  : () => Navigator.of(context).pop(),
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
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(11),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: FuturisticAuthTheme.cyanGlow
                                      .withValues(alpha: 0.12),
                                  border: Border.all(
                                    color: FuturisticAuthTheme.cyanGlow
                                        .withValues(alpha: 0.35),
                                  ),
                                ),
                                child: Icon(
                                  Icons.shield_moon_rounded,
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
                                      'Verification code',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.4,
                                        color: Colors.white.withValues(
                                          alpha: 0.96,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'MFA step — same 6-digit entry as SMS. Account $_maskedPhone',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white.withValues(
                                          alpha: 0.55,
                                        ),
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
                                  'ENTER CODE',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2.4,
                                    color: FuturisticAuthTheme.accent
                                        .withValues(alpha: 0.95),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: List.generate(6, (i) {
                                    return Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: i == 0 ? 0 : 6,
                                          right: i == 5 ? 0 : 6,
                                        ),
                                        child: TextField(
                                          controller: _controllers[i],
                                          focusNode: _focusNodes[i],
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          maxLength: 1,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 2,
                                          ),
                                          buildCounter:
                                              (
                                                context, {
                                                required currentLength,
                                                required isFocused,
                                                maxLength,
                                              }) => null,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white.withValues(
                                              alpha: 0.06,
                                            ),
                                            counterText: '',
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  vertical: 14,
                                                ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              borderSide: BorderSide(
                                                color: Colors.white.withValues(
                                                  alpha: 0.2,
                                                ),
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              borderSide: BorderSide(
                                                color: Colors.white.withValues(
                                                  alpha: 0.2,
                                                ),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              borderSide: const BorderSide(
                                                color: FuturisticAuthTheme
                                                    .cyanGlow,
                                                width: 1.4,
                                              ),
                                            ),
                                          ),
                                          onChanged: (v) =>
                                              _onDigitChanged(i, v),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  'Enter your enrolled 6-digit security code.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.42),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                FilledButton(
                                  onPressed: _busy ? null : _verify,
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
                                  child: _busy
                                      ? const SizedBox(
                                          height: 22,
                                          width: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Continue to workspace',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ],
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
