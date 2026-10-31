import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/translation_keys.dart';
import '../../../../core/widgets/app_list_group.dart';
import '../../../../core/widgets/app_list_row.dart';
import '../../../../core/theme/app_colors.dart';
import '../home_cubit.dart';
import '../home_intent.dart';

class HomeSectionError extends StatelessWidget {
  const HomeSectionError({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return AppListGroup(
      children: [
        AppListRow(
          icon: Icons.cloud_off_outlined,
          iconColor: colors.crit,
          title: context.tr(TranslationKeys.homeSectionFailed),
          subtitle: context.tr(TranslationKeys.commonRetry),
          onTap: () => context.read<HomeCubit>().doEvent(const HomeRetried()),
        ),
      ],
    );
  }
}
