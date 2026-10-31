import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/constants/api_paths.dart';
import '../../../core/constants/di_names.dart';
import '../../../core/network/data_envelope.dart';
import 'models/cycle_summary_dto.dart';
import 'models/expenses_page_dto.dart';
import 'models/home_profile_dto.dart';
import 'models/obligations_page_dto.dart';
import 'models/pockets_dto.dart';

part 'home_api.g.dart';

@lazySingleton
@RestApi()
abstract class HomeApi {
  @factoryMethod
  factory HomeApi(@Named(DiNames.apiDio) Dio dio) = _HomeApi;

  @GET(ApiPaths.currentCycleSummary)
  Future<DataEnvelope<CycleSummaryResponseDto>> getCycleSummary();

  @GET(ApiPaths.profile)
  Future<DataEnvelope<HomeProfileDto>> getProfile();

  @GET(ApiPaths.pockets)
  Future<DataEnvelope<PocketsDto>> getPockets();

  @GET(ApiPaths.obligations)
  Future<DataEnvelope<ObligationsPageDto>> getObligations(
    @Query(ApiPaths.viewQuery) String view,
    @Query(ApiPaths.limitQuery) int limit,
  );

  @GET(ApiPaths.expenses)
  Future<DataEnvelope<ExpensesPageDto>> getExpenses(
    @Query(ApiPaths.limitQuery) int limit,
  );
}
