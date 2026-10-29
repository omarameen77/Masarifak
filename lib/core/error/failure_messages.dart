import '../constants/translation_keys.dart';
import 'failure.dart';

String failureMessageKey(Failure failure) => switch (failure) {
  NetworkFailure() => TranslationKeys.errorNetwork,
  TimeoutFailure() => TranslationKeys.errorTimeout,
  UnauthorizedFailure() => TranslationKeys.errorUnauthorized,
  RateLimitFailure() => TranslationKeys.errorRateLimit,
  ValidationFailure() => TranslationKeys.errorValidation,
  ConflictFailure() => TranslationKeys.errorConflict,
  ServerFailure() => TranslationKeys.errorServer,
  UnknownFailure() => TranslationKeys.errorUnknown,
};
