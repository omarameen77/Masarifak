import 'package:flutter/material.dart';

import '../../../core/constants/translation_keys.dart';
import '../domain/entities/obligation_category.dart';
import '../domain/entities/obligation_kind.dart';

extension ObligationKindLabels on ObligationKind {
  String get labelKey => switch (this) {
    ObligationKind.fixed => TranslationKeys.obligationKindFixed,
    ObligationKind.variable => TranslationKeys.obligationKindVariable,
    ObligationKind.periodic => TranslationKeys.obligationKindPeriodic,
  };

  String get hintKey => switch (this) {
    ObligationKind.fixed => TranslationKeys.obligationKindFixedHint,
    ObligationKind.variable => TranslationKeys.obligationKindVariableHint,
    ObligationKind.periodic => TranslationKeys.obligationKindPeriodicHint,
  };

  IconData get icon => switch (this) {
    ObligationKind.fixed => Icons.repeat,
    ObligationKind.variable => Icons.waves,
    ObligationKind.periodic => Icons.savings_outlined,
  };
}

extension ObligationCategoryLabels on ObligationCategory {
  String get labelKey => switch (this) {
    ObligationCategory.bills => TranslationKeys.categoryBills,
    ObligationCategory.housing => TranslationKeys.categoryHousing,
    ObligationCategory.transport => TranslationKeys.categoryTransport,
    ObligationCategory.health => TranslationKeys.categoryHealth,
    ObligationCategory.shopping => TranslationKeys.categoryShopping,
  };

  IconData get icon => switch (this) {
    ObligationCategory.bills => Icons.bolt_outlined,
    ObligationCategory.housing => Icons.home_outlined,
    ObligationCategory.transport => Icons.directions_car_outlined,
    ObligationCategory.health => Icons.favorite_border,
    ObligationCategory.shopping => Icons.shopping_bag_outlined,
  };
}
