import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/translation_keys.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/widgets/app_error_dialog.dart';
import '../../domain/entities/onboarding_result.dart';
import '../onboarding_cubit.dart';
import '../onboarding_intent.dart';
import '../onboarding_state.dart';
import '../widgets/onboarding_step_layout.dart';
import 'widgets/summary_actions.dart';
import 'widgets/summary_body.dart';
import 'widgets/summary_preview_error.dart';
import 'widgets/summary_preview_loading.dart';

class OnboardingSummaryScreen extends StatefulWidget {
  const OnboardingSummaryScreen({
    super.key,
    required this.step,
    required this.totalSteps,
  });

  final int step;
  final int totalSteps;

  @override
  State<OnboardingSummaryScreen> createState() =>
      _OnboardingSummaryScreenState();
}

class _OnboardingSummaryScreenState extends State<OnboardingSummaryScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<OnboardingCubit>();
    if (cubit.state.preview == null) {
      cubit.doEvent(const PreviewRequested());
    }
  }

  Future<void> _onCompletionFailed(Failure failure) async {
    await AppErrorDialog.show(context, messageKey: failureMessageKey(failure));
    if (!mounted) return;
    if (failure case ValidationFailure(:final step?)
        when step >= 1 && step < AppRoutes.onboardingSteps.length) {
      context.go(AppRoutes.onboardingSteps[step - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listenWhen: (previous, current) =>
          previous.isCompleting && !current.isCompleting,
      listener: (context, state) {
        if (state.failure case final failure?) _onCompletionFailed(failure);
      },
      builder: (context, state) {
        final preview = state.preview;
        return OnboardingStepLayout(
          step: widget.step,
          totalSteps: widget.totalSteps,
          titleKey: TranslationKeys.onboardingSummaryTitle,
          leadKey: TranslationKeys.onboardingSummaryLead,
          body: switch ((preview, state.failure)) {
            (final OnboardingResult result, _) => SummaryBody(
              state: state,
              result: result,
            ),
            (null, final Failure failure) when !state.isPreviewing =>
              SummaryPreviewError(failure: failure),
            _ => const SummaryPreviewLoading(),
          },
          footer: SummaryActions(
            isCompleting: state.isCompleting,
            onStart: preview == null
                ? null
                : () => context.read<OnboardingCubit>().doEvent(
                    const CompletionRequested(),
                  ),
          ),
        );
      },
    );
  }
}
