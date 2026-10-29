import '../../../../core/result/result.dart';
import '../entities/login_outcome.dart';
import '../entities/verified_email.dart';

abstract interface class AuthRepository {
  Future<Result<LoginOutcome>> login({
    required String email,
    required String password,
  });

  Future<Result<LoginOutcome>> restoreAccount({required String restoreToken});

  Future<Result<LoginOutcome>> register({
    required String name,
    required String email,
    required String password,
    required String locale,
    required String digits,
  });

  Future<Result<void>> requestPasswordReset({required String email});

  Future<Result<void>> resetPassword({
    required String token,
    required String password,
  });

  Future<Result<VerifiedEmail>> verifyEmail({required String token});

  Future<Result<void>> resendVerification();

  Future<Result<bool>> isOnboarded();

  Future<void> clearSession();
}
