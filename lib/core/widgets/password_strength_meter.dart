import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../constants/app_durations.dart';
import '../theme/app_colors.dart';
import '../validation/password_strength.dart';

class PasswordStrengthMeter extends StatelessWidget {
  const PasswordStrengthMeter({super.key, required this.controller});

  final TextEditingController controller;

  static final int _barCount = PasswordStrengthLevel.values.length - 1;

  Color _fillColor(AppColors colors, PasswordStrengthLevel level) =>
      switch (level) {
        PasswordStrengthLevel.empty => colors.line,
        PasswordStrengthLevel.weak => colors.crit,
        PasswordStrengthLevel.fair => colors.warn,
        PasswordStrengthLevel.strong ||
        PasswordStrengthLevel.veryStrong => colors.acc,
      };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final strength = PasswordStrength.of(value.text);
        final fill = _fillColor(colors, strength.level);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.sm),
            ExcludeSemantics(
              child: Row(
                children: [
                  for (var i = 0; i < _barCount; i++) ...[
                    if (i > 0) const SizedBox(width: AppDimensions.xs),
                    Expanded(
                      child: AnimatedContainer(
                        duration: AppDurations.short,
                        height: AppDimensions.strengthBarHeight,
                        decoration: BoxDecoration(
                          color: i < strength.level.index ? fill : colors.line,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.strengthBarRadius,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.fieldLabelGap),
            Semantics(
              liveRegion: true,
              child: Text(
                strength.messageKey.tr(),
                style: TextStyle(
                  fontSize: AppDimensions.captionFontSize,
                  color: colors.muted,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
