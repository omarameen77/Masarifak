import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/constants/translation_keys.dart';
import '../../../../../core/theme/app_colors.dart';

class SummaryActions extends StatelessWidget {
  const SummaryActions({
    super.key,
    required this.isCompleting,
    required this.onStart,
  });

  final bool isCompleting;
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          onPressed: isCompleting ? null : onStart,
          child: isCompleting
              ? SizedBox.square(
                  dimension: AppDimensions.progressIndicatorSize,
                  child: CircularProgressIndicator(
                    strokeWidth: AppDimensions.progressStrokeWidth,
                    color: colors.accInk,
                  ),
                )
              : Text(context.tr(TranslationKeys.summaryStart)),
        ),
        const SizedBox(height: AppDimensions.sm),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.send_outlined),
          label: Text(context.tr(TranslationKeys.summaryLinkTelegram)),
        ),
      ],
    );
  }
}
