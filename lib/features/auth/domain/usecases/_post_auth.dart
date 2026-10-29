import '../../../../core/result/result.dart';
import '../entities/login_outcome.dart';
import '../entities/login_result.dart';
import '../repositories/auth_repository.dart';

Future<Result<LoginResult>> completePostAuth(
  AuthRepository repository,
  Result<LoginOutcome> authResult,
) async {
  switch (authResult) {
    case Error(:final failure):
      return Error(failure);
    case Success(data: final outcome):
      switch (await repository.isOnboarded()) {
        case Success(data: final onboarded):
          return Success(
            LoginResult(
              session: outcome.session,
              flags: outcome.flags,
              onboarded: onboarded,
            ),
          );
        case Error(:final failure):
          await repository.clearSession();
          return Error(failure);
      }
  }
}
