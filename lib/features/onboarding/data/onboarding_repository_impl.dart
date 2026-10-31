import 'package:injectable/injectable.dart';

import '../../../core/network/guard_request.dart';
import '../../../core/result/result.dart';
import '../domain/entities/currency.dart';
import '../domain/entities/onboarding_draft.dart';
import '../domain/entities/onboarding_result.dart';
import '../domain/repositories/onboarding_repository.dart';
import 'models/onboarding_request.dart';
import 'onboarding_remote_data_source.dart';

@injectable
class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(OnboardingRemoteDataSource remote) : _remote = remote;

  final OnboardingRemoteDataSource _remote;

  @override
  Future<Result<List<Currency>>> getCurrencies() => guardRequest(
    () async => (await _remote.getCurrencies())
        .map((currency) => currency.toDomain())
        .toList(),
  );

  @override
  Future<Result<OnboardingResult>> preview(OnboardingDraft draft) =>
      guardRequest(
        () async =>
            (await _remote.preview(OnboardingRequest.fromDraft(draft)))
                .toDomain(),
      );

  @override
  Future<Result<OnboardingResult>> complete(
    OnboardingDraft draft, {
    required String idempotencyKey,
  }) => guardRequest(
    () async => (await _remote.complete(
      OnboardingRequest.fromDraft(draft),
      idempotencyKey: idempotencyKey,
    )).toDomain(),
  );
}
