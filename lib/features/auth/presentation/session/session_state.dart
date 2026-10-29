import 'package:equatable/equatable.dart';

import '../../domain/feature_flags.dart';

sealed class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => [];
}

final class SessionUnknown extends SessionState {
  const SessionUnknown();
}

final class SessionSignedOut extends SessionState {
  const SessionSignedOut();
}

final class SessionNeedsOnboarding extends SessionState {
  const SessionNeedsOnboarding();
}

final class SessionSignedIn extends SessionState {
  const SessionSignedIn(this.flags);

  final FeatureFlags flags;

  @override
  List<Object?> get props => [flags];
}
