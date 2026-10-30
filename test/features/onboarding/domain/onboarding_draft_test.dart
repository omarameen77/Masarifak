import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/features/onboarding/domain/entities/obligation_category.dart';
import 'package:masarifak/features/onboarding/domain/entities/obligation_draft.dart';
import 'package:masarifak/features/onboarding/domain/entities/obligation_kind.dart';
import 'package:masarifak/features/onboarding/domain/entities/onboarding_draft.dart';

void main() {
  const fixed = ObligationDraft(
    clientId: 'c-1',
    name: 'Rent',
    kind: ObligationKind.fixed,
    category: ObligationCategory.housing,
    amountMinor: 300000,
    dueDay: 1,
  );
  const variable = ObligationDraft(
    clientId: 'c-2',
    name: 'Electricity',
    kind: ObligationKind.variable,
    category: ObligationCategory.bills,
    amountMinor: 50000,
    dueDay: 10,
  );
  final periodic = ObligationDraft(
    clientId: 'c-4',
    name: 'Maintenance',
    kind: ObligationKind.periodic,
    category: ObligationCategory.housing,
    amountMinor: 240000,
    dueDay: 15,
    everyMonths: 6,
    nextDueOn: DateTime(2027, 3, 16),
  );

  test('fixed and variable reserve their full amount monthly', () {
    expect(fixed.monthlyShareMinor, 300000);
    expect(variable.monthlyShareMinor, 50000);
  });

  test('periodic reserves the full amount split over its months', () {
    expect(periodic.monthlyShareMinor, 40000);
  });

  test('draft reserved total sums the monthly shares', () {
    final draft = OnboardingDraft(
      currencyCode: 'EGP',
      timezone: 'Africa/Cairo',
      weekStart: 6,
      salaryMinor: 1350000,
      payday: 16,
      safetyBalanceMinor: 200000,
      savingsContributionMinor: 100000,
      savingsOpeningBalanceMinor: 0,
      spentSoFarMinor: 0,
      obligations: [fixed, variable, periodic],
    );

    expect(draft.reservedMinor, 390000);
  });
}
