import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../formatting/localized_digits_input_formatter.dart';
import 'app_text_field.dart';

class AppMoneyField extends StatelessWidget {
  const AppMoneyField({
    super.key,
    required this.controller,
    required this.labelKey,
    required this.currencySymbol,
    this.labelNamedArgs,
    this.validator,
    this.hintKey,
    this.helperText,
    this.large = false,
    this.allowDecimal = true,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.textInputAction,
    this.onChanged,
  });

  final TextEditingController controller;
  final String labelKey;
  final String currencySymbol;
  final Map<String, String>? labelNamedArgs;
  final String? Function(String? value)? validator;
  final String? hintKey;
  final String? helperText;
  final bool large;
  final bool allowDecimal;
  final AutovalidateMode autovalidateMode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final bodyStyle = Theme.of(context).textTheme.bodyMedium;
    return AppTextField(
      controller: controller,
      labelKey: labelKey,
      labelNamedArgs: labelNamedArgs,
      validator: validator,
      hintKey: hintKey,
      helperText: helperText,
      suffixText: currencySymbol,
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      textDirection: TextDirection.ltr,
      textInputAction: textInputAction,
      autovalidateMode: autovalidateMode,
      onChanged: onChanged,
      inputFormatters: [
        LocalizedDigitsInputFormatter(allowDecimal: allowDecimal),
      ],
      minHeight: large ? AppDimensions.moneyMinHeight : null,
      style: large
          ? bodyStyle?.copyWith(
              fontSize: AppDimensions.moneyFontSize,
              fontWeight: FontWeight.w600,
              fontFeatures: const [FontFeature.tabularFigures()],
            )
          : bodyStyle?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
    );
  }
}
