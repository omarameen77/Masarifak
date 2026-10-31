import 'package:injectable/injectable.dart';

import '../../../core/constants/dev_flags.dart';
import '../data/home_repository_impl.dart';
import '../data/local_home_repository.dart';
import '../domain/repositories/home_repository.dart';

@module
abstract class HomeModule {
  @injectable
  HomeRepository repository(
    HomeRepositoryImpl remote,
    LocalHomeRepository local,
  ) => DevFlags.skipAuthApi ? local : remote;
}
