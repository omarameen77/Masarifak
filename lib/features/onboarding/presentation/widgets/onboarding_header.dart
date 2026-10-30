import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/onboarding_args.dart';
import '../../../../core/constants/translation_keys.dart';
import '../../../../core/formatting/app_number_format.dart';
import '../../../../core/widgets/step_progress_bar.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({
    super.key,
    required this.step,
    required this.totalSteps,
  });

  final int step;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final numbers = AppNumberFormat(context.locale);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: AppDimensions.topBarHeight,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: step > 1
                ? Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: AppDimensions.sm,
                    ),
                    child: IconButton(
                      tooltip: MaterialLocalizations.of(
                        context,
                      ).backButtonTooltip,
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  )
                : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.pageGutter,
          ),
          child: StepProgressBar(
            current: step,
            total: totalSteps,
            semanticLabel: context.tr(
              TranslationKeys.onboardingStepOf,
              namedArgs: {
                OnboardingArgs.current: numbers.integer(step),
                OnboardingArgs.total: numbers.integer(totalSteps),
              },
            ),
          ),
        ),
      ],
    );
  }
}
