import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/constants/translation_keys.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/error/failure_messages.dart';
import '../../../../../core/widgets/app_note.dart';
import '../../onboarding_cubit.dart';
import '../../onboarding_intent.dart';

class SummaryPreviewError extends StatelessWidget {
  const SummaryPreviewError({super.key, required this.failure});

  final Failure failure;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppNote(
          kind: AppNoteKind.critical,
          icon: Icons.error_outline,
          child: Text(context.tr(failureMessageKey(failure))),
        ),
        const SizedBox(height: AppDimensions.sm),
        TextButton(
          onPressed: () =>
              context.read<OnboardingCubit>().doEvent(const PreviewRequested()),
          child: Text(context.tr(TranslationKeys.commonRetry)),
        ),
      ],
    );
  }
}
