import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/number_symbols.dart';
import '../../../../../core/constants/onboarding_args.dart';
import '../../../../../core/constants/translation_keys.dart';
import '../../../../../core/formatting/app_number_format.dart';
import '../../../../../core/widgets/app_list_group.dart';
import '../../../../../core/widgets/app_list_row.dart';
import '../../../../../core/widgets/app_sum_line.dart';
import '../../../domain/entities/currency.dart';
import '../../../domain/entities/obligation_draft.dart';
import '../../../domain/entities/obligation_kind.dart';
import '../../obligation_labels.dart';

class ObligationList extends StatelessWidget {
  const ObligationList({
    super.key,
    required this.obligations,
    required this.currency,
    required this.reservedMinor,
    required this.onTap,
  });

  final List<ObligationDraft> obligations;
  final Currency currency;
  final int reservedMinor;
  final ValueChanged<ObligationDraft> onTap;

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
        for (final obligation in obligations)
          AppListRow(
            icon: obligation.kind.icon,
            title: obligation.name,
            subtitle: context.tr(
              obligation.kind == ObligationKind.variable
                  ? TranslationKeys.obligationRowSubtitleEstimate
                  : TranslationKeys.obligationRowSubtitle,
              namedArgs: {
                OnboardingArgs.kind: context.tr(obligation.kind.labelKey),
                OnboardingArgs.day: numbers.integer(obligation.dueDay),
              },
            ),
            trailing:
                '${obligation.kind == ObligationKind.variable ? NumberSymbols.approx : ''}'
                '${money(obligation.monthlyShareMinor)}',
            onTap: () => onTap(obligation),
          ),
        AppSumLine(
          label: context.tr(TranslationKeys.onboardingReservedTotal),
          value: money(reservedMinor),
          isTotal: true,
        ),
      ],
    );
  }
}
