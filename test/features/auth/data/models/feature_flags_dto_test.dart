import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/features/auth/data/models/feature_flags_dto.dart';
import 'package:masarifak/features/auth/domain/entities/feature_flags.dart';

FeatureFlags parse(String json) =>
    FeatureFlagsDto.fromJson(jsonDecode(json) as Map<String, dynamic>).toDomain();

void main() {
  test('reference example: enabled true maps to true', () {
    final flags = parse('{ "version": 14, "features": { "ask": { "enabled": true } } }');

    expect(flags, const FeatureFlags({'ask': true}));
    expect(flags.isEnabled('ask'), isTrue);
  });

  test('enabled missing or not a bool maps to false', () {
    final flags = parse(
      '{ "version": 14, "features": { "ask": {}, "caps": { "enabled": "yes" }, "export": true } }',
    );

    expect(flags, const FeatureFlags({'ask': false, 'caps': false, 'export': false}));
  });

  test('empty features map gives empty flags', () {
    expect(parse('{ "version": 14, "features": {} }'), const FeatureFlags.empty());
  });

  test('missing features key gives empty flags', () {
    expect(parse('{ "version": 14 }'), const FeatureFlags.empty());
  });
}
