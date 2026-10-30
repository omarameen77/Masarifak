import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.labelKey,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.textDirection,
    this.autofillHints,
    this.textInputAction,
    this.onFieldSubmitted,
    this.enabled = true,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  final TextEditingController controller;
  final String labelKey;
  final String? Function(String? value)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextDirection? textDirection;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;
  final AutovalidateMode autovalidateMode;

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
            context.tr(labelKey),
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
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(suffixIcon: suffixIcon),
        ),
      ],
    );
  }
}
