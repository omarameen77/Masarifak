import 'package:json_annotation/json_annotation.dart';

import '../../../../core/constants/api_onboarding_values.dart';
import '../../domain/entities/obligation_category.dart';
import '../../domain/entities/obligation_draft.dart';
import '../../domain/entities/obligation_kind.dart';
import '../../domain/entities/onboarding_draft.dart';

part 'onboarding_request.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.snake,
  createFactory: false,
  explicitToJson: true,
)
class OnboardingRequest {
  const OnboardingRequest({
    required this.currencyCode,
    required this.timezone,
    required this.weekStart,
    required this.salaryMinor,
    required this.payday,
    required this.safetyBalanceMinor,
    required this.savings,
    required this.spentSoFarMinor,
    required this.obligations,
  });

  factory OnboardingRequest.fromDraft(OnboardingDraft draft) =>
      OnboardingRequest(
        currencyCode: draft.currencyCode,
        timezone: draft.timezone,
        weekStart: draft.weekStart,
        salaryMinor: draft.salaryMinor,
        payday: draft.payday,
        safetyBalanceMinor: draft.safetyBalanceMinor,
        savings: SavingsRequest(
          contributionMinor: draft.savingsContributionMinor,
          openingBalanceMinor: draft.savingsOpeningBalanceMinor,
        ),
        spentSoFarMinor: draft.spentSoFarMinor,
        obligations: draft.obligations.map(ObligationRequest.fromDraft).toList(),
      );

  final String currencyCode;
  final String timezone;
  final int weekStart;
  final int salaryMinor;
  final int payday;
  final int safetyBalanceMinor;
  final SavingsRequest savings;
  final int spentSoFarMinor;
  final List<ObligationRequest> obligations;

  Map<String, dynamic> toJson() => _$OnboardingRequestToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, createFactory: false)
class SavingsRequest {
  const SavingsRequest({
    required this.contributionMinor,
    required this.openingBalanceMinor,
  });

  final int contributionMinor;
  final int openingBalanceMinor;

  Map<String, dynamic> toJson() => _$SavingsRequestToJson(this);
}

@JsonSerializable(
  fieldRename: FieldRename.snake,
  createFactory: false,
  includeIfNull: false,
)
class ObligationRequest {
  const ObligationRequest({
    required this.clientId,
    required this.name,
    required this.kind,
    required this.categoryKey,
    required this.amountMinor,
    required this.dueDay,
    this.everyMonths,
    this.nextDueOn,
    this.openingBalanceMinor,
  });

  factory ObligationRequest.fromDraft(ObligationDraft draft) {
    final isPeriodic = draft.kind == ObligationKind.periodic;
    return ObligationRequest(
      clientId: draft.clientId,
      name: draft.name,
      kind: _kindValue(draft.kind),
      categoryKey: _categoryValue(draft.category),
      amountMinor: draft.amountMinor,
      dueDay: draft.dueDay,
      everyMonths: isPeriodic ? draft.everyMonths : null,
      nextDueOn: isPeriodic ? _dateValue(draft.nextDueOn) : null,
      openingBalanceMinor: isPeriodic
          ? ApiOnboardingValues.periodicOpeningBalanceMinor
          : null,
    );
  }

  final String clientId;
  final String name;
  final String kind;
  final String categoryKey;
  final int amountMinor;
  final int dueDay;
  final int? everyMonths;
  final String? nextDueOn;
  final int? openingBalanceMinor;

  Map<String, dynamic> toJson() => _$ObligationRequestToJson(this);

  static String _kindValue(ObligationKind kind) => switch (kind) {
    ObligationKind.fixed => ApiOnboardingValues.kindFixed,
    ObligationKind.variable => ApiOnboardingValues.kindVariable,
    ObligationKind.periodic => ApiOnboardingValues.kindPeriodic,
  };

  static String _categoryValue(ObligationCategory category) =>
      switch (category) {
        ObligationCategory.bills => ApiOnboardingValues.categoryBills,
        ObligationCategory.housing => ApiOnboardingValues.categoryHousing,
        ObligationCategory.transport => ApiOnboardingValues.categoryTransport,
        ObligationCategory.health => ApiOnboardingValues.categoryHealth,
        ObligationCategory.shopping => ApiOnboardingValues.categoryShopping,
      };

  static String? _dateValue(DateTime? date) {
    if (date == null) return null;
    String part(int value) => value.toString().padLeft(
      ApiOnboardingValues.datePartWidth,
      ApiOnboardingValues.datePadding,
    );
    return [
      date.year.toString(),
      part(date.month),
      part(date.day),
    ].join(ApiOnboardingValues.dateSeparator);
  }
}
