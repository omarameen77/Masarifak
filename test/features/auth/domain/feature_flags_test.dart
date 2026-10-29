import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/features/auth/domain/entities/feature_flags.dart';

void main() {
  const enabledKey = 'ask';
  const disabledKey = 'export';
  const missingKey = 'savings';
  const flags = FeatureFlags({enabledKey: true, disabledKey: false});

  test('isEnabled returns false for a missing key', () {
    expect(flags.isEnabled(missingKey), isFalse);
  });

  test('isEnabled returns true for an enabled key and false for a disabled one', () {
    expect(flags.isEnabled(enabledKey), isTrue);
    expect(flags.isEnabled(disabledKey), isFalse);
  });

  test('empty() has no keys and enables nothing', () {
    const empty = FeatureFlags.empty();

    expect(empty.values, isEmpty);
    expect(empty.isEnabled(enabledKey), isFalse);
  });
}
