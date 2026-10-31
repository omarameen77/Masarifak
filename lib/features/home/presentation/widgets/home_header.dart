import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_args.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/translation_keys.dart';
import '../../../../core/formatting/app_date_format.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/cycle_period.dart';
import '../home_cubit.dart';
import '../home_state.dart';
import 'home_account_sheet.dart';
import 'home_notifications_button.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeCubit, HomeState, (CyclePeriod?, DateTime?, int)>(
      selector: (state) => (
        state.summary?.period,
        state.today,
        state.profile.data?.unreadNotifications ?? 0,
      ),
      builder: (context, data) {
        final (period, today, unread) = data;
        final colors = Theme.of(context).extension<AppColors>()!;
        final dates = AppDateFormat(context.locale);
        return Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            AppDimensions.pageGutter,
            AppDimensions.md,
            AppDimensions.sm,
            AppDimensions.xs,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (period != null && today != null) ...[
                      Semantics(
                        header: true,
                        child: Text(
                          context.tr(
                            TranslationKeys.homeDaysToPayday,
                            namedArgs: {
                              AppArgs.days: dates.days(period.daysLeft(today)),
                            },
                          ),
                          style: TextStyle(
                            fontSize: AppDimensions.headerTitleFontSize,
                            fontWeight: FontWeight.w600,
                            color: colors.ink,
                          ),
                        ),
                      ),
                      Text(
                        context.tr(
                          TranslationKeys.homeCycleLabel,
                          namedArgs: {
                            AppArgs.range: dates.cycleLabel(
                              period.start,
                              period.end,
                            ),
                          },
                        ),
                        style: TextStyle(
                          fontSize: AppDimensions.captionFontSize,
                          color: colors.muted,
                        ),
                      ),
                    ] else
                      Text(
                        context.tr(TranslationKeys.homeTitle),
                        style: TextStyle(
                          fontSize: AppDimensions.headerTitleFontSize,
                          fontWeight: FontWeight.w600,
                          color: colors.ink,
                        ),
                      ),
                  ],
                ),
              ),
              HomeNotificationsButton(unread: unread),
              IconButton(
                tooltip: context.tr(TranslationKeys.homeReport),
                onPressed: () {},
                icon: const Icon(Icons.bar_chart),
              ),
              IconButton(
                tooltip: context.tr(TranslationKeys.homeAccount),
                onPressed: () => HomeAccountSheet.show(context),
                icon: Container(
                  width: AppDimensions.avatarSize,
                  height: AppDimensions.avatarSize,
                  decoration: BoxDecoration(
                    color: colors.accSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person_outline, color: colors.accText),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
