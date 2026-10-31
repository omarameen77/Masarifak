import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/onboarding_args.dart';
import '../../../../core/constants/translation_keys.dart';
import '../../../../core/widgets/app_note.dart';
import '../../../../core/widgets/app_template_text.dart';
import '../onboarding_cubit.dart';
import '../onboarding_state.dart';
import '../widgets/onboarding_step_layout.dart';
import 'widgets/obligation_list.dart';
import 'widgets/obligation_sheet.dart';

class OnboardingObligationsScreen extends StatelessWidget {
  const OnboardingObligationsScreen({
    super.key,
    required this.step,
    required this.totalSteps,
  });

  final int step;
  final int totalSteps;

  void _next(BuildContext context) => context.push(AppRoutes.onboardingSafety);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final hasObligations = state.obligations.isNotEmpty;
        return OnboardingStepLayout(
          step: step,
          totalSteps: totalSteps,
          titleKey: TranslationKeys.onboardingObligationsTitle,
          leadKey: TranslationKeys.onboardingObligationsLead,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (hasObligations) ...[
                ObligationList(
                  obligations: state.obligations,
                  currency: state.currency,
                  reservedMinor: state.reservedMinor,
                  onTap: (obligation) =>
                      ObligationSheet.show(context, existing: obligation),
                ),
                const SizedBox(height: AppDimensions.md),
              ],
              OutlinedButton.icon(
                onPressed: () => ObligationSheet.show(context),
                icon: const Icon(Icons.add),
                label: Text(context.tr(TranslationKeys.onboardingAddObligation)),
              ),
              const SizedBox(height: AppDimensions.lg),
              AppNote(
                icon: Icons.info_outline,
                child: AppTemplateText(
                  templateKey: TranslationKeys.onboardingVariableTip,
                  values: {
                    OnboardingArgs.variable: context.tr(
                      TranslationKeys.obligationKindVariable,
                    ),
                  },
                  emphasized: const {OnboardingArgs.variable},
                ),
              ),
            ],
          ),
          footer: hasObligations
              ? FilledButton(
                  onPressed: () => _next(context),
                  child: Text(context.tr(TranslationKeys.onboardingNext)),
                )
              : TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(
                      AppDimensions.buttonMinHeight,
                    ),
                  ),
                  onPressed: () => _next(context),
                  child: Text(context.tr(TranslationKeys.onboardingSkip)),
                ),
        );
      },
    );
  }
}
