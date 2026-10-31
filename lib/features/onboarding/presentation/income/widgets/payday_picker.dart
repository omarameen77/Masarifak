import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/constants/translation_keys.dart';
import '../../../../../core/formatting/app_number_format.dart';
import '../../../../../core/formatting/localized_digits_input_formatter.dart';
import '../../../../../core/widgets/app_choice_chips.dart';
import '../../../../../core/widgets/app_choice_option.dart';
import '../../../../../core/widgets/app_labeled_field.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../onboarding_validators.dart';

class PaydayPicker extends StatelessWidget {
  const PaydayPicker({
    super.key,
    required this.presets,
    required this.selectedPreset,
    required this.isOther,
    required this.otherController,
    required this.autovalidateMode,
    required this.onPresetSelected,
    required this.onOtherSelected,
    required this.onOtherChanged,
  });

  static const int otherOption = 0;

  final List<int> presets;
  final int? selectedPreset;
  final bool isOther;
  final TextEditingController otherController;
  final AutovalidateMode autovalidateMode;
  final ValueChanged<int> onPresetSelected;
  final VoidCallback onOtherSelected;
  final ValueChanged<String> onOtherChanged;

  @override
  Widget build(BuildContext context) {
    final numbers = AppNumberFormat(context.locale);
    return AppLabeledField(
      labelKey: TranslationKeys.onboardingPaydayLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppChoiceChips<int>(
            options: [
              for (final day in presets)
                AppChoiceOption(value: day, label: numbers.integer(day)),
              AppChoiceOption(
                value: otherOption,
                label: context.tr(TranslationKeys.onboardingPaydayOther),
              ),
            ],
            selected: isOther ? otherOption : selectedPreset,
            onSelected: (value) =>
                value == otherOption ? onOtherSelected() : onPresetSelected(value),
          ),
          if (isOther) ...[
            const SizedBox(height: AppDimensions.md),
            AppTextField(
              controller: otherController,
              labelKey: TranslationKeys.onboardingPaydayDayLabel,
              hintKey: TranslationKeys.dayOfMonthHint,
              validator: OnboardingValidators.dayOfMonth,
              autovalidateMode: autovalidateMode,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              inputFormatters: const [LocalizedDigitsInputFormatter()],
              onChanged: onOtherChanged,
            ),
          ],
        ],
      ),
    );
  }
}
