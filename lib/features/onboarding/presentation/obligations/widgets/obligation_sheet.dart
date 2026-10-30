import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/constants/onboarding_defaults.dart';
import '../../../../../core/constants/translation_keys.dart';
import '../../../../../core/formatting/app_number_format.dart';
import '../../../../../core/formatting/localized_digits_input_formatter.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../../core/widgets/app_choice_cards.dart';
import '../../../../../core/widgets/app_choice_chips.dart';
import '../../../../../core/widgets/app_choice_option.dart';
import '../../../../../core/widgets/app_labeled_field.dart';
import '../../../../../core/widgets/app_money_field.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../domain/entities/obligation_category.dart';
import '../../../domain/entities/obligation_draft.dart';
import '../../../domain/entities/obligation_kind.dart';
import '../../../domain/entities/pay_cycle.dart';
import '../../../domain/services/pay_cycle_calculator.dart';
import '../../obligation_labels.dart';
import '../../onboarding_cubit.dart';
import '../../onboarding_intent.dart';
import '../../onboarding_validators.dart';
import 'periodic_fields.dart';

class ObligationSheet extends StatefulWidget {
  const ObligationSheet({super.key, this.existing});

  final ObligationDraft? existing;

  static Future<void> show(BuildContext context, {ObligationDraft? existing}) {
    final cubit = context.read<OnboardingCubit>();
    return AppBottomSheet.show<void>(
      context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: ObligationSheet(existing: existing),
      ),
    );
  }

  @override
  State<ObligationSheet> createState() => _ObligationSheetState();
}

class _ObligationSheetState extends State<ObligationSheet> {
  static const int _defaultCycleIndex = 1;

  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _amount = TextEditingController();
  final _total = TextEditingController();
  final _dueDay = TextEditingController();
  late final List<PayCycle> _cycles;
  ObligationKind _kind = ObligationKind.fixed;
  ObligationCategory _category = ObligationCategory.bills;
  int _everyMonths = OnboardingDefaults.defaultEveryMonths;
  int _cycleIndex = _defaultCycleIndex;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<OnboardingCubit>();
    final state = cubit.state;
    _cycles = PayCycleCalculator.upcomingCycles(
      cubit.today,
      state.payday ?? OnboardingDefaults.defaultPayday,
      OnboardingDefaults.upcomingCycleCount,
    );
    final existing = widget.existing;
    if (existing == null) return;
    final exponent = state.currency.exponent;
    final amount = AppNumberFormat.editableMajor(
      existing.amountMinor,
      exponent: exponent,
    );
    _kind = existing.kind;
    _category = existing.category;
    _name.text = existing.name;
    _dueDay.text = existing.dueDay.toString();
    if (existing.kind == ObligationKind.periodic) {
      _total.text = amount;
      _everyMonths = existing.everyMonths ?? _everyMonths;
      final index = _cycles.indexWhere(
        (cycle) =>
            PayCycleCalculator.dueDateIn(cycle, existing.dueDay) ==
            existing.nextDueOn,
      );
      if (index >= 0) _cycleIndex = index;
    } else {
      _amount.text = amount;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    _total.dispose();
    _dueDay.dispose();
    super.dispose();
  }

  bool get _isPeriodic => _kind == ObligationKind.periodic;

  void _save() {
    setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final cubit = context.read<OnboardingCubit>();
    final exponent = cubit.state.currency.exponent;
    final amount = AppNumberFormat.parseMinor(
      _isPeriodic ? _total.text : _amount.text,
      exponent: exponent,
    );
    final dueDay = OnboardingValidators.parseDay(_dueDay.text);
    if (amount == null || dueDay == null) return;
    final draft = ObligationDraft(
      clientId: widget.existing?.clientId ?? '',
      name: _name.text.trim(),
      kind: _kind,
      category: _category,
      amountMinor: amount,
      dueDay: dueDay,
      everyMonths: _isPeriodic ? _everyMonths : null,
      nextDueOn: _isPeriodic
          ? PayCycleCalculator.dueDateIn(_cycles[_cycleIndex], dueDay)
          : null,
    );
    cubit.doEvent(
      widget.existing == null
          ? ObligationAdded(draft)
          : ObligationUpdated(draft),
    );
    Navigator.of(context).pop();
  }

