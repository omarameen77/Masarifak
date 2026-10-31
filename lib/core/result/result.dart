import 'package:equatable/equatable.dart';

import '../error/failure.dart';

sealed class Result<T> extends Equatable {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;

  @override
  List<Object?> get props => [data];
}

final class Error<T> extends Result<T> {
  const Error(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
