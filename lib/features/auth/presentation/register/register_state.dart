import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/login_result.dart';

final class RegisterState extends Equatable {
  const RegisterState({
    this.isSubmitting = false,
    this.isPasswordVisible = false,
    this.hasSubmitted = false,
    this.failure,
    this.result,
  });

  final bool isSubmitting;
  final bool isPasswordVisible;
  final bool hasSubmitted;
  final Failure? failure;
  final LoginResult? result;

  RegisterState copyWith({
    bool? isSubmitting,
    bool? isPasswordVisible,
    bool? hasSubmitted,
    Failure? failure,
    LoginResult? result,
    bool clearFailure = false,
    bool clearResult = false,
  }) {
    return RegisterState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      failure: clearFailure ? null : failure ?? this.failure,
      result: clearResult ? null : result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [
    isSubmitting,
    isPasswordVisible,
    hasSubmitted,
    failure,
    result,
  ];
}
