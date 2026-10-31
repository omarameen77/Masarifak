import 'package:injectable/injectable.dart';

import '../../../core/constants/dev_flags.dart';
import '../data/local_onboarding_repository.dart';
import '../data/onboarding_repository_impl.dart';
import '../domain/repositories/onboarding_repository.dart';

@module
abstract class OnboardingModule {
  @injectable
  OnboardingRepository repository(
    OnboardingRepositoryImpl remote,
    LocalOnboardingRepository local,
  ) => DevFlags.skipAuthApi ? local : remote;
}
