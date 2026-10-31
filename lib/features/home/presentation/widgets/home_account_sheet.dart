import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_locales.dart';
import '../../../../core/constants/translation_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../auth/presentation/session/session_cubit.dart';

class HomeAccountSheet extends StatelessWidget {
  const HomeAccountSheet({super.key});

  static Future<void> show(BuildContext context) {
    final session = context.read<SessionCubit>();
    return AppBottomSheet.show<void>(
      context,
      builder: (_) => BlocProvider.value(
        value: session,
        child: const HomeAccountSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return AppBottomSheet(
      titleKey: TranslationKeys.homeAccount,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton.icon(
            onPressed: () => context.setLocale(
              context.locale == AppLocales.arabic
                  ? AppLocales.english
                  : AppLocales.arabic,
            ),
            icon: const Icon(Icons.translate),
            label: Text(context.tr(TranslationKeys.languageToggle)),
          ),
          const SizedBox(height: AppDimensions.sm),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.crit,
              side: BorderSide(color: colors.critLine),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              context.read<SessionCubit>().logout();
            },
            icon: const Icon(Icons.logout),
            label: Text(context.tr(TranslationKeys.homeLogout)),
          ),
        ],
      ),
    );
  }
}
