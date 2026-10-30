import '../../../../core/constants/translation_keys.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_messages.dart';

String loginFailureKey(Failure failure) => switch (failure) {
  UnauthorizedFailure() => TranslationKeys.errorInvalidCredentials,
  _ => failureMessageKey(failure),
};
