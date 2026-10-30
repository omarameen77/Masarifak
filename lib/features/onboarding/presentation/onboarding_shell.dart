import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../auth/presentation/session/session_cubit.dart';
import 'onboarding_cubit.dart';
import 'onboarding_state.dart';
import 'widgets/onboarding_header.dart';

class OnboardingShell extends StatelessWidget {
  const OnboardingShell({
    super.key,
    required this.step,
    required this.totalSteps,
    required this.child,
  });

  final int step;
  final int totalSteps;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return BlocListener<OnboardingCubit, OnboardingState>(
      listenWhen: (previous, current) =>
          !previous.isCompleted && current.isCompleted,
      listener: (context, _) => context.read<SessionCubit>().completeOnboarding(),
      child: Scaffold(
        backgroundColor: colors.bg,
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OnboardingHeader(step: step, totalSteps: totalSteps),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
