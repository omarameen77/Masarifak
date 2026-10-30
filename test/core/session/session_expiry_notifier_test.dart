import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/session/session_expiry_notifier.dart';

void main() {
  test('notifyExpired emits exactly one event', () async {
    final notifier = SessionExpiryNotifier();
    final events = <void>[];
    final subscription = notifier.stream.listen(events.add);

    notifier.notifyExpired();
    await pumpEventQueue();

    expect(events, hasLength(1));
    await subscription.cancel();
    await notifier.dispose();
  });
}
