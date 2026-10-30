import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/translation_keys.dart';
import '../../../../../core/formatting/app_number_format.dart';
import '../../../../../core/widgets/app_list_group.dart';
import '../../../../../core/widgets/app_sum_line.dart';
import '../../../domain/entities/currency.dart';
import '../../../domain/entities/onboarding_summary.dart';

class SummaryBreakdown extends StatelessWidget {
  const SummaryBreakdown({
    super.key,
    required this.incomeMinor,
    required this.summary,
    required this.currency,
  });

  final int incomeMinor;
  final OnboardingSummary summary;
  final Currency currency;

  @override
  Widget build(BuildContext context) {
    final numbers = AppNumberFormat(context.locale);
    String money(int minor) => numbers.money(
      minor,
      exponent: currency.exponent,
      symbol: currency.symbol,
    );
    return AppListGroup(
      children: [
        AppSumLine(
          label: context.tr(TranslationKeys.summaryIncome),
          value: money(incomeMinor),
        ),
        AppSumLine(
          label: context.tr(TranslationKeys.summaryReserved),
          value: money(summary.reservedMinor),
          isDeduction: true,
        ),
        AppSumLine(
          label: context.tr(TranslationKeys.summarySavings),
          value: money(summary.savingsMinor),
          isDeduction: true,
        ),
        AppSumLine(
          label: context.tr(TranslationKeys.summarySpendable),
          value: money(summary.spendableMinor),
          isTotal: true,
        ),
        if (summary.spentMinor > 0) ...[
          AppSumLine(
            label: context.tr(TranslationKeys.summarySpent),
            value: money(summary.spentMinor),
            isDeduction: true,
          ),
          AppSumLine(
            label: context.tr(TranslationKeys.summaryRemaining),
            value: money(summary.remainingMinor),
            isTotal: true,
          ),
        ],
      ],
    );
  }
}
