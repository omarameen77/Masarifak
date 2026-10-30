import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/onboarding_defaults.dart';
import '../../../../core/constants/translation_keys.dart';
import '../../../../core/formatting/app_number_format.dart';
import '../../../../core/widgets/app_money_field.dart';
import '../onboarding_cubit.dart';
import '../onboarding_intent.dart';
import '../onboarding_state.dart';
import '../onboarding_validators.dart';
import '../widgets/onboarding_step_layout.dart';
import 'widgets/cycle_explanation.dart';
import 'widgets/payday_picker.dart';

class OnboardingIncomeScreen extends StatefulWidget {
  const OnboardingIncomeScreen({
    super.key,
    required this.step,
    required this.totalSteps,
  });

  final int step;
  final int totalSteps;

  @override
  State<OnboardingIncomeScreen> createState() => _OnboardingIncomeScreenState();
}

class _OnboardingIncomeScreenState extends State<OnboardingIncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _salary = TextEditingController();
  final _otherDay = TextEditingController();
  int _presetPayday = OnboardingDefaults.defaultPayday;
  bool _isOther = false;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    final state = context.read<OnboardingCubit>().state;
    if (state.salaryMinor case final salary?) {
      _salary.text = AppNumberFormat.editableMajor(
        salary,
        exponent: state.currency.exponent,
      );
    }
    if (state.payday case final payday?) {
      if (state.currency.paydayPresets.contains(payday)) {
        _presetPayday = payday;
      } else {
        _isOther = true;
        _otherDay.text = payday.toString();
      }
    }
  }

  @override
  void dispose() {
    _salary.dispose();
    _otherDay.dispose();
    super.dispose();
  }

  int? get _payday =>
      _isOther ? OnboardingValidators.parseDay(_otherDay.text) : _presetPayday;

  void _submit(OnboardingState state) {
    setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
    final salary = AppNumberFormat.parseMinor(
      _salary.text,
      exponent: state.currency.exponent,
    );
    final payday = _payday;
    if (!(_formKey.currentState?.validate() ?? false) ||
        salary == null ||
        payday == null) {
      return;
    }
    context.read<OnboardingCubit>().doEvent(
      IncomeSubmitted(salaryMinor: salary, payday: payday),
    );
    context.push(AppRoutes.onboardingObligations);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final payday = _payday;
        return OnboardingStepLayout(
          step: widget.step,
          totalSteps: widget.totalSteps,
          titleKey: TranslationKeys.onboardingIncomeTitle,
          leadKey: TranslationKeys.onboardingIncomeLead,
          body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppMoneyField(
                  controller: _salary,
                  labelKey: TranslationKeys.onboardingSalaryLabel,
                  hintKey: TranslationKeys.amountPlaceholder,
                  currencySymbol: state.currency.symbol,
                  large: true,
                  autovalidateMode: _autovalidateMode,
                  validator: OnboardingValidators.positiveAmount(
                    state.currency.exponent,
                    errorKey: TranslationKeys.validationSalaryInvalid,
                  ),
                ),
                const SizedBox(height: AppDimensions.lg),
                PaydayPicker(
                  presets: state.currency.paydayPresets,
                  selectedPreset: _presetPayday,
                  isOther: _isOther,
                  otherController: _otherDay,
                  autovalidateMode: _autovalidateMode,
                  onPresetSelected: (day) => setState(() {
                    _isOther = false;
                    _presetPayday = day;
                  }),
                  onOtherSelected: () => setState(() => _isOther = true),
                  onOtherChanged: (_) => setState(() {}),
                ),
                if (payday != null) ...[
                  const SizedBox(height: AppDimensions.sm),
                  CycleExplanation(
                    today: context.read<OnboardingCubit>().today,
                    payday: payday,
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
