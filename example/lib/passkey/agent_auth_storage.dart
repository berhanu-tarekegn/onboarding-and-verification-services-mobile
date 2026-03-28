import 'package:hive_flutter/hive_flutter.dart';

/// Agent auth: first login submission → SMS OTP once; later submissions → MFA.
/// Routing does not use phone/password — only prior attempts + enrollment.
class AgentAuthStorage {
  AgentAuthStorage(this._box);

  final Box<String> _box;

  static const kMfaEnrolled = 'agent_mfa_enrolled';
  static const kFirstOtp = 'agent_first_otp_code';
  static const kFirstLoginCompleted = 'agent_first_login_completed';
  /// How many times the user has submitted the login form (Continue). Starts at 0.
  static const kLoginSubmitCount = 'agent_login_submit_count';

  /// True after SMS OTP succeeded and MFA enrollment finished.
  bool get hasCompletedFirstLogin {
    if (_box.get(kFirstLoginCompleted) == 'true') return true;
    return isMfaEnrolled;
  }

  bool get isMfaEnrolled => _box.get(kMfaEnrolled) == 'true';

  String? get savedMfaCode => _box.get(kFirstOtp);

  /// Number of times the user pressed Continue on the login screen (persisted).
  int get loginSubmitCount =>
      int.tryParse(_box.get(kLoginSubmitCount) ?? '0') ?? 0;

  Future<void> saveFirstOtpAndEnrollMfa(String sixDigitCode) async {
    await _box.putAll({
      kFirstOtp: sixDigitCode,
      kMfaEnrolled: 'true',
      kFirstLoginCompleted: 'true',
    });
    await _box.flush();
  }

  /// Call once per successful login validation, before navigating away from login.
  Future<void> recordLoginSubmit() async {
    final next = loginSubmitCount + 1;
    await _box.put(kLoginSubmitCount, '$next');
    await _box.flush();
  }

  /// Clears MFA enrollment so the next sign-in follows SMS OTP again.
  Future<void> resetMfaEnrollment() async {
    await _box.delete(kFirstLoginCompleted);
    await _box.delete(kMfaEnrolled);
    await _box.delete(kFirstOtp);
    await _box.delete(kLoginSubmitCount);
    await _box.flush();
  }

  Future<void> clearAgentSession() async {
    await resetMfaEnrollment();
  }
}
