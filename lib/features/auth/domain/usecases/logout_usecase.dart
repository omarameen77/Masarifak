import 'package:injectable/injectable.dart';

import '../repositories/auth_repository.dart';

@injectable
class LogoutUseCase {
  LogoutUseCase(AuthRepository repository) : _repository = repository;

  final AuthRepository _repository;

  Future<void> call() => _repository.clearSession();
}
