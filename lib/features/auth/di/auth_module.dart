import 'package:injectable/injectable.dart';

import '../domain/repositories/auth_repository.dart';
import '../presentation/session/profile_onboarded_loader.dart';

@module
abstract class AuthModule {
  @injectable
  ProfileOnboardedLoader profileOnboarded(AuthRepository repository) =>
      ProfileOnboardedLoader(repository.isOnboarded);
}
