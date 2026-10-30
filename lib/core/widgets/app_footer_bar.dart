import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../theme/app_colors.dart';

class AppFooterBar extends StatelessWidget {
  const AppFooterBar({super.key, required this.child, this.color});

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? colors.bg,
        border: Border(
          top: BorderSide(color: colors.line, width: AppDimensions.borderWidth),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.footerPaddingVertical,
            horizontal: AppDimensions.pageGutter,
          ),
          child: child,
        ),
      ),
    );
  }
}
