import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/constants/translation_keys.dart';
import '../../../../../core/formatting/app_date_format.dart';
import '../../../../../core/formatting/app_number_format.dart';
import '../../../../../core/widgets/app_kpi_card.dart';
import '../../../domain/entities/currency.dart';
import '../../../domain/entities/pay_cycle.dart';

class SummaryKpis extends StatelessWidget {
  const SummaryKpis({
    super.key,
    required this.dailyBudgetMinor,
    required this.daysLeft,
    required this.cycle,
    required this.currency,
  });

  final int dailyBudgetMinor;
  final int daysLeft;
  final PayCycle cycle;
  final Currency currency;

  @override
  Widget build(BuildContext context) {
    final numbers = AppNumberFormat(context.locale);
    final dates = AppDateFormat(context.locale);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: AppKpiCard(
              label: context.tr(TranslationKeys.summaryDailyLabel),
              value: numbers.money(
                dailyBudgetMinor,
                exponent: currency.exponent,
                symbol: currency.symbol,
                rounded: true,
              ),
              caption: context.tr(TranslationKeys.summaryDailyCaption),
            ),
          ),
          const SizedBox(width: AppDimensions.kpiGap),
          Expanded(
            child: AppKpiCard(
              label: context.tr(TranslationKeys.summaryUntilPayday),
              value: dates.days(daysLeft),
              caption: dates.dayMonth(cycle.next),
            ),
          ),
        ],
      ),
    );
  }
}
