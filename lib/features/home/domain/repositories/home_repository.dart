import '../../../../core/result/result.dart';
import '../entities/cycle_summary.dart';
import '../entities/home_profile.dart';
import '../entities/recent_expense.dart';
import '../entities/savings_overview.dart';
import '../entities/upcoming_obligation.dart';

abstract interface class HomeRepository {
  Future<Result<CycleSummary>> getCycleSummary();

  Future<Result<HomeProfile>> getProfile();

  Future<Result<SavingsOverview>> getSavings();

  Future<Result<List<UpcomingObligation>>> getUpcomingObligations({
    required int limit,
  });

  Future<Result<RecentExpenses>> getRecentExpenses({required int limit});
}
