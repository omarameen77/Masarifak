import '../../../../core/result/result.dart';
import '../entities/login_result.dart';
import '../repositories/auth_repository.dart';
import '_post_auth.dart';

class LoginUseCase {
  LoginUseCase(AuthRepository repository) : _repository = repository;

  final AuthRepository _repository;

  Future<Result<LoginResult>> call({
    required String email,
    required String password,
  }) async => completePostAuth(
    _repository,
    await _repository.login(email: email, password: password),
  );
}
