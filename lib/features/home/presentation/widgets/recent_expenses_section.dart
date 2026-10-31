import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/number_symbols.dart';
import '../../../../core/constants/translation_keys.dart';
import '../../../../core/money/money_currency.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_list_group.dart';
import '../../../../core/widgets/app_list_row.dart';
import '../../domain/entities/recent_expense.dart';
import '../home_cubit.dart';
import '../home_presentation.dart';
import '../home_state.dart';
import 'home_section_error.dart';
import 'home_section_header.dart';

class RecentExpensesSection extends StatelessWidget {
  const RecentExpensesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      HomeCubit,
      HomeState,
      (HomeSection<List<RecentExpense>>, MoneyCurrency)
    >(
      selector: (state) => (state.expenses, state.currency),
      builder: (context, data) {
        final (section, currency) = data;
        final items = section.data;
        final hasItems = items != null && items.isNotEmpty;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HomeSectionHeader(
              titleKey: TranslationKeys.homeRecentTitle,
              onSeeAll: hasItems ? () => context.go(AppRoutes.expenses) : null,
            ),
            if (items == null)
              const HomeSectionError()
            else if (items.isEmpty)
              AppListGroup(
                children: [
                  AppEmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: context.tr(TranslationKeys.homeRecentEmptyTitle),
                    message: context.tr(TranslationKeys.homeRecentEmptyText),
                  ),
                ],
              )
            else
              AppListGroup(
                children: [
                  for (final expense in items)
                    AppListRow(
                      icon: expenseCategoryIcon(expense.categoryKey),
                      title: expense.merchant,
                      subtitle: _subtitle(context, expense),
                      trailing: homeMoney(context, currency, expense.amountMinor),
                      onTap: () => context.go(AppRoutes.expenses),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }

  String _subtitle(BuildContext context, RecentExpense expense) {
    final necessity = expense.necessity;
    if (necessity == null) return expense.categoryLabel;
    return '${expense.categoryLabel}${NumberSymbols.space}'
        '${NumberSymbols.middleDot}${NumberSymbols.space}'
        '${context.tr(necessity.labelKey)}';
  }
}
