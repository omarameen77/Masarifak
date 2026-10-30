import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/constants/api_error_codes.dart';
import '../../../core/error/failure.dart';
import '../../../core/id/id_generator.dart';
import '../../../core/result/result.dart';
import '../../../core/time/clock.dart';
import '../domain/entities/currency.dart';
import '../domain/usecases/complete_onboarding_usecase.dart';
import '../domain/usecases/get_currencies_usecase.dart';
import '../domain/usecases/preview_onboarding_usecase.dart';
import 'onboarding_intent.dart';
import 'onboarding_state.dart';

@injectable
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(
    GetCurrenciesUseCase getCurrencies,
    PreviewOnboardingUseCase previewOnboarding,
    CompleteOnboardingUseCase completeOnboarding,
    IdGenerator idGenerator,
    Clock clock,
  ) : _getCurrencies = getCurrencies,
      _previewOnboarding = previewOnboarding,
      _completeOnboarding = completeOnboarding,
      _idGenerator = idGenerator,
      _clock = clock,
      super(const OnboardingState());

  final GetCurrenciesUseCase _getCurrencies;
  final PreviewOnboardingUseCase _previewOnboarding;
  final CompleteOnboardingUseCase _completeOnboarding;
  final IdGenerator _idGenerator;
  final Clock _clock;
  String? _idempotencyKey;

  DateTime get today => _clock.now();

  void doEvent(OnboardingIntent intent) {
    switch (intent) {
      case OnboardingStarted():
        _loadCurrencies();
      case IncomeSubmitted(:final salaryMinor, :final payday):
        _updateDraft(state.copyWith(salaryMinor: salaryMinor, payday: payday));
      case ObligationAdded(:final obligation):
        _updateDraft(
          state.copyWith(
            obligations: [
              ...state.obligations,
              obligation.copyWith(clientId: _idGenerator.next()),
            ],
          ),
        );
      case ObligationUpdated(:final obligation):
        _updateDraft(
          state.copyWith(
            obligations: [
              for (final existing in state.obligations)
                existing.clientId == obligation.clientId ? obligation : existing,
            ],
          ),
        );
      case ObligationRemoved(:final clientId):
        _updateDraft(
          state.copyWith(
            obligations: state.obligations
                .where((obligation) => obligation.clientId != clientId)
                .toList(),
          ),
        );
      case SafetySubmitted(
        :final safetyBalanceMinor,
        :final savingsContributionMinor,
        :final spentSoFarMinor,
      ):
        _updateDraft(
          state.copyWith(
            safetyBalanceMinor: safetyBalanceMinor,
            savingsContributionMinor: savingsContributionMinor,
            spentSoFarMinor: spentSoFarMinor,
          ),
        );
      case PreviewRequested():
        _preview();
      case CompletionRequested():
        _complete();
    }
  }

  void _updateDraft(OnboardingState next) {
    _idempotencyKey = null;
    emit(next.copyWith(clearPreview: true, clearFailure: true));
  }

  Future<void> _loadCurrencies() async {
    final result = await _getCurrencies();
    if (isClosed) return;
    if (result case Success(:final data) when data.isNotEmpty) {
      emit(state.copyWith(currency: _pick(data)));
    }
  }

  Currency _pick(List<Currency> currencies) => currencies.firstWhere(
    (currency) => currency.code == state.currency.code,
    orElse: () => currencies.first,
  );

  Future<void> _preview() async {
    final draft = state.draft;
    if (draft == null || state.isPreviewing) return;
    emit(state.copyWith(isPreviewing: true, clearFailure: true));
    final result = await _previewOnboarding(draft);
    if (isClosed) return;
    switch (result) {
      case Success(:final data):
        emit(state.copyWith(isPreviewing: false, preview: data));
      case Error(:final failure):
        emit(state.copyWith(isPreviewing: false, failure: failure));
    }
  }

  Future<void> _complete() async {
    final draft = state.draft;
    if (draft == null || state.isCompleting || state.isCompleted) return;
    final key = _idempotencyKey ??= _idGenerator.next();
    emit(state.copyWith(isCompleting: true, clearFailure: true));
    final result = await _completeOnboarding(draft, idempotencyKey: key);
    if (isClosed) return;
    switch (result) {
      case Success():
        emit(state.copyWith(isCompleting: false, isCompleted: true));
      case Error(:final failure) when _isAlreadyOnboarded(failure):
        emit(state.copyWith(isCompleting: false, isCompleted: true));
      case Error(:final failure):
        emit(state.copyWith(isCompleting: false, failure: failure));
    }
  }

  bool _isAlreadyOnboarded(Failure failure) =>
      failure is ConflictFailure &&
      failure.code == ApiErrorCodes.alreadyOnboarded;
}
