import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/session/session_expiry_notifier.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/feature_flags.dart';
import 'profile_onboarded_loader.dart';
import 'session_state.dart';

@singleton
class SessionCubit extends Cubit<SessionState> {
  SessionCubit({
    required TokenStorage tokenStorage,
    required ProfileOnboardedLoader profileOnboarded,
    required SessionExpiryNotifier sessionExpiryNotifier,
  }) : _tokenStorage = tokenStorage,
       _profileOnboarded = profileOnboarded,
       super(const SessionUnknown()) {
    _expirySubscription = sessionExpiryNotifier.stream.listen(
      (_) => logout(),
    );
  }

  final TokenStorage _tokenStorage;
  final ProfileOnboardedLoader _profileOnboarded;
  late final StreamSubscription<void> _expirySubscription;
  FeatureFlags _flags = const FeatureFlags.empty();

  FeatureFlags get flags => _flags;

  Future<void> checkStartup() async {
    final token = await _tokenStorage.readAccessToken();
    if (token == null) {
      _signedOut();
      return;
    }
    await _resolveOnboarding(const FeatureFlags.empty());
  }

  Future<void> onSignedIn(AuthSession session, FeatureFlags flags) async {
    await _tokenStorage.saveSession(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
    await _resolveOnboarding(flags);
  }

  void completeOnboarding() => emit(SessionSignedIn(_flags));

  void enterOnboardingWithoutBackend() {
    _flags = const FeatureFlags.empty();
    emit(const SessionNeedsOnboarding());
  }

  Future<void> logout() async {
    await _tokenStorage.clear();
    _signedOut();
  }

  @disposeMethod
  @override
  Future<void> close() async {
    await _expirySubscription.cancel();
    return super.close();
  }

  Future<void> _resolveOnboarding(FeatureFlags flags) async {
    switch (await _profileOnboarded()) {
      case Success(data: true):
        _flags = flags;
        emit(SessionSignedIn(flags));
      case Success(data: false):
        _flags = flags;
        emit(const SessionNeedsOnboarding());
      case Error(:final failure):
        if (failure is UnauthorizedFailure) await _tokenStorage.clear();
        _signedOut();
    }
  }

  void _signedOut() {
    _flags = const FeatureFlags.empty();
    if (!isClosed) emit(const SessionSignedOut());
  }
}
