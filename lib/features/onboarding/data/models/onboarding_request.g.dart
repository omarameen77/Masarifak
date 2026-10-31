// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$OnboardingRequestToJson(OnboardingRequest instance) =>
    <String, dynamic>{
      'currency_code': instance.currencyCode,
      'timezone': instance.timezone,
      'week_start': instance.weekStart,
      'salary_minor': instance.salaryMinor,
      'payday': instance.payday,
      'safety_balance_minor': instance.safetyBalanceMinor,
      'savings': instance.savings.toJson(),
      'spent_so_far_minor': instance.spentSoFarMinor,
      'obligations': instance.obligations.map((e) => e.toJson()).toList(),
    };

Map<String, dynamic> _$SavingsRequestToJson(SavingsRequest instance) =>
    <String, dynamic>{
      'contribution_minor': instance.contributionMinor,
      'opening_balance_minor': instance.openingBalanceMinor,
    };

Map<String, dynamic> _$ObligationRequestToJson(ObligationRequest instance) =>
    <String, dynamic>{
      'client_id': instance.clientId,
      'name': instance.name,
      'kind': instance.kind,
      'category_key': instance.categoryKey,
      'amount_minor': instance.amountMinor,
      'due_day': instance.dueDay,
      'every_months': ?instance.everyMonths,
      'next_due_on': ?instance.nextDueOn,
      'opening_balance_minor': ?instance.openingBalanceMinor,
    };
