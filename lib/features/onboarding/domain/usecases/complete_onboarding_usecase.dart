import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../entities/onboarding_draft.dart';
import '../entities/onboarding_result.dart';
import '../repositories/onboarding_repository.dart';

@injectable
class CompleteOnboardingUseCase {
  CompleteOnboardingUseCase(OnboardingRepository repository)
    : _repository = repository;

  final OnboardingRepository _repository;

  Future<Result<OnboardingResult>> call(
    OnboardingDraft draft, {
    required String idempotencyKey,
  }) => _repository.complete(draft, idempotencyKey: idempotencyKey);
}
