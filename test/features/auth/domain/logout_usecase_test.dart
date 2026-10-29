import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/features/auth/domain/repositories/auth_repository.dart';
import 'package:masarifak/features/auth/domain/usecases/logout_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  test('logout calls clearSession once', () async {
    final repository = MockAuthRepository();
    when(() => repository.clearSession()).thenAnswer((_) async {});

    await LogoutUseCase(repository)();

    verify(() => repository.clearSession()).called(1);
    verifyNoMoreInteractions(repository);
  });
}
