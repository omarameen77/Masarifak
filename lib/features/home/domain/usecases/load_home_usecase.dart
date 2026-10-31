import 'package:injectable/injectable.dart';

import '../../../../core/constants/home_defaults.dart';
import '../entities/home_snapshot.dart';
import '../repositories/home_repository.dart';

@injectable
class LoadHomeUseCase {
  LoadHomeUseCase(HomeRepository repository) : _repository = repository;

  final HomeRepository _repository;

  Future<HomeSnapshot> call() async {
    final (summary, profile, savings, obligations, expenses) = await (
      _repository.getCycleSummary(),
      _repository.getProfile(),
      _repository.getSavings(),
      _repository.getUpcomingObligations(limit: HomeDefaults.upcomingLimit),
      _repository.getRecentExpenses(limit: HomeDefaults.recentLimit),
    ).wait;
    return HomeSnapshot(
      summary: summary,
      profile: profile,
      savings: savings,
      obligations: obligations,
      expenses: expenses,
    );
  }
}
