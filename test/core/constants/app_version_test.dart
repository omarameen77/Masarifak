import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/constants/api_config.dart';

void main() {
  test('ApiConfig.appVersion matches the pubspec version before "+"', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final match = RegExp(r'^version:\s*([^+\s]+)', multiLine: true).firstMatch(pubspec);

    expect(match, isNotNull);
    expect(ApiConfig.appVersion, match!.group(1));
  });
}
