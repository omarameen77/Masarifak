import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../theme/app_colors.dart';
import 'app_footer_bar.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    required this.titleKey,
    required this.body,
    this.footer,
  });

  final String titleKey;
  final Widget body;
  final Widget? footer;

  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
  }) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      useSafeArea: true,
      backgroundColor: colors.surface,
      barrierColor: colors.scrim,
      constraints: BoxConstraints(
        maxHeight:
            MediaQuery.sizeOf(context).height *
            AppDimensions.sheetMaxHeightFraction,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLarge),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      builder: builder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimensions.sm),
          Center(
            child: Container(
              width: AppDimensions.sheetGrabWidth,
              height: AppDimensions.sheetGrabHeight,
              decoration: BoxDecoration(
                color: colors.line2,
                borderRadius: BorderRadius.circular(
                  AppDimensions.stepBarRadius,
                ),
              ),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppDimensions.sheetHeaderMinHeight,
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: AppDimensions.pageGutter,
                end: AppDimensions.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      context.tr(titleKey),
                      style: textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).closeButtonTooltip,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.pageGutter,
                AppDimensions.xs,
                AppDimensions.pageGutter,
                AppDimensions.lg,
              ),
              child: body,
            ),
          ),
          if (footer case final footer?)
            AppFooterBar(color: colors.surface, child: footer),
        ],
      ),
    );
  }
}
