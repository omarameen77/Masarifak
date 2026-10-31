import '../../../../core/result/result.dart';

class ProfileOnboardedLoader {
  const ProfileOnboardedLoader(Future<Result<bool>> Function() load)
    : _load = load;

  final Future<Result<bool>> Function() _load;

  Future<Result<bool>> call() => _load();
}
