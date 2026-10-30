import '../../../../core/result/result.dart';
import '../entities/currency.dart';
import '../entities/onboarding_draft.dart';
import '../entities/onboarding_result.dart';

abstract interface class OnboardingRepository {
  Future<Result<List<Currency>>> getCurrencies();

  Future<Result<OnboardingResult>> preview(OnboardingDraft draft);

  Future<Result<OnboardingResult>> complete(
    OnboardingDraft draft, {
    required String idempotencyKey,
  });
}
