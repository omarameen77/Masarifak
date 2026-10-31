import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/constants/onboarding_defaults.dart';
import '../../../../../core/constants/translation_keys.dart';
import '../../../../../core/formatting/app_date_format.dart';
import '../../../../../core/widgets/app_choice_option.dart';
import '../../../../../core/widgets/app_labeled_field.dart';
import '../../../../../core/widgets/app_money_field.dart';
import '../../../../../core/widgets/app_segmented_control.dart';
import '../../../domain/entities/currency.dart';
import '../../../domain/entities/pay_cycle.dart';
import '../../onboarding_validators.dart';

class PeriodicFields extends StatelessWidget {
  const PeriodicFields({
    super.key,
    required this.totalController,
    required this.currency,
    required this.everyMonths,
    required this.cycles,
    required this.cycleIndex,
    required this.autovalidateMode,
    required this.onEveryChanged,
    required this.onCycleChanged,
  });

  final TextEditingController totalController;
  final Currency currency;
  final int everyMonths;
  final List<PayCycle> cycles;
  final int cycleIndex;
  final AutovalidateMode autovalidateMode;
  final ValueChanged<int> onEveryChanged;
  final ValueChanged<int> onCycleChanged;

  String _cycleLabel(AppDateFormat dates, PayCycle cycle) =>
      cycle.start.day == 1
      ? dates.monthYear(cycle.start)
      : dates.range(cycle.start, cycle.end);

  @override
  Widget build(BuildContext context) {
    final dates = AppDateFormat(context.locale);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppMoneyField(
          controller: totalController,
          labelKey: TranslationKeys.obligationTotalAmount,
          currencySymbol: currency.symbol,
          autovalidateMode: autovalidateMode,
          validator: OnboardingValidators.positiveAmount(currency.exponent),
        ),
        const SizedBox(height: AppDimensions.lg),
        AppLabeledField(
          labelKey: TranslationKeys.obligationEveryLabel,
          child: AppSegmentedControl<int>(
            options: [
              for (final (index, months)
                  in OnboardingDefaults.periodicIntervals.indexed)
                AppChoiceOption(
                  value: months,
                  label: context.tr(TranslationKeys.obligationIntervals[index]),
                ),
            ],
            selected: everyMonths,
            onSelected: onEveryChanged,
          ),
        ),
        const SizedBox(height: AppDimensions.lg),
        AppLabeledField(
          labelKey: TranslationKeys.obligationNextDueLabel,
          helperText: context.tr(TranslationKeys.obligationPeriodicHint),
          child: DropdownButtonFormField<int>(
            initialValue: cycleIndex,
            isExpanded: true,
            items: [
              for (final (index, cycle) in cycles.indexed)
                DropdownMenuItem(
                  value: index,
                  child: Text(_cycleLabel(dates, cycle)),
                ),
            ],
            onChanged: (index) {
              if (index != null) onCycleChanged(index);
            },
          ),
        ),
      ],
    );
  }
}
