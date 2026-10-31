import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';

class SummaryPreviewLoading extends StatelessWidget {
  const SummaryPreviewLoading({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.all(AppDimensions.xl),
    child: Center(child: CircularProgressIndicator()),
  );
}
