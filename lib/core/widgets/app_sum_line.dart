import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../constants/number_symbols.dart';
import '../theme/app_colors.dart';

class AppSumLine extends StatelessWidget {
  const AppSumLine({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
    this.isDeduction = false,
  });

  final String label;
  final String value;
  final bool isTotal;
  final bool isDeduction;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final style = TextStyle(
      fontSize: AppDimensions.bodyFontSize,
      fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
      color: colors.ink,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    return Container(
      color: isTotal ? colors.sunk : null,
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.rowPaddingVertical,
        horizontal: AppDimensions.inputPaddingHorizontal,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          if (isDeduction)
            Padding(
              padding: const EdgeInsetsDirectional.only(
                end: AppDimensions.fieldLabelGap,
              ),
              child: Text(
                NumberSymbols.minus,
                style: style.copyWith(color: colors.muted),
              ),
            ),
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
}
