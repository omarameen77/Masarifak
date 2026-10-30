import 'package:injectable/injectable.dart';

import '../../../core/constants/api_paths.dart';
import 'models/currency_dto.dart';
import 'models/onboarding_request.dart';
import 'models/onboarding_response_dto.dart';
import 'onboarding_api.dart';

abstract interface class OnboardingRemoteDataSource {
  Future<List<CurrencyDto>> getCurrencies();

  Future<OnboardingResponseDto> preview(OnboardingRequest request);

  Future<OnboardingResponseDto> complete(
    OnboardingRequest request, {
    required String idempotencyKey,
  });
}

@Injectable(as: OnboardingRemoteDataSource)
class OnboardingRemoteDataSourceImpl implements OnboardingRemoteDataSource {
  OnboardingRemoteDataSourceImpl(OnboardingApi api) : _api = api;

  final OnboardingApi _api;

  @override
  Future<List<CurrencyDto>> getCurrencies() async =>
      (await _api.getCurrencies()).data;

  @override
  Future<OnboardingResponseDto> preview(OnboardingRequest request) async =>
      (await _api.preview(request, ApiPaths.dryRunEnabled)).data;

  @override
  Future<OnboardingResponseDto> complete(
    OnboardingRequest request, {
    required String idempotencyKey,
  }) async => (await _api.complete(request, idempotencyKey)).data;
}
