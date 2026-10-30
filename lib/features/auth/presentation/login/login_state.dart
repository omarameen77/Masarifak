import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/login_result.dart';

final class LoginState extends Equatable {
  const LoginState({
    this.isSubmitting = false,
    this.isPasswordVisible = false,
    this.failure,
    this.outcome,
  });

  final bool isSubmitting;
  final bool isPasswordVisible;
  final Failure? failure;
  final LoginResult? outcome;

  LoginState copyWith({
    bool? isSubmitting,
    bool? isPasswordVisible,
    Failure? failure,
    LoginResult? outcome,
    bool clearFailure = false,
    bool clearOutcome = false,
  }) {
    return LoginState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      failure: clearFailure ? null : failure ?? this.failure,
      outcome: clearOutcome ? null : outcome ?? this.outcome,
    );
  }

  @override
  List<Object?> get props => [isSubmitting, isPasswordVisible, failure, outcome];
}
