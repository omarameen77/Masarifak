import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/features/onboarding/data/models/currency_dto.dart';
import 'package:masarifak/features/onboarding/data/models/onboarding_request.dart';
import 'package:masarifak/features/onboarding/data/models/onboarding_response_dto.dart';
import 'package:masarifak/features/onboarding/domain/entities/currency.dart';
import 'package:masarifak/features/onboarding/domain/entities/obligation_category.dart';
import 'package:masarifak/features/onboarding/domain/entities/obligation_draft.dart';
import 'package:masarifak/features/onboarding/domain/entities/obligation_kind.dart';
import 'package:masarifak/features/onboarding/domain/entities/onboarding_draft.dart';
import 'package:masarifak/features/onboarding/domain/entities/onboarding_summary.dart';

void main() {
  test('currency parses the documented GET /currencies item', () {
    final dto = CurrencyDto.fromJson({
      'code': 'EGP',
      'symbol': 'ج.م',
      'exponent': 2,
      'payday_presets': [1, 10, 15, 25],
      'default_week_start': 6,
    });

    expect(
      dto.toDomain(),
      const Currency(
        code: 'EGP',
        symbol: 'ج.م',
        exponent: 2,
        paydayPresets: [1, 10, 15, 25],
        defaultWeekStart: 6,
      ),
    );
  });

  test('request serialises to the documented POST /onboarding body', () {
    final draft = OnboardingDraft(
      currencyCode: 'EGP',
      timezone: 'Africa/Cairo',
      weekStart: 6,
      salaryMinor: 1350000,
      payday: 16,
      safetyBalanceMinor: 200000,
      savingsContributionMinor: 100000,
      savingsOpeningBalanceMinor: 1250000,
      spentSoFarMinor: 0,
      obligations: [
        const ObligationDraft(
          clientId: 'c-1',
          name: 'الإيجار',
          kind: ObligationKind.fixed,
          category: ObligationCategory.housing,
          amountMinor: 300000,
          dueDay: 1,
        ),
        const ObligationDraft(
          clientId: 'c-2',
          name: 'الكهربا',
          kind: ObligationKind.variable,
          category: ObligationCategory.bills,
          amountMinor: 50000,
          dueDay: 10,
        ),
        ObligationDraft(
          clientId: 'c-4',
          name: 'الصيانة',
          kind: ObligationKind.periodic,
          category: ObligationCategory.housing,
          amountMinor: 240000,
          dueDay: 15,
          everyMonths: 6,
          nextDueOn: DateTime(2027, 3, 16),
        ),
      ],
    );

    expect(OnboardingRequest.fromDraft(draft).toJson(), {
      'currency_code': 'EGP',
      'timezone': 'Africa/Cairo',
      'week_start': 6,
      'salary_minor': 1350000,
      'payday': 16,
      'safety_balance_minor': 200000,
      'savings': {
        'contribution_minor': 100000,
        'opening_balance_minor': 1250000,
      },
      'spent_so_far_minor': 0,
      'obligations': [
        {
          'client_id': 'c-1',
          'name': 'الإيجار',
          'kind': 'fixed',
          'category_key': 'housing',
          'amount_minor': 300000,
          'due_day': 1,
        },
        {
          'client_id': 'c-2',
          'name': 'الكهربا',
          'kind': 'variable',
          'category_key': 'bills',
          'amount_minor': 50000,
          'due_day': 10,
        },
        {
          'client_id': 'c-4',
          'name': 'الصيانة',
          'kind': 'periodic',
          'category_key': 'housing',
          'amount_minor': 240000,
          'due_day': 15,
          'every_months': 6,
          'next_due_on': '2027-03-16',
          'opening_balance_minor': 0,
        },
      ],
    });
  });

  test('response parses the documented summary, ids and warnings', () {
    final dto = OnboardingResponseDto.fromJson({
      'summary': {
        'remaining_minor': 425000,
        'spendable_minor': 755000,
        'spent_minor': 330000,
        'reserved_minor': 495000,
        'savings_minor': 100000,
        'daily_budget_minor': 11850,
        'status': 'warn',
      },
      'obligation_ids': {'c-1': '1086227887'},
      'warnings': ['installment_high:c-3'],
    });

    final result = dto.toDomain();
    expect(
      result.summary,
      const OnboardingSummary(
        remainingMinor: 425000,
        spendableMinor: 755000,
        spentMinor: 330000,
        reservedMinor: 495000,
        savingsMinor: 100000,
        dailyBudgetMinor: 11850,
        status: SummaryStatus.warn,
      ),
    );
    expect(result.obligationIds, {'c-1': '1086227887'});
    expect(result.warnings, ['installment_high:c-3']);
  });

  test('dry run response without ids or warnings defaults to empty', () {
    final dto = OnboardingResponseDto.fromJson({
      'summary': {
        'remaining_minor': 0,
        'spendable_minor': 0,
        'spent_minor': 0,
        'reserved_minor': 0,
        'savings_minor': 0,
        'daily_budget_minor': 0,
        'status': 'ok',
      },
    });

    expect(dto.obligationIds, isEmpty);
    expect(dto.warnings, isEmpty);
  });
}
