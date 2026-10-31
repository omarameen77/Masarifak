import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_args.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/number_symbols.dart';
import '../../../../core/constants/translation_keys.dart';
import '../../../../core/formatting/app_date_format.dart';
import '../../../../core/money/money_currency.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_list_group.dart';
import '../../../../core/widgets/app_list_row.dart';
import '../../../../core/widgets/app_status_tag.dart';
import '../../domain/entities/upcoming_obligation.dart';
import '../home_cubit.dart';
import '../home_presentation.dart';
import '../home_state.dart';
import 'home_section_error.dart';
import 'home_section_header.dart';

class UpcomingObligationsSection extends StatelessWidget {
  const UpcomingObligationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      HomeCubit,
      HomeState,
      (HomeSection<List<UpcomingObligation>>, MoneyCurrency)
    >(
      selector: (state) => (state.obligations, state.currency),
      builder: (context, data) {
        final (section, currency) = data;
        final items = section.data;
        final colors = Theme.of(context).extension<AppColors>()!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HomeSectionHeader(
              titleKey: TranslationKeys.homeUpcomingTitle,
              onSeeAll: () => context.go(AppRoutes.obligations),
            ),
            if (items == null)
              const HomeSectionError()
            else if (items.isEmpty)
              AppListGroup(
                children: [
                  AppListRow(
                    icon: Icons.check,
                    iconColor: colors.accText,
                    title: context.tr(TranslationKeys.homeUpcomingEmptyTitle),
                    subtitle: context.tr(TranslationKeys.homeUpcomingEmptyText),
                  ),
                ],
              )
            else
              AppListGroup(
                children: [
                  for (final item in items)
                    AppListRow(
                      icon: item.kind.icon,
                      iconColor: switch (item.status.tone) {
                        AppStatusTone.critical => colors.crit,
                        AppStatusTone.warn => colors.warn,
                        _ => null,
                      },
                      title: item.name,
                      subtitle: _dueText(context, item),
                      trailing:
                          '${item.isEstimate ? NumberSymbols.approx : ''}'
                          '${homeMoney(context, currency, item.amountMinor)}',
                      trailingBelow: AppStatusTag(
                        label: context.tr(item.status.labelKey),
                        icon: item.status.icon,
                        tone: item.status.tone,
                      ),
                      onTap: () => context.go(AppRoutes.obligations),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }

  String _dueText(BuildContext context, UpcomingObligation item) {
    final dates = AppDateFormat(context.locale);
    final date = dates.dayMonth(item.dueOn);
    return switch (item.daysUntilDue) {
      < 0 => context.tr(
        TranslationKeys.dueOverdue,
        namedArgs: {AppArgs.date: date},
      ),
      0 => context.tr(TranslationKeys.dueToday),
      1 => context.tr(TranslationKeys.dueTomorrow),
      final days => context.tr(
        TranslationKeys.dueIn,
        namedArgs: {AppArgs.date: date, AppArgs.days: dates.days(days)},
      ),
    };
  }
}
