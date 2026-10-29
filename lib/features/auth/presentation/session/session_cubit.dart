import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/feature_flags.dart';
import 'session_state.dart';

typedef ProfileOnboardedLoader = Future<Result<bool>> Function();

class SessionCubit extends Cubit<SessionState> {
  SessionCubit({
    required TokenStorage tokenStorage,
    required ProfileOnboardedLoader profileOnboarded,
  }) : _tokenStorage = tokenStorage,
       _profileOnboarded = profileOnboarded,
       super(const SessionUnknown());

  final TokenStorage _tokenStorage;
  final ProfileOnboardedLoader _profileOnboarded;
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

  Future<void> logout() async {
    await _tokenStorage.clear();
    _signedOut();
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
    emit(const SessionSignedOut());
  }
}