  void _delete() {
    final existing = widget.existing;
    if (existing == null) return;
    context.read<OnboardingCubit>().doEvent(ObligationRemoved(existing.clientId));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final currency = context.read<OnboardingCubit>().state.currency;
    final colors = Theme.of(context).extension<AppColors>()!;
    return AppBottomSheet(
      titleKey: widget.existing == null
          ? TranslationKeys.obligationNewTitle
          : TranslationKeys.obligationEditTitle,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppLabeledField(
              labelKey: TranslationKeys.obligationKindLabel,
              child: AppChoiceCards<ObligationKind>(
                options: [
                  for (final kind in ObligationKind.values)
                    AppChoiceOption(
                      value: kind,
                      label: context.tr(kind.labelKey),
                      description: context.tr(kind.hintKey),
                      icon: kind.icon,
                    ),
                ],
                selected: _kind,
                onSelected: (kind) => setState(() => _kind = kind),
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            AppTextField(
              controller: _name,
              labelKey: TranslationKeys.obligationNameLabel,
              hintKey: TranslationKeys.obligationNameHint,
              validator: OnboardingValidators.obligationName,
              autovalidateMode: _autovalidateMode,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppDimensions.lg),
            if (_isPeriodic)
              PeriodicFields(
                totalController: _total,
                currency: currency,
                everyMonths: _everyMonths,
                cycles: _cycles,
                cycleIndex: _cycleIndex,
                autovalidateMode: _autovalidateMode,
                onEveryChanged: (months) =>
                    setState(() => _everyMonths = months),
                onCycleChanged: (index) => setState(() => _cycleIndex = index),
              )
            else
              AppMoneyField(
                controller: _amount,
                labelKey: _kind == ObligationKind.variable
                    ? TranslationKeys.obligationInitialEstimate
                    : TranslationKeys.obligationMonthlyAmount,
                currencySymbol: currency.symbol,
                autovalidateMode: _autovalidateMode,
                helperText: _kind == ObligationKind.variable
                    ? context.tr(TranslationKeys.obligationVariableHint)
                    : null,
                validator: OnboardingValidators.positiveAmount(
                  currency.exponent,
                ),
              ),
            const SizedBox(height: AppDimensions.lg),
            AppTextField(
              controller: _dueDay,
              labelKey: TranslationKeys.obligationDueDayLabel,
              hintKey: TranslationKeys.dayOfMonthHint,
              validator: OnboardingValidators.dayOfMonth,
              autovalidateMode: _autovalidateMode,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              inputFormatters: const [LocalizedDigitsInputFormatter()],
            ),
            const SizedBox(height: AppDimensions.lg),
            AppLabeledField(
              labelKey: TranslationKeys.obligationCategoryLabel,
              child: AppChoiceChips<ObligationCategory>(
                options: [
                  for (final category in ObligationCategory.values)
                    AppChoiceOption(
                      value: category,
                      label: context.tr(category.labelKey),
                      icon: category.icon,
                    ),
                ],
                selected: _category,
                onSelected: (category) => setState(() => _category = category),
              ),
            ),
            if (widget.existing != null) ...[
              const SizedBox(height: AppDimensions.lg),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.crit,
                  side: BorderSide(color: colors.critLine),
                ),
                onPressed: _delete,
                icon: const Icon(Icons.delete_outline),
                label: Text(context.tr(TranslationKeys.obligationDelete)),
              ),
            ],
          ],
        ),
      ),
      footer: FilledButton(
        onPressed: _save,
        child: Text(context.tr(TranslationKeys.obligationSave)),
      ),
    );
  }
}
