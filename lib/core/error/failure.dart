import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

final class NetworkFailure extends Failure {
  const NetworkFailure();
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure();
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure();
}

final class RateLimitFailure extends Failure {
  const RateLimitFailure();
}

final class ValidationFailure extends Failure {
  const ValidationFailure(this.fields, {this.step});

  final Map<String, dynamic>? fields;
  final int? step;

  @override
  List<Object?> get props => [fields, step];
}

final class ConflictFailure extends Failure {
  const ConflictFailure(this.code);

  final String? code;

  @override
  List<Object?> get props => [code];
}

final class ServerFailure extends Failure {
  const ServerFailure();
}

final class UnknownFailure extends Failure {
  const UnknownFailure();
}
