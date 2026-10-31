import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../theme/app_colors.dart';

class AppSkeletonBox extends StatelessWidget {
  const AppSkeletonBox({
    super.key,
    required this.height,
    this.widthFactor = 1,
    this.radius = AppDimensions.skeletonRadius,
  });

  final double height;
  final double widthFactor;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: colors.sunk,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
    );
  }
}
