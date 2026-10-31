import 'package:equatable/equatable.dart';

import 'auth_session.dart';
import 'feature_flags.dart';

class LoginResult extends Equatable {
  const LoginResult({
    required this.session,
    required this.flags,
    required this.onboarded,
  });

  final AuthSession session;
  final FeatureFlags flags;
  final bool onboarded;

  @override
  List<Object?> get props => [session, flags, onboarded];
}
