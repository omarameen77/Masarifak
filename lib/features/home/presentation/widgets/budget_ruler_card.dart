import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_args.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/translation_keys.dart';
import '../../../../core/formatting/app_date_format.dart';
import '../../../../core/formatting/app_number_format.dart';
import '../../../../core/money/money_currency.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_status_tag.dart';
import '../../domain/entities/cycle_status.dart';
import '../../domain/entities/cycle_summary.dart';
import '../home_cubit.dart';
import '../home_presentation.dart';
import '../home_state.dart';
import 'cycle_timeline.dart';
import 'ruler_meter.dart';

class BudgetRulerCard extends StatelessWidget {
  const BudgetRulerCard({super.key});

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
        final floor = summary?.safetyBalanceMinor;
        final period = summary?.period;
        if (summary == null || floor == null || period == null || today == null) {
          return const SizedBox.shrink();
        }
        final colors = Theme.of(context).extension<AppColors>()!;
        final dates = AppDateFormat(context.locale);
        final numbers = AppNumberFormat(context.locale);
        final margin = summary.marginMinor ?? summary.remainingMinor - floor;
        final spendable = summary.spendableMinor <= 0 ? 1 : summary.spendableMinor;
        final dayNumber = period.dayNumber(today).clamp(1, period.days);
        final floorDate = summary.floorDate;
        String money(int minor) =>
            homeMoney(context, currency, minor, rounded: true);
        final legendStyle = TextStyle(
          fontSize: AppDimensions.legendFontSize,
          color: colors.ink2,
        );
        return Padding(
          padding: const EdgeInsets.only(top: AppDimensions.lg),
          child: RepaintBoundary(
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.inputPaddingHorizontal),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radius),
                border: Border.all(
                  color: colors.line,
                  width: AppDimensions.borderWidth,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        size: AppDimensions.chipIconSize,
                        color: colors.ink2,
                      ),
                      const SizedBox(width: AppDimensions.xs),
                      Expanded(
                        child: Text(
                          context.tr(
                            TranslationKeys.homeFloorLabel,
                            namedArgs: {AppArgs.amount: money(floor)},
                          ),
                          style: TextStyle(
                            fontSize: AppDimensions.secondaryFontSize,
                            color: colors.ink,
                          ),
                        ),
                      ),
                      if (margin > 0)
                        Text(
                          context.tr(
                            TranslationKeys.homeAboveFloor,
                            namedArgs: {AppArgs.amount: money(margin)},
                          ),
                          style: TextStyle(
                            fontSize: AppDimensions.secondaryFontSize,
                            color: colors.muted,
                          ),
                        )
                      else
                        AppStatusTag(
                          label: context.tr(CycleStatus.critical.labelKey),
                          icon: CycleStatus.critical.icon,
                          tone: CycleStatus.critical.tone,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  RulerMeter(
                    fill: (summary.remainingMinor / spendable).clamp(0.0, 1.0),
                    marker: (floor / spendable).clamp(0.0, 1.0),
                    color: summary.status.color(colors),
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  CycleTimeline(
                    progress: dayNumber / period.days,
                    floorProgress: floorDate == null
                        ? null
                        : ((floorDate.difference(period.start).inDays + 1) /
                                  period.days)
                              .clamp(0.0, 1.0),
                  ),
                  const SizedBox(height: AppDimensions.fieldLabelGap),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dates.dayMonth(period.start),
                        style: TextStyle(
                          fontSize: AppDimensions.tagFontSize,
                          color: colors.muted,
                        ),
                      ),
                      Text(
                        context.tr(
                          TranslationKeys.homePaydayEnd,
                          namedArgs: {
                            AppArgs.date: dates.dayMonth(period.nextPayday),
                          },
                        ),
                        style: TextStyle(
                          fontSize: AppDimensions.tagFontSize,
                          color: colors.muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.md),
                  Wrap(
                    spacing: AppDimensions.inputPaddingHorizontal,
                    runSpacing: AppDimensions.xs,
                    children: [
                      _legend(
                        swatch: colors.acc,
                        text: context.tr(
                          TranslationKeys.homeTodayMarker,
                          namedArgs: {
                            AppArgs.day: numbers.integer(dayNumber),
                            AppArgs.days: numbers.integer(period.days),
                          },
                        ),
                        style: legendStyle,
                      ),
                      if (floorDate != null)
                        _legend(
                          swatch: colors.warn,
                          text: context.tr(
                            TranslationKeys.homeFloorForecast,
                            namedArgs: {AppArgs.date: dates.dayMonth(floorDate)},
                          ),
                          style: legendStyle,
                        )
                      else if (margin > 0 && summary.spentMinor > 0)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check,
                              size: AppDimensions.tagIconSize,
                              color: colors.accText,
                            ),
                            const SizedBox(width: AppDimensions.fieldLabelGap),
                            Text(
                              context.tr(TranslationKeys.homeFloorSafe),
                              style: legendStyle,
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _legend({
    required Color swatch,
    required String text,
    required TextStyle style,
  }) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: AppDimensions.legendSwatchSize,
        height: AppDimensions.legendSwatchSize,
        decoration: BoxDecoration(
          color: swatch,
          borderRadius: BorderRadius.circular(AppDimensions.legendSwatchRadius),
        ),
      ),
      const SizedBox(width: AppDimensions.fieldLabelGap),
      Text(text, style: style),
    ],
  );
}
