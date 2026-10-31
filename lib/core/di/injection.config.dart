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
import '../../features/home/data/home_api.dart' as _i773;
import '../../features/home/data/home_remote_data_source.dart' as _i286;
import '../../features/home/data/home_repository_impl.dart' as _i939;
import '../../features/home/data/local_home_repository.dart' as _i239;
import '../../features/home/di/home_module.dart' as _i704;
import '../../features/home/domain/repositories/home_repository.dart' as _i0;
import '../../features/home/domain/usecases/load_home_usecase.dart' as _i261;
import '../../features/home/presentation/home_cubit.dart' as _i982;
import '../../features/main_layout/presentation/main_layout_cubit.dart' as _i43;
import '../../features/onboarding/data/local_onboarding_repository.dart'
    as _i742;
import '../../features/onboarding/data/onboarding_api.dart' as _i735;
import '../../features/onboarding/data/onboarding_remote_data_source.dart'
    as _i349;
import '../../features/onboarding/data/onboarding_repository_impl.dart'
    as _i624;
import '../../features/onboarding/di/onboarding_module.dart' as _i568;
import '../../features/onboarding/domain/repositories/onboarding_repository.dart'
    as _i430;
import '../../features/onboarding/domain/usecases/complete_onboarding_usecase.dart'
    as _i360;
import '../../features/onboarding/domain/usecases/get_currencies_usecase.dart'
    as _i305;
import '../../features/onboarding/domain/usecases/preview_onboarding_usecase.dart'
    as _i1036;
import '../../features/onboarding/presentation/onboarding_cubit.dart' as _i161;
import '../id/id_generator.dart' as _i1000;
import '../network/auth_interceptor.dart' as _i908;
import '../network/device_id_provider.dart' as _i46;
import '../network/dio_factory.dart' as _i798;
import '../network/headers_interceptor.dart' as _i426;
import '../network/token_provider.dart' as _i853;
import '../session/session_expiry_notifier.dart' as _i838;
import '../storage/token_storage.dart' as _i973;
import '../time/clock.dart' as _i807;
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
    final homeModule = _$HomeModule();
    final onboardingModule = _$OnboardingModule();
    gh.factory<_i43.MainLayoutCubit>(() => _i43.MainLayoutCubit());
    gh.singleton<_i558.FlutterSecureStorage>(() => networkModule.storage());
    gh.singleton<_i838.SessionExpiryNotifier>(
      () => _i838.SessionExpiryNotifier(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i1000.IdGenerator>(() => _i1000.IdGenerator());
    gh.lazySingleton<_i807.Clock>(() => _i807.Clock());
    gh.singleton<_i46.DeviceIdProvider>(
      () => networkModule.deviceIdProvider(gh<_i558.FlutterSecureStorage>()),
    );
    gh.singleton<_i973.TokenStorage>(
      () => _i973.TokenStorage(gh<_i558.FlutterSecureStorage>()),
    );
    gh.factory<_i239.LocalHomeRepository>(
      () => _i239.LocalHomeRepository(gh<_i807.Clock>()),
    );
    gh.factory<_i742.LocalOnboardingRepository>(
      () => _i742.LocalOnboardingRepository(gh<_i807.Clock>()),
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
    gh.lazySingleton<_i773.HomeApi>(
      () => _i773.HomeApi(gh<_i361.Dio>(instanceName: 'api')),
    );
    gh.lazySingleton<_i735.OnboardingApi>(
      () => _i735.OnboardingApi(gh<_i361.Dio>(instanceName: 'api')),
    );
    gh.singleton<_i361.Dio>(
      () => networkModule.authDio(gh<_i798.DioFactory>()),
      instanceName: 'auth',
    );
    gh.lazySingleton<_i936.AuthApi>(
      () => _i936.AuthApi(gh<_i361.Dio>(instanceName: 'auth')),
    );
    gh.factory<_i286.HomeRemoteDataSource>(
      () => _i286.HomeRemoteDataSourceImpl(gh<_i773.HomeApi>()),
    );
    gh.factory<_i939.HomeRepositoryImpl>(
      () => _i939.HomeRepositoryImpl(gh<_i286.HomeRemoteDataSource>()),
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
    gh.factory<_i349.OnboardingRemoteDataSource>(
      () => _i349.OnboardingRemoteDataSourceImpl(gh<_i735.OnboardingApi>()),
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
    gh.factory<_i624.OnboardingRepositoryImpl>(
      () => _i624.OnboardingRepositoryImpl(
        gh<_i349.OnboardingRemoteDataSource>(),
      ),
    );
    gh.factory<_i0.HomeRepository>(
      () => homeModule.repository(
        gh<_i939.HomeRepositoryImpl>(),
        gh<_i239.LocalHomeRepository>(),
      ),
    );
    gh.factory<_i261.LoadHomeUseCase>(
      () => _i261.LoadHomeUseCase(gh<_i0.HomeRepository>()),
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
    gh.factory<_i430.OnboardingRepository>(
      () => onboardingModule.repository(
        gh<_i624.OnboardingRepositoryImpl>(),
        gh<_i742.LocalOnboardingRepository>(),
      ),
    );
    gh.factory<_i360.CompleteOnboardingUseCase>(
      () => _i360.CompleteOnboardingUseCase(gh<_i430.OnboardingRepository>()),
    );
    gh.factory<_i305.GetCurrenciesUseCase>(
      () => _i305.GetCurrenciesUseCase(gh<_i430.OnboardingRepository>()),
    );
    gh.factory<_i1036.PreviewOnboardingUseCase>(
      () => _i1036.PreviewOnboardingUseCase(gh<_i430.OnboardingRepository>()),
    );
    gh.factory<_i982.HomeCubit>(
      () => _i982.HomeCubit(gh<_i261.LoadHomeUseCase>(), gh<_i807.Clock>()),
    );
    gh.factory<_i161.OnboardingCubit>(
      () => _i161.OnboardingCubit(
        gh<_i305.GetCurrenciesUseCase>(),
        gh<_i1036.PreviewOnboardingUseCase>(),
        gh<_i360.CompleteOnboardingUseCase>(),
        gh<_i1000.IdGenerator>(),
        gh<_i807.Clock>(),
      ),
    );
    return this;
  }
}

class _$NetworkModule extends _i567.NetworkModule {}

class _$AuthModule extends _i433.AuthModule {}

class _$HomeModule extends _i704.HomeModule {}

class _$OnboardingModule extends _i568.OnboardingModule {}
