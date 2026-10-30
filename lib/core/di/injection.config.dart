// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/auth_api.dart' as _i936;
import '../../features/auth/data/auth_remote_data_source.dart' as _i767;
import '../../features/auth/data/auth_repository_impl.dart' as _i781;
import '../../features/auth/data/profile_api.dart' as _i86;
import '../../features/auth/di/auth_module.dart' as _i433;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/logout_usecase.dart' as _i48;
import '../../features/auth/domain/usecases/register_usecase.dart' as _i941;
import '../../features/auth/domain/usecases/restore_account_usecase.dart'
    as _i272;
import '../../features/auth/presentation/login/login_cubit.dart' as _i644;
import '../../features/auth/presentation/register/register_cubit.dart' as _i837;
import '../../features/auth/presentation/session/profile_onboarded_loader.dart'
    as _i330;
import '../../features/auth/presentation/session/session_cubit.dart' as _i371;
import '../network/auth_interceptor.dart' as _i908;
import '../network/device_id_provider.dart' as _i46;
import '../network/dio_factory.dart' as _i798;
import '../network/headers_interceptor.dart' as _i426;
import '../network/token_provider.dart' as _i853;
import '../session/session_expiry_notifier.dart' as _i838;
import '../storage/token_storage.dart' as _i973;
import 'network_module.dart' as _i567;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    final authModule = _$AuthModule();
    gh.singleton<_i558.FlutterSecureStorage>(() => networkModule.storage());
    gh.singleton<_i838.SessionExpiryNotifier>(
      () => _i838.SessionExpiryNotifier(),
      dispose: (i) => i.dispose(),
    );
    gh.singleton<_i46.DeviceIdProvider>(
      () => networkModule.deviceIdProvider(gh<_i558.FlutterSecureStorage>()),
    );
    gh.singleton<_i973.TokenStorage>(
      () => _i973.TokenStorage(gh<_i558.FlutterSecureStorage>()),
    );
    gh.singleton<_i426.HeadersInterceptor>(
      () => networkModule.headersInterceptor(gh<_i46.DeviceIdProvider>()),
    );
    gh.singleton<_i853.TokenProvider>(
      () => networkModule.tokenProvider(gh<_i973.TokenStorage>()),
    );
    gh.factory<_i908.AuthInterceptor>(
      () => _i908.AuthInterceptor(
        gh<_i853.TokenProvider>(),
        gh<_i838.SessionExpiryNotifier>(),
      ),
    );
    gh.singleton<_i798.DioFactory>(
      () => networkModule.dioFactory(
        gh<_i426.HeadersInterceptor>(),
        gh<_i908.AuthInterceptor>(),
      ),
    );
    gh.singleton<_i361.Dio>(
      () => networkModule.apiDio(gh<_i798.DioFactory>()),
      instanceName: 'api',
    );
    gh.lazySingleton<_i86.ProfileApi>(
      () => _i86.ProfileApi(gh<_i361.Dio>(instanceName: 'api')),
    );
    gh.singleton<_i361.Dio>(
      () => networkModule.authDio(gh<_i798.DioFactory>()),
      instanceName: 'auth',
    );
    gh.lazySingleton<_i936.AuthApi>(
      () => _i936.AuthApi(gh<_i361.Dio>(instanceName: 'auth')),
    );
    gh.factory<_i767.AuthRemoteDataSource>(
      () => _i767.AuthRemoteDataSourceImpl(
        gh<_i936.AuthApi>(),
        gh<_i86.ProfileApi>(),
      ),
    );
    gh.factory<_i787.AuthRepository>(
      () => _i781.AuthRepositoryImpl(
        gh<_i767.AuthRemoteDataSource>(),
        gh<_i973.TokenStorage>(),
      ),
    );
    gh.factory<_i330.ProfileOnboardedLoader>(
      () => authModule.profileOnboarded(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i188.LoginUseCase>(
      () => _i188.LoginUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i48.LogoutUseCase>(
      () => _i48.LogoutUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i941.RegisterUseCase>(
      () => _i941.RegisterUseCase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i272.RestoreAccountUseCase>(
      () => _i272.RestoreAccountUseCase(gh<_i787.AuthRepository>()),
    );
    gh.singleton<_i371.SessionCubit>(
      () => _i371.SessionCubit(
        tokenStorage: gh<_i973.TokenStorage>(),
        profileOnboarded: gh<_i330.ProfileOnboardedLoader>(),
        sessionExpiryNotifier: gh<_i838.SessionExpiryNotifier>(),
      ),
      dispose: (i) => i.close(),
    );
    gh.factory<_i837.RegisterCubit>(
      () => _i837.RegisterCubit(gh<_i941.RegisterUseCase>()),
    );
    gh.factory<_i644.LoginCubit>(
      () => _i644.LoginCubit(gh<_i188.LoginUseCase>()),
    );
    return this;
  }
}

class _$NetworkModule extends _i567.NetworkModule {}

class _$AuthModule extends _i433.AuthModule {}
