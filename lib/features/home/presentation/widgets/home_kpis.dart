import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_args.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/translation_keys.dart';
import '../../../../core/formatting/app_date_format.dart';
import '../../../../core/money/money_currency.dart';
import '../../../../core/widgets/app_kpi_card.dart';
import '../../domain/entities/cycle_summary.dart';
import '../home_cubit.dart';
import '../home_presentation.dart';
import '../home_state.dart';

class HomeKpis extends StatelessWidget {
  const HomeKpis({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      HomeCubit,
      HomeState,
      (CycleSummary?, MoneyCurrency, DateTime?)
    >(
      selector: (state) => (state.summary, state.currency, state.today),
      builder: (context, data) {
        final (summary, currency, today) = data;
        if (summary == null) return const SizedBox.shrink();
        final period = summary.period;
        final dates = AppDateFormat(context.locale);
        final daily = homeMoney(
          context,
          currency,
          summary.dailyBudgetMinor,
          rounded: true,
        );
        return Padding(
          padding: const EdgeInsets.only(top: AppDimensions.lg),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: AppKpiCard(
                    label: context.tr(TranslationKeys.homeTodayLabel),
                    value: daily,
                    caption: context.tr(
                      TranslationKeys.homeDailyAllowance,
                      namedArgs: {AppArgs.amount: daily},
                    ),
                  ),
                ),
                if (period != null && today != null) ...[
                  const SizedBox(width: AppDimensions.kpiGap),
                  Expanded(
                    child: AppKpiCard(
                      label: context.tr(TranslationKeys.summaryUntilPayday),
                      value: dates.days(period.daysLeft(today)),
                      caption: dates.weekdayDayMonth(period.nextPayday),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
