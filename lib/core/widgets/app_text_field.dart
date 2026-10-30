import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_dimensions.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.labelKey,
    this.labelNamedArgs,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.suffixText,
    this.textDirection,
    this.autofillHints,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onChanged,
    this.enabled = true,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.serverErrorKey,
    this.hintKey,
    this.helperText,
    this.inputFormatters,
    this.style,
    this.minHeight,
  });

  final TextEditingController controller;
  final String labelKey;
  final Map<String, String>? labelNamedArgs;
  final String? Function(String? value)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? suffixText;
  final TextDirection? textDirection;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final AutovalidateMode autovalidateMode;
  final String? serverErrorKey;
  final String? hintKey;
  final String? helperText;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? style;
  final double? minHeight;

  String? _validate(String? value) => validator?.call(value)?.tr();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(
            bottom: AppDimensions.fieldLabelGap,
          ),
          child: Text(
            context.tr(labelKey, namedArgs: labelNamedArgs),
            style: theme.inputDecorationTheme.labelStyle,
          ),
        ),
        TextFormField(
          controller: controller,
          enabled: enabled,
          validator: _validate,
          autovalidateMode: autovalidateMode,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textDirection: textDirection,
          textAlign: Directionality.of(context) == TextDirection.rtl
              ? TextAlign.right
              : TextAlign.left,
          autocorrect: false,
          enableSuggestions: !obscureText,
          autofillHints: autofillHints,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          style: style ?? theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            constraints: minHeight == null
                ? null
                : BoxConstraints(minHeight: minHeight!),
            suffixIcon: suffixIcon,
            suffixText: suffixText,
            hintText: hintKey?.tr(),
            helperText: helperText,
            helperMaxLines: AppDimensions.helperMaxLines,
            errorMaxLines: AppDimensions.helperMaxLines,
            errorText: serverErrorKey?.tr(),
          ),
        ),
      ],
    );
  }
}
