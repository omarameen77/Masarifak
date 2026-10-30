import '../../../../core/constants/api_error_codes.dart';
import '../../../../core/constants/translation_keys.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_messages.dart';

bool isEmailTakenFailure(Failure failure) =>
    failure is ConflictFailure && failure.code == ApiErrorCodes.emailTaken;

String registerFailureKey(Failure failure) => isEmailTakenFailure(failure)
    ? TranslationKeys.validationEmailTaken
    : failureMessageKey(failure);
