import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../entities/currency.dart';
import '../repositories/onboarding_repository.dart';

@injectable
class GetCurrenciesUseCase {
  GetCurrenciesUseCase(OnboardingRepository repository)
    : _repository = repository;

  final OnboardingRepository _repository;

  Future<Result<List<Currency>>> call() => _repository.getCurrencies();
}
