import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_args.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/translation_keys.dart';
import '../../../../core/formatting/app_number_format.dart';
import '../../../../core/theme/app_colors.dart';

class HomeNotificationsButton extends StatelessWidget {
  const HomeNotificationsButton({super.key, required this.unread});

  final int unread;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final tooltip = unread > 0
        ? context.tr(
            TranslationKeys.homeNotificationsUnread,
            namedArgs: {
              AppArgs.count: AppNumberFormat(context.locale).integer(unread),
            },
          )
        : context.tr(TranslationKeys.homeNotifications);
    return IconButton(
      tooltip: tooltip,
      onPressed: () {},
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.notifications_none),
          if (unread > 0)
            PositionedDirectional(
              top: 0,
              end: 0,
              child: Container(
                width: AppDimensions.unreadDotSize,
                height: AppDimensions.unreadDotSize,
                decoration: BoxDecoration(
                  color: colors.acc,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
