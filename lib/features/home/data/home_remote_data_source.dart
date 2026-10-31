import 'package:injectable/injectable.dart';

import '../../../core/constants/api_home_values.dart';
import 'home_api.dart';
import 'models/cycle_summary_dto.dart';
import 'models/expenses_page_dto.dart';
import 'models/home_profile_dto.dart';
import 'models/obligations_page_dto.dart';
import 'models/pockets_dto.dart';

abstract interface class HomeRemoteDataSource {
  Future<CycleSummaryDto> getCycleSummary();

  Future<HomeProfileDto> getProfile();

  Future<PocketsDto> getPockets();

  Future<ObligationsPageDto> getUpcomingObligations({required int limit});

  Future<ExpensesPageDto> getRecentExpenses({required int limit});
}

@Injectable(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl(HomeApi api) : _api = api;

  final HomeApi _api;

  @override
  Future<CycleSummaryDto> getCycleSummary() async =>
      (await _api.getCycleSummary()).data.summary;

  @override
  Future<HomeProfileDto> getProfile() async => (await _api.getProfile()).data;

  @override
  Future<PocketsDto> getPockets() async => (await _api.getPockets()).data;

  @override
  Future<ObligationsPageDto> getUpcomingObligations({required int limit}) async =>
      (await _api.getObligations(ApiHomeValues.upcomingView, limit)).data;

  @override
  Future<ExpensesPageDto> getRecentExpenses({required int limit}) async =>
      (await _api.getExpenses(limit)).data;
}
