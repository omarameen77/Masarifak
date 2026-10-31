import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../entities/login_result.dart';
import '../repositories/auth_repository.dart';
import '_post_auth.dart';

@injectable
class RegisterUseCase {
  RegisterUseCase(AuthRepository repository) : _repository = repository;

  final AuthRepository _repository;

  Future<Result<LoginResult>> call({
    required String name,
    required String email,
    required String password,
    required String locale,
    required String digits,
  }) async => completePostAuth(
    _repository,
    await _repository.register(
      name: name,
      email: email,
      password: password,
      locale: locale,
      digits: digits,
    ),
  );
}
