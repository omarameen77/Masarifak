import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/translation_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../home_cubit.dart';
import '../home_state.dart';

class PendingReviewCard extends StatelessWidget {
  const PendingReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeCubit, HomeState, bool>(
      selector: (state) => state.hasPendingReview,
      builder: (context, hasPendingReview) {
        if (!hasPendingReview) return const SizedBox.shrink();
        final colors = Theme.of(context).extension<AppColors>()!;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.md),
          child: Material(
            color: colors.accSoft,
            borderRadius: BorderRadius.circular(AppDimensions.radius),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.md,
                  horizontal: AppDimensions.inputPaddingHorizontal,
                ),
                child: Row(
                  children: [
                    Icon(Icons.repeat, color: colors.accText),
                    const SizedBox(width: AppDimensions.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr(TranslationKeys.homePendingReviewTitle),
                            style: TextStyle(
                              fontSize: AppDimensions.bodyFontSize,
                              fontWeight: FontWeight.w500,
                              color: colors.ink,
                            ),
                          ),
                          Text(
                            context.tr(TranslationKeys.homePendingReviewAction),
                            style: TextStyle(
                              fontSize: AppDimensions.captionFontSize,
                              color: colors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: colors.muted),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
