import '../../../../core/result/result.dart';
import 'cycle_summary.dart';
import 'home_profile.dart';
import 'recent_expense.dart';
import 'savings_overview.dart';
import 'upcoming_obligation.dart';

class HomeSnapshot {
  const HomeSnapshot({
    required this.summary,
    required this.profile,
    required this.savings,
    required this.obligations,
    required this.expenses,
  });

  final Result<CycleSummary> summary;
  final Result<HomeProfile> profile;
  final Result<SavingsOverview> savings;
  final Result<List<UpcomingObligation>> obligations;
  final Result<RecentExpenses> expenses;
}
