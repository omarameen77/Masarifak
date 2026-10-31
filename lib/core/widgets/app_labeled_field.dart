import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';

class AppLabeledField extends StatelessWidget {
  const AppLabeledField({
    super.key,
    required this.labelKey,
    required this.child,
    this.helperText,
  });

  final String labelKey;
  final Widget child;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    final decoration = Theme.of(context).inputDecorationTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(
            bottom: AppDimensions.fieldLabelGap,
          ),
          child: Text(context.tr(labelKey), style: decoration.labelStyle),
        ),
        child,
        if (helperText case final helper?)
          Padding(
            padding: const EdgeInsetsDirectional.only(
              top: AppDimensions.fieldLabelGap,
            ),
            child: Text(helper, style: decoration.helperStyle),
          ),
      ],
    );
  }
}
