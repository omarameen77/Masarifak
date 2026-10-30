import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/di/injection.dart';
import 'package:masarifak/features/auth/domain/repositories/auth_repository.dart';
import 'package:masarifak/features/auth/domain/usecases/login_usecase.dart';
import 'package:masarifak/features/auth/presentation/login/login_cubit.dart';
import 'package:masarifak/features/auth/presentation/session/session_cubit.dart';

void main() {
  setUp(configureDependencies);

  tearDown(getIt.reset);

  test('resolves the auth graph', () {
    expect(getIt<LoginCubit>(), isA<LoginCubit>());
    expect(getIt<AuthRepository>(), isA<AuthRepository>());
    expect(getIt<LoginUseCase>(), isA<LoginUseCase>());
    expect(getIt<FlutterSecureStorage>(), isA<FlutterSecureStorage>());
  });

  test('SessionCubit is a singleton', () {
    expect(identical(getIt<SessionCubit>(), getIt<SessionCubit>()), isTrue);
  });

  test('LoginCubit is a new instance per resolve', () {
    expect(identical(getIt<LoginCubit>(), getIt<LoginCubit>()), isFalse);
  });
}
