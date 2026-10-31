import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/onboarding_args.dart';
import '../../../../../core/constants/translation_keys.dart';
import '../../../../../core/formatting/app_date_format.dart';
import '../../../../../core/widgets/app_note.dart';
import '../../../../../core/widgets/app_template_text.dart';
import '../../../domain/services/pay_cycle_calculator.dart';

class CycleExplanation extends StatelessWidget {
  const CycleExplanation({super.key, required this.today, required this.payday});

  final DateTime today;
  final int payday;

  @override
  Widget build(BuildContext context) {
    final dates = AppDateFormat(context.locale);
    final cycle = PayCycleCalculator.cycleOf(today, payday);
    return Semantics(
      liveRegion: true,
      child: AppNote(
        icon: Icons.calendar_today_outlined,
        child: AppTemplateText(
          templateKey: TranslationKeys.onboardingCycleExplain,
          values: {
            OnboardingArgs.start: dates.dayMonth(cycle.start),
            OnboardingArgs.end: dates.dayMonth(cycle.end),
            OnboardingArgs.days: dates.days(cycle.days),
          },
          emphasized: const {OnboardingArgs.start, OnboardingArgs.end},
        ),
      ),
    );
  }
}
