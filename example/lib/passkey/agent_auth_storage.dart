import 'package:hive_flutter/hive_flutter.dart';

/// Persists agent first-login (SMS OTP once) and enrolled MFA code on device.
class AgentAuthStorage {
  AgentAuthStorage(this._box);

  final Box<String> _box;

  static const kMfaEnrolled = 'agent_mfa_enrolled';
  static const kFirstOtp = 'agent_first_otp_code';
  static const kFirstLoginCompleted = 'agent_first_login_completed';

  /// True after the first successful SMS OTP and MFA enrollment (not credential-specific).
  bool get hasCompletedFirstLogin {
    if (_box.get(kFirstLoginCompleted) == 'true') return true;
    // Legacy installs that only stored enrollment flags.
    return isMfaEnrolled;
  }

  bool get isMfaEnrolled => _box.get(kMfaEnrolled) == 'true';

  String? get savedMfaCode => _box.get(kFirstOtp);

  Future<void> saveFirstOtpAndEnrollMfa(String sixDigitCode) async {
    await _box.put(kFirstOtp, sixDigitCode);
    await _box.put(kMfaEnrolled, 'true');
    await _box.put(kFirstLoginCompleted, 'true');
  }

  /// Clears MFA enrollment so the next sign-in uses SMS OTP again (first-login path).
  Future<void> resetMfaEnrollment() async {
    await _box.delete(kFirstLoginCompleted);
    await _box.delete(kMfaEnrolled);
    await _box.delete(kFirstOtp);
  }

  /// Full sign-out: same as reset for stored agent auth on this device.
  Future<void> clearAgentSession() async {
    await resetMfaEnrollment();
  }
}
