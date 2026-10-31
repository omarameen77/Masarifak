import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/translation_keys.dart';
import '../../../core/formatting/app_number_format.dart';
import '../../../core/money/money_currency.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_note.dart';
import '../../../core/widgets/app_status_tag.dart';
import '../domain/entities/cycle_status.dart';
import '../domain/entities/recent_expense.dart';
import '../domain/entities/upcoming_obligation.dart';

String homeMoney(
  BuildContext context,
  MoneyCurrency currency,
  int minor, {
  bool rounded = false,
}) => AppNumberFormat(context.locale).money(
  minor,
  exponent: currency.exponent,
  symbol: currency.symbol,
  rounded: rounded,
);

extension CycleStatusPresentation on CycleStatus {
  String get labelKey => switch (this) {
    CycleStatus.ok => TranslationKeys.statusOk,
    CycleStatus.warn => TranslationKeys.statusWarn,
    CycleStatus.critical => TranslationKeys.statusCritical,
  };

  IconData get icon => switch (this) {
    CycleStatus.ok => Icons.check,
    CycleStatus.warn => Icons.schedule,
    CycleStatus.critical => Icons.error_outline,
  };

  AppStatusTone get tone => switch (this) {
    CycleStatus.ok => AppStatusTone.ok,
    CycleStatus.warn => AppStatusTone.warn,
    CycleStatus.critical => AppStatusTone.critical,
  };

  AppNoteKind get noteKind => switch (this) {
    CycleStatus.ok => AppNoteKind.ok,
    CycleStatus.warn => AppNoteKind.warn,
    CycleStatus.critical => AppNoteKind.critical,
  };

  Color color(AppColors colors) => switch (this) {
    CycleStatus.ok => colors.acc,
    CycleStatus.warn => colors.warn,
    CycleStatus.critical => colors.crit,
  };
}

extension UpcomingObligationKindPresentation on UpcomingObligationKind {
  IconData get icon => switch (this) {
    UpcomingObligationKind.fixed => Icons.repeat,
    UpcomingObligationKind.variable => Icons.waves,
    UpcomingObligationKind.periodic => Icons.savings_outlined,
    UpcomingObligationKind.debt => Icons.credit_card,
  };
}

extension ObligationDisplayStatusPresentation on ObligationDisplayStatus {
  String get labelKey => switch (this) {
    ObligationDisplayStatus.reserved => TranslationKeys.obligationStatusReserved,
    ObligationDisplayStatus.dueSoon => TranslationKeys.obligationStatusDueSoon,
    ObligationDisplayStatus.late => TranslationKeys.obligationStatusLate,
    ObligationDisplayStatus.awaitingBill =>
      TranslationKeys.obligationStatusAwaitingBill,
    ObligationDisplayStatus.collecting =>
      TranslationKeys.obligationStatusCollecting,
    ObligationDisplayStatus.paid => TranslationKeys.obligationStatusPaid,
    ObligationDisplayStatus.skipped => TranslationKeys.obligationStatusSkipped,
    ObligationDisplayStatus.stopped => TranslationKeys.obligationStatusStopped,
    ObligationDisplayStatus.arrears => TranslationKeys.obligationStatusArrears,
  };

  IconData get icon => switch (this) {
    ObligationDisplayStatus.reserved => Icons.lock_outline,
    ObligationDisplayStatus.dueSoon => Icons.schedule,
    ObligationDisplayStatus.late ||
    ObligationDisplayStatus.arrears => Icons.error_outline,
    ObligationDisplayStatus.awaitingBill => Icons.receipt_long_outlined,
    ObligationDisplayStatus.collecting => Icons.savings_outlined,
    ObligationDisplayStatus.paid => Icons.check,
    ObligationDisplayStatus.skipped => Icons.skip_next_outlined,
    ObligationDisplayStatus.stopped => Icons.stop_circle_outlined,
  };

  AppStatusTone get tone => switch (this) {
    ObligationDisplayStatus.paid => AppStatusTone.ok,
    ObligationDisplayStatus.dueSoon ||
    ObligationDisplayStatus.awaitingBill => AppStatusTone.warn,
    ObligationDisplayStatus.late ||
    ObligationDisplayStatus.arrears => AppStatusTone.critical,
    ObligationDisplayStatus.reserved ||
    ObligationDisplayStatus.collecting ||
    ObligationDisplayStatus.skipped ||
    ObligationDisplayStatus.stopped => AppStatusTone.neutral,
  };
}

extension ExpenseNecessityPresentation on ExpenseNecessity {
  String get labelKey => switch (this) {
    ExpenseNecessity.need => TranslationKeys.necessityNeed,
    ExpenseNecessity.normal => TranslationKeys.necessityNormal,
    ExpenseNecessity.lux => TranslationKeys.necessityLux,
  };
}

IconData expenseCategoryIcon(String key) => switch (key) {
  ExpenseCategoryKeys.food => Icons.restaurant_outlined,
  ExpenseCategoryKeys.grocery => Icons.shopping_basket_outlined,
  ExpenseCategoryKeys.transport => Icons.directions_car_outlined,
  ExpenseCategoryKeys.bills => Icons.bolt_outlined,
  ExpenseCategoryKeys.health => Icons.favorite_border,
  ExpenseCategoryKeys.shopping => Icons.shopping_bag_outlined,
  ExpenseCategoryKeys.fun => Icons.confirmation_number_outlined,
  _ => Icons.more_horiz,
};

abstract final class ExpenseCategoryKeys {
  static const String food = 'food';
  static const String grocery = 'grocery';
  static const String transport = 'transport';
  static const String bills = 'bills';
  static const String health = 'health';
  static const String shopping = 'shopping';
  static const String fun = 'fun';
}
