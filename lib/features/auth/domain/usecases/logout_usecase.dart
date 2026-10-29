import '../repositories/auth_repository.dart';

class LogoutUseCase {
  LogoutUseCase(AuthRepository repository) : _repository = repository;

  final AuthRepository _repository;

  Future<void> call() => _repository.clearSession();
}
