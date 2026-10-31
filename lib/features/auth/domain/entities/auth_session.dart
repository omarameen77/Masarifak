import 'package:equatable/equatable.dart';

import 'auth_user.dart';

class AuthSession extends Equatable {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresInSeconds,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final int expiresInSeconds;
  final AuthUser user;

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresInSeconds, user];
}
