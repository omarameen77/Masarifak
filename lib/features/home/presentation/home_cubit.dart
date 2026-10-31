import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/result/result.dart';
import '../../../core/time/clock.dart';
import '../domain/entities/home_snapshot.dart';
import '../domain/usecases/load_home_usecase.dart';
import 'home_intent.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(LoadHomeUseCase loadHome, Clock clock)
    : _loadHome = loadHome,
      _clock = clock,
      super(const HomeState());

  final LoadHomeUseCase _loadHome;
  final Clock _clock;
  bool _isLoading = false;

  void doEvent(HomeIntent intent) {
    switch (intent) {
      case HomeStarted():
        _load(showSkeleton: true);
      case HomeRetried():
        _load(showSkeleton: state.summary == null);
      case HomeRefreshed():
        _load(showSkeleton: false);
    }
  }

  Future<void> _load({required bool showSkeleton}) async {
    if (_isLoading) return;
    _isLoading = true;
    emit(
      showSkeleton
          ? state.copyWith(status: HomeStatus.loading, clearFailure: true)
          : state.copyWith(isRefreshing: true, clearFailure: true),
    );
    final snapshot = await _loadHome();
    _isLoading = false;
    if (isClosed) return;
    emit(_apply(snapshot));
  }

  HomeState _apply(HomeSnapshot snapshot) {
    final now = _clock.now();
    var next = state.copyWith(
      isRefreshing: false,
      today: DateTime.utc(now.year, now.month, now.day),
      profile: _section(state.profile, snapshot.profile),
      savings: _section(state.savings, snapshot.savings),
      obligations: _section(state.obligations, snapshot.obligations),
    );
    switch (snapshot.expenses) {
      case Success(:final data):
        next = next.copyWith(
          currency: data.currency,
          expenses: HomeSection(data: data.items),
        );
      case Error(:final failure):
        next = next.copyWith(
          expenses: HomeSection(data: state.expenses.data, failure: failure),
        );
    }
    return switch (snapshot.summary) {
      Success(:final data) => next.copyWith(
        status: HomeStatus.ready,
        summary: data,
      ),
      Error(:final failure) => next.copyWith(
        status: state.summary == null ? HomeStatus.failure : HomeStatus.ready,
        failure: failure,
      ),
    };
  }

  HomeSection<T> _section<T>(HomeSection<T> current, Result<T> result) =>
      switch (result) {
        Success(:final data) => HomeSection(data: data),
        Error(:final failure) => HomeSection(
          data: current.data,
          failure: failure,
        ),
      };
}
