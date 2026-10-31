import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/theme/app_colors.dart';
import 'package:masarifak/core/theme/app_theme.dart';

void main() {
  test('page transitions are platform specific', () {
    final builders = AppTheme.build(AppColors.light).pageTransitionsTheme.builders;

    expect(
      builders[TargetPlatform.android],
      isA<FadeForwardsPageTransitionsBuilder>(),
    );
    expect(
      builders[TargetPlatform.iOS],
      isA<CupertinoPageTransitionsBuilder>(),
    );
  });
}
