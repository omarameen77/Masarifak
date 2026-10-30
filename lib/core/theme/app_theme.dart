import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../constants/app_dimensions.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData build(AppColors c) {
    final brightness = ThemeData.estimateBrightnessForColor(c.bg);
    final controlShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusControl),
    );
    OutlineInputBorder inputBorder(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusControl),
      borderSide: BorderSide(color: color),
    );

    return ThemeData(
      brightness: brightness,
      fontFamily: AppAssets.fontFamily,
      extensions: [c],
      scaffoldBackgroundColor: c.bg,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: c.acc,
        onPrimary: c.accInk,
        primaryContainer: c.accSoft,
        onPrimaryContainer: c.accText,
        secondary: c.accText,
        onSecondary: c.accInk,
        error: c.crit,
        onError: c.dangerInk,
        errorContainer: c.critSoft,
        onErrorContainer: c.crit,
        surface: c.surface,
        onSurface: c.ink,
        onSurfaceVariant: c.muted,
        surfaceContainerHighest: c.sunk,
        outline: c.line2,
        outlineVariant: c.line,
        scrim: c.scrim,
        shadow: c.shadow,
      ),
      textTheme: TextTheme(
        bodyMedium: TextStyle(
          fontSize: AppDimensions.bodyFontSize,
          height: AppDimensions.bodyLineHeight,
          color: c.ink,
        ),
        titleMedium: TextStyle(
          fontSize: AppDimensions.titleFontSize,
          fontWeight: FontWeight.w600,
          color: c.ink,
        ),
        titleLarge: TextStyle(
          fontSize: AppDimensions.largeTitleFontSize,
          fontWeight: FontWeight.w600,
          color: c.ink,
        ),
        headlineSmall: TextStyle(
          fontSize: AppDimensions.headingFontSize,
          fontWeight: FontWeight.w600,
          height: AppDimensions.headingLineHeight,
          color: c.ink,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.bg,
        foregroundColor: c.ink2,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: AppDimensions.topBarHeight,
        titleTextStyle: TextStyle(
          fontFamily: AppAssets.fontFamily,
          fontSize: AppDimensions.titleFontSize,
          fontWeight: FontWeight.w600,
          color: c.ink,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(AppDimensions.buttonMinHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.buttonPaddingHorizontal,
          ),
          shape: controlShape,
          backgroundColor: c.acc,
          foregroundColor: c.accInk,
          disabledBackgroundColor: c.acc.withValues(
            alpha: AppDimensions.disabledOpacity,
          ),
          disabledForegroundColor: c.accInk,
          textStyle: const TextStyle(
            fontFamily: AppAssets.fontFamily,
            fontSize: AppDimensions.buttonFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(0, AppDimensions.tapSize),
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xs),
          foregroundColor: c.accText,
          textStyle: const TextStyle(
            fontFamily: AppAssets.fontFamily,
            fontSize: AppDimensions.secondaryFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, AppDimensions.buttonMinHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.buttonPaddingHorizontal,
          ),
          shape: controlShape,
          backgroundColor: c.surface,
          foregroundColor: c.ink,
          side: BorderSide(color: c.line2),
          textStyle: const TextStyle(
            fontFamily: AppAssets.fontFamily,
            fontSize: AppDimensions.buttonFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size.square(AppDimensions.tapSize),
          foregroundColor: c.ink2,
          shape: controlShape,
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        barrierColor: c.scrim,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        titleTextStyle: TextStyle(
          fontFamily: AppAssets.fontFamily,
          fontSize: AppDimensions.titleFontSize,
          fontWeight: FontWeight.w600,
          color: c.ink,
        ),
        contentTextStyle: TextStyle(
          fontFamily: AppAssets.fontFamily,
          fontSize: AppDimensions.bodyFontSize,
          height: AppDimensions.bodyLineHeight,
          color: c.ink2,
        ),
        actionsPadding: const EdgeInsets.all(AppDimensions.lg),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface,
        constraints: const BoxConstraints(minHeight: AppDimensions.inputMinHeight),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.inputPaddingHorizontal,
        ),
        border: inputBorder(c.line2),
        enabledBorder: inputBorder(c.line2),
        focusedBorder: inputBorder(c.acc),
        errorBorder: inputBorder(c.crit),
        focusedErrorBorder: inputBorder(c.crit),
        labelStyle: TextStyle(
          fontSize: AppDimensions.labelFontSize,
          fontWeight: FontWeight.w500,
          color: c.ink2,
        ),
        hintStyle: TextStyle(color: c.muted),
        errorStyle: TextStyle(
          color: c.crit,
          fontSize: AppDimensions.errorFontSize,
        ),
      ),
    );
  }
}
