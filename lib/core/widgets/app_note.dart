import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../theme/app_colors.dart';

enum AppNoteKind { neutral, ok, warn, critical }

class AppNote extends StatelessWidget {
  const AppNote({
    super.key,
    required this.icon,
    required this.child,
    this.kind = AppNoteKind.neutral,
  });

  final IconData icon;
  final Widget child;
  final AppNoteKind kind;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final (background, border, iconColor, textColor) = switch (kind) {
      AppNoteKind.neutral => (colors.sunk, null, colors.ink2, colors.ink2),
      AppNoteKind.ok => (colors.accSoft, null, colors.accText, colors.ink),
      AppNoteKind.warn => (colors.warnSoft, colors.warnLine, colors.warn, colors.ink),
      AppNoteKind.critical => (
        colors.critSoft,
        colors.critLine,
        colors.crit,
        colors.ink,
      ),
    };
    return Semantics(
      liveRegion: kind == AppNoteKind.critical,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.md,
          horizontal: AppDimensions.inputPaddingHorizontal,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppDimensions.radius),
          border: border == null
              ? null
              : Border.all(color: border, width: AppDimensions.borderWidth),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: AppDimensions.noteIconSize, color: iconColor),
            const SizedBox(width: AppDimensions.noteIconGap),
            Expanded(
              child: DefaultTextStyle.merge(
                style: TextStyle(
                  fontSize: AppDimensions.secondaryFontSize,
                  color: textColor,
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
