import 'package:equatable/equatable.dart';

import '../../../core/error/failure.dart';
import '../../../core/money/money_currency.dart';
import '../domain/entities/cycle_summary.dart';
import '../domain/entities/home_profile.dart';
import '../domain/entities/recent_expense.dart';
import '../domain/entities/savings_overview.dart';
import '../domain/entities/upcoming_obligation.dart';

enum HomeStatus { loading, ready, failure }

final class HomeSection<T> extends Equatable {
  const HomeSection({this.data, this.failure});

  final T? data;
  final Failure? failure;

  bool get hasData => data != null;

  @override
  List<Object?> get props => [data, failure];
}

final class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.loading,
    this.isRefreshing = false,
    this.summary,
    this.failure,
    this.today,
    this.currency = MoneyCurrency.fallback,
    this.profile = const HomeSection(),
    this.savings = const HomeSection(),
    this.obligations = const HomeSection(),
    this.expenses = const HomeSection(),
  });

  final HomeStatus status;
  final bool isRefreshing;
  final CycleSummary? summary;
  final Failure? failure;
  final DateTime? today;
  final MoneyCurrency currency;
  final HomeSection<HomeProfile> profile;
  final HomeSection<SavingsOverview> savings;
  final HomeSection<List<UpcomingObligation>> obligations;
  final HomeSection<List<RecentExpense>> expenses;

  bool get hasPendingReview =>
      (summary?.hasPendingReview ?? false) ||
      (profile.data?.hasPendingReview ?? false);

  HomeState copyWith({
    HomeStatus? status,
    bool? isRefreshing,
    CycleSummary? summary,
    Failure? failure,
    DateTime? today,
    MoneyCurrency? currency,
    HomeSection<HomeProfile>? profile,
    HomeSection<SavingsOverview>? savings,
    HomeSection<List<UpcomingObligation>>? obligations,
    HomeSection<List<RecentExpense>>? expenses,
    bool clearFailure = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      summary: summary ?? this.summary,
      failure: clearFailure ? null : failure ?? this.failure,
      today: today ?? this.today,
      currency: currency ?? this.currency,
      profile: profile ?? this.profile,
      savings: savings ?? this.savings,
      obligations: obligations ?? this.obligations,
      expenses: expenses ?? this.expenses,
    );
  }

  @override
  List<Object?> get props => [
    status,
    isRefreshing,
    summary,
    failure,
    today,
    currency,
    profile,
    savings,
    obligations,
    expenses,
  ];
}
