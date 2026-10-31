import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/translation_keys.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    const height = Size.fromHeight(AppDimensions.quickActionHeight);
    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.lg),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.icon(
              style: FilledButton.styleFrom(minimumSize: height),
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: Text(context.tr(TranslationKeys.homeAddExpense)),
            ),
          ),
          const SizedBox(width: AppDimensions.kpiGap),
          Expanded(
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(minimumSize: height),
              onPressed: () {},
              icon: const Icon(Icons.photo_camera_outlined),
              label: Text(context.tr(TranslationKeys.homeScanReceipt)),
            ),
          ),
        ],
      ),
    );
  }
}
