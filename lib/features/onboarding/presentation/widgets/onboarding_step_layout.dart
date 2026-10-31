import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/onboarding_args.dart';
import '../../../../core/constants/translation_keys.dart';
import '../../../../core/formatting/app_number_format.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_footer_bar.dart';

class OnboardingStepLayout extends StatelessWidget {
  const OnboardingStepLayout({
    super.key,
    required this.step,
    required this.totalSteps,
    required this.titleKey,
    this.leadKey,
    this.body,
    this.footer,
  });

  final int step;
  final int totalSteps;
  final String titleKey;
  final String? leadKey;
  final Widget? body;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final numbers = AppNumberFormat(context.locale);
    return Material(
      color: colors.bg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.pageGutter,
                AppDimensions.xs,
                AppDimensions.pageGutter,
                AppDimensions.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppDimensions.stepNumberTopGap),
                  ExcludeSemantics(
                    child: Text(
                      context.tr(
                        TranslationKeys.onboardingStepOf,
                        namedArgs: {
                          OnboardingArgs.current: numbers.integer(step),
                          OnboardingArgs.total: numbers.integer(totalSteps),
                        },
                      ),
                      style: TextStyle(
                        fontSize: AppDimensions.captionFontSize,
                        color: colors.muted,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Semantics(
                    header: true,
                    child: Text(
                      context.tr(titleKey),
                      style: textTheme.headlineSmall,
                    ),
                  ),
                  if (leadKey case final lead?) ...[
                    const SizedBox(height: AppDimensions.fieldLabelGap),
                    Text(
                      context.tr(lead),
                      style: TextStyle(
                        fontSize: AppDimensions.secondaryFontSize,
                        color: colors.muted,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppDimensions.lg),
                  ?body,
                ],
              ),
            ),
          ),
          if (footer case final footer?) AppFooterBar(child: footer),
        ],
      ),
    );
  }
}
