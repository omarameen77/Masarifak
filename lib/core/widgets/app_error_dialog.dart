import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../constants/translation_keys.dart';

abstract final class AppErrorDialog {
  static Future<void> show(BuildContext context, {required String messageKey}) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        titlePadding: const EdgeInsetsDirectional.fromSTEB(
          AppDimensions.xl,
          AppDimensions.xl,
          AppDimensions.xl,
          AppDimensions.sm,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.xl,
        ),
        title: Text(TranslationKeys.errorDialogTitle.tr()),
        content: Text(messageKey.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(TranslationKeys.errorDialogAction.tr()),
          ),
        ],
      ),
    );
  }
}
