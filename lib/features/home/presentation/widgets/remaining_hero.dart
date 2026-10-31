import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_args.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/number_symbols.dart';
import '../../../../core/constants/translation_keys.dart';
import '../../../../core/formatting/app_number_format.dart';
import '../../../../core/money/money_currency.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_status_tag.dart';
import '../../domain/entities/cycle_summary.dart';
import '../home_cubit.dart';
import '../home_presentation.dart';
import '../home_state.dart';

class RemainingHero extends StatelessWidget {
  const RemainingHero({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeCubit, HomeState, (CycleSummary?, MoneyCurrency)>(
      selector: (state) => (state.summary, state.currency),
      builder: (context, data) {
        final (summary, currency) = data;
        if (summary == null) return const SizedBox.shrink();
        final colors = Theme.of(context).extension<AppColors>()!;
        final numbers = AppNumberFormat(context.locale);
        final remaining = summary.remainingMinor;
        final amount = numbers.amount(
          remaining,
          exponent: currency.exponent,
          rounded: true,
        );
        return Semantics(
          container: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.xs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppDimensions.fieldLabelGap,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      context.tr(TranslationKeys.homeRemainingLabel),
                      style: TextStyle(
                        fontSize: AppDimensions.secondaryFontSize,
                        color: colors.ink2,
                      ),
                    ),
                    AppStatusTag(
                      label: context.tr(summary.status.labelKey),
                      icon: summary.status.icon,
                      tone: summary.status.tone,
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.xs),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: amount,
                      ),
                      TextSpan(
                        text: '${NumberSymbols.space}${currency.symbol}',
                        style: TextStyle(
                          fontSize: AppDimensions.heroCurrencyFontSize,
                          fontWeight: FontWeight.w500,
                          color: colors.muted,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                  style: TextStyle(
                    fontSize: AppDimensions.heroAmountFontSize,
                    fontWeight: FontWeight.w600,
                    height: AppDimensions.heroAmountLineHeight,
                    letterSpacing: AppDimensions.heroAmountLetterSpacing,
                    color: remaining < 0 ? colors.crit : colors.ink,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: AppDimensions.tagPaddingVertical),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      context.tr(
                        TranslationKeys.homeSpendableOf,
                        namedArgs: {
                          AppArgs.amount: homeMoney(
                            context,
                            currency,
                            summary.spendableMinor,
                            rounded: true,
                          ),
                        },
                      ),
                      style: TextStyle(
                        fontSize: AppDimensions.secondaryFontSize,
                        color: colors.muted,
                      ),
                    ),
                    Text(
                      '${NumberSymbols.space}${NumberSymbols.middleDot}'
                      '${NumberSymbols.space}',
                      style: TextStyle(color: colors.muted),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        context.tr(TranslationKeys.homeHowCalculated),
                        style: TextStyle(
                          fontSize: AppDimensions.secondaryFontSize,
                          fontWeight: FontWeight.w600,
                          color: colors.accText,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
