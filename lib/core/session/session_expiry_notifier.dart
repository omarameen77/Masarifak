import 'dart:async';

import 'package:injectable/injectable.dart';

@singleton
class SessionExpiryNotifier {
  final StreamController<void> _controller = StreamController<void>.broadcast();

  Stream<void> get stream => _controller.stream;

  void notifyExpired() => _controller.add(null);

  @disposeMethod
  Future<void> dispose() => _controller.close();
}
