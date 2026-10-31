import 'dart:io';

import 'package:flutter/foundation.dart';

abstract final class DevFlags {
  static const String skipAuthApiKey = 'SKIP_AUTH_API';
  static const String flutterTestKey = 'FLUTTER_TEST';
  static const String enabledValue = 'true';

  static bool get skipAuthApi {
    const fromDefine = String.fromEnvironment(skipAuthApiKey);
    if (fromDefine.isNotEmpty) return fromDefine == enabledValue;
    return !kReleaseMode && !Platform.environment.containsKey(flutterTestKey);
  }
}
