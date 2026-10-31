import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_args.dart';
import '../../../../core/constants/translation_keys.dart';
import '../../../../core/formatting/app_number_format.dart';
import '../../../../core/money/money_currency.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_list_group.dart';
import '../../../../core/widgets/app_list_row.dart';
import '../../domain/entities/savings_overview.dart';
import '../home_cubit.dart';
import '../home_presentation.dart';
import '../home_state.dart';
import 'home_section_error.dart';
import 'home_section_header.dart';

class SavingsSection extends StatelessWidget {
  const SavingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      HomeCubit,
      HomeState,
      (HomeSection<SavingsOverview>, MoneyCurrency)
    >(
      selector: (state) => (state.savings, state.currency),
      builder: (context, data) {
        final (section, currency) = data;
        final savings = section.data;
        if (savings == null && section.failure == null) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const HomeSectionHeader(titleKey: TranslationKeys.homeSavingsTitle),
            if (savings == null)
              const HomeSectionError()
            else
              AppListGroup(
                children: [
                  AppListRow(
                    icon: Icons.savings_outlined,
                    iconColor: Theme.of(context).extension<AppColors>()!.accText,
                    title: homeMoney(
                      context,
                      currency,
                      savings.balanceMinor,
                      rounded: true,
                    ),
                    subtitle: _subtitle(context, savings, currency),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  String _subtitle(
    BuildContext context,
    SavingsOverview savings,
    MoneyCurrency currency,
  ) {
    final goal = savings.nearestGoal;
    if (goal == null) {
      return context.tr(
        TranslationKeys.homeSavingsMonthly,
        namedArgs: {
          AppArgs.amount: homeMoney(
            context,
            currency,
            savings.monthlyContributionMinor,
            rounded: true,
          ),
        },
      );
    }
    return context.tr(
      TranslationKeys.homeSavingsGoal,
      namedArgs: {
        AppArgs.name: goal.name,
        AppArgs.percent: AppNumberFormat(context.locale).percent(goal.progress),
        AppArgs.target: homeMoney(
          context,
          currency,
          goal.targetMinor,
          rounded: true,
        ),
      },
    );
  }
}
