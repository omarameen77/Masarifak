import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../entities/login_result.dart';
import '../repositories/auth_repository.dart';
import '_post_auth.dart';

@injectable
class RestoreAccountUseCase {
  RestoreAccountUseCase(AuthRepository repository) : _repository = repository;

  final AuthRepository _repository;

  Future<Result<LoginResult>> call({required String restoreToken}) async =>
      completePostAuth(
        _repository,
        await _repository.restoreAccount(restoreToken: restoreToken),
      );
}
