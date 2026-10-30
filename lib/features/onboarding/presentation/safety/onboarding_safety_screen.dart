import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/number_symbols.dart';
import '../../../../core/constants/onboarding_args.dart';
import '../../../../core/constants/onboarding_defaults.dart';
import '../../../../core/constants/translation_keys.dart';
import '../../../../core/formatting/app_date_format.dart';
import '../../../../core/formatting/app_number_format.dart';
import '../../../../core/widgets/app_money_field.dart';
import '../../domain/services/pay_cycle_calculator.dart';
import '../onboarding_cubit.dart';
import '../onboarding_intent.dart';
import '../onboarding_state.dart';
import '../onboarding_validators.dart';
import '../widgets/onboarding_step_layout.dart';

class OnboardingSafetyScreen extends StatefulWidget {
  const OnboardingSafetyScreen({
    super.key,
    required this.step,
    required this.totalSteps,
  });

  final int step;
  final int totalSteps;

  @override
  State<OnboardingSafetyScreen> createState() => _OnboardingSafetyScreenState();
}

class _OnboardingSafetyScreenState extends State<OnboardingSafetyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _minimum = TextEditingController();
  final _savings = TextEditingController();
  final _spentSoFar = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    final state = context.read<OnboardingCubit>().state;
    final exponent = state.currency.exponent;
    final minimum = state.safetyBalanceMinor ?? _suggestedMinimum(state);
    _minimum.text = AppNumberFormat.editableMajor(minimum, exponent: exponent);
    if (state.savingsContributionMinor > 0) {
      _savings.text = AppNumberFormat.editableMajor(
        state.savingsContributionMinor,
        exponent: exponent,
      );
    }
    if (state.spentSoFarMinor > 0) {
      _spentSoFar.text = AppNumberFormat.editableMajor(
        state.spentSoFarMinor,
        exponent: exponent,
      );
    }
  }

  @override
  void dispose() {
    _minimum.dispose();
    _savings.dispose();
    _spentSoFar.dispose();
    super.dispose();
  }

  int _suggestedMinimum(OnboardingState state) {
    final unit =
        OnboardingDefaults.safetyRoundingMajor *
        pow(NumberSymbols.base, state.currency.exponent).toInt();
    final raw = (state.salaryMinor ?? 0) * OnboardingDefaults.suggestedSafetyFraction;
    return (raw / unit).round() * unit;
  }

  void _submit(OnboardingState state) {
    setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final exponent = state.currency.exponent;
    context.read<OnboardingCubit>().doEvent(
      SafetySubmitted(
        safetyBalanceMinor: OnboardingValidators.parseOptionalMinor(
          _minimum.text,
          exponent: exponent,
        ),
        savingsContributionMinor: OnboardingValidators.parseOptionalMinor(
          _savings.text,
          exponent: exponent,
        ),
        spentSoFarMinor: OnboardingValidators.parseOptionalMinor(
          _spentSoFar.text,
          exponent: exponent,
        ),
      ),
    );
    context.push(AppRoutes.onboardingSummary);
  }

  @override
  Widget build(BuildContext context) {
    final numbers = AppNumberFormat(context.locale);
    final dates = AppDateFormat(context.locale);
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final currency = state.currency;
        final today = context.read<OnboardingCubit>().today;
        final cycle = PayCycleCalculator.cycleOf(
          today,
          state.payday ?? OnboardingDefaults.defaultPayday,
        );
        final isMidCycle = PayCycleCalculator.daysSinceStart(today, cycle) >= 1;
        return OnboardingStepLayout(
          step: widget.step,
          totalSteps: widget.totalSteps,
          titleKey: TranslationKeys.onboardingSafetyTitle,
          leadKey: TranslationKeys.onboardingSafetyLead,
          body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppMoneyField(
                  controller: _minimum,
                  labelKey: TranslationKeys.safetyMinLabel,
                  currencySymbol: currency.symbol,
                  autovalidateMode: _autovalidateMode,
                  validator: OnboardingValidators.amountOrZero(currency.exponent),
                  helperText: context.tr(
                    TranslationKeys.safetyMinHint,
                    namedArgs: {
                      OnboardingArgs.percent: numbers.percent(
                        OnboardingDefaults.suggestedSafetyFraction,
                      ),
                      OnboardingArgs.amount: numbers.money(
                        _suggestedMinimum(state),
                        exponent: currency.exponent,
                        symbol: currency.symbol,
                        rounded: true,
                      ),
                    },
                  ),
                ),
                const SizedBox(height: AppDimensions.lg),
                AppMoneyField(
                  controller: _savings,
                  labelKey: TranslationKeys.safetySavingsLabel,
                  hintKey: TranslationKeys.amountPlaceholder,
                  currencySymbol: currency.symbol,
                  autovalidateMode: _autovalidateMode,
                  validator: OnboardingValidators.amountOrZero(currency.exponent),
                  helperText: context.tr(TranslationKeys.safetySavingsHint),
                ),
                if (isMidCycle) ...[
                  const SizedBox(height: AppDimensions.lg),
                  AppMoneyField(
                    controller: _spentSoFar,
                    labelKey: TranslationKeys.safetySpentLabel,
                    labelNamedArgs: {
                      OnboardingArgs.date: dates.dayMonth(cycle.start),
                    },
                    hintKey: TranslationKeys.amountPlaceholder,
                    currencySymbol: currency.symbol,
                    autovalidateMode: _autovalidateMode,
                    validator: OnboardingValidators.optionalAmount(
                      currency.exponent,
                    ),
                    helperText: context.tr(TranslationKeys.safetySpentHint),
                  ),
                ],
              ],
            ),
          ),
          footer: FilledButton(
            onPressed: () => _submit(state),
            child: Text(context.tr(TranslationKeys.onboardingNext)),
          ),
        );
      },
    );
  }
}
