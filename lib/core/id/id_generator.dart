import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@lazySingleton
class IdGenerator {
  String next() => const Uuid().v4();
}
