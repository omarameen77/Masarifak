import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/constants/api_headers.dart';
import '../../../core/constants/api_paths.dart';
import '../../../core/constants/di_names.dart';
import '../../../core/network/data_envelope.dart';
import 'models/currency_dto.dart';
import 'models/onboarding_request.dart';
import 'models/onboarding_response_dto.dart';

part 'onboarding_api.g.dart';

@lazySingleton
@RestApi()
abstract class OnboardingApi {
  @factoryMethod
  factory OnboardingApi(@Named(DiNames.apiDio) Dio dio) = _OnboardingApi;

  @GET(ApiPaths.currencies)
  Future<DataEnvelope<List<CurrencyDto>>> getCurrencies();

  @POST(ApiPaths.onboarding)
  Future<DataEnvelope<OnboardingResponseDto>> preview(
    @Body() OnboardingRequest request,
    @Query(ApiPaths.dryRunQuery) int dryRun,
  );

  @POST(ApiPaths.onboarding)
  Future<DataEnvelope<OnboardingResponseDto>> complete(
    @Body() OnboardingRequest request,
    @Header(ApiHeaders.idempotencyKey) String idempotencyKey,
  );
}
