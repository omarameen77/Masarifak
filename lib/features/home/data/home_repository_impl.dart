import 'package:injectable/injectable.dart';

import '../../../core/network/guard_request.dart';
import '../../../core/result/result.dart';
import '../domain/entities/cycle_summary.dart';
import '../domain/entities/home_profile.dart';
import '../domain/entities/recent_expense.dart';
import '../domain/entities/savings_overview.dart';
import '../domain/entities/upcoming_obligation.dart';
import '../domain/repositories/home_repository.dart';
import 'home_remote_data_source.dart';

@injectable
class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(HomeRemoteDataSource remote) : _remote = remote;

  final HomeRemoteDataSource _remote;

  @override
  Future<Result<CycleSummary>> getCycleSummary() =>
      guardRequest(() async => (await _remote.getCycleSummary()).toDomain());

  @override
  Future<Result<HomeProfile>> getProfile() =>
      guardRequest(() async => (await _remote.getProfile()).toDomain());

  @override
  Future<Result<SavingsOverview>> getSavings() =>
      guardRequest(() async => (await _remote.getPockets()).toDomain());

  @override
  Future<Result<List<UpcomingObligation>>> getUpcomingObligations({
    required int limit,
  }) => guardRequest(
    () async =>
        (await _remote.getUpcomingObligations(limit: limit)).toDomain(limit),
  );

  @override
  Future<Result<RecentExpenses>> getRecentExpenses({required int limit}) =>
      guardRequest(
        () async => (await _remote.getRecentExpenses(limit: limit)).toDomain(),
      );
}
