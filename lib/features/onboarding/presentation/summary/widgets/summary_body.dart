import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/constants/onboarding_defaults.dart';
import '../../../../../core/constants/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_note.dart';
import '../../../domain/entities/onboarding_result.dart';
import '../../../domain/services/pay_cycle_calculator.dart';
import '../../onboarding_cubit.dart';
import '../../onboarding_state.dart';
import 'summary_breakdown.dart';
import 'summary_kpis.dart';

class SummaryBody extends StatelessWidget {
  const SummaryBody({super.key, required this.state, required this.result});

  final OnboardingState state;
  final OnboardingResult result;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final today = context.read<OnboardingCubit>().today;
    final cycle = PayCycleCalculator.cycleOf(
      today,
      state.payday ?? OnboardingDefaults.defaultPayday,
    );
    final summary = result.summary;
    final isOverIncome =
        summary.spendableMinor - (state.safetyBalanceMinor ?? 0) <= 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SummaryBreakdown(
          incomeMinor: state.salaryMinor ?? 0,
          summary: summary,
          currency: state.currency,
        ),
        const SizedBox(height: AppDimensions.lg),
        SummaryKpis(
          dailyBudgetMinor: summary.dailyBudgetMinor,
          daysLeft: PayCycleCalculator.daysLeft(today, cycle),
          cycle: cycle,
          currency: state.currency,
        ),
        if (isOverIncome) ...[
          const SizedBox(height: AppDimensions.md),
          AppNote(
            kind: AppNoteKind.warn,
            icon: Icons.warning_amber_outlined,
            child: Text(context.tr(TranslationKeys.summaryOverIncome)),
          ),
        ],
        const SizedBox(height: AppDimensions.md),
        Text(
          context.tr(TranslationKeys.summaryFormula),
          style: TextStyle(
            fontSize: AppDimensions.captionFontSize,
            color: colors.muted,
          ),
        ),
      ],
    );
  }
}
