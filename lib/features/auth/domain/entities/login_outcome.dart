import 'package:equatable/equatable.dart';

import 'auth_session.dart';
import 'feature_flags.dart';

class LoginOutcome extends Equatable {
  const LoginOutcome({required this.session, required this.flags});

  final AuthSession session;
  final FeatureFlags flags;

  @override
  List<Object?> get props => [session, flags];
}
