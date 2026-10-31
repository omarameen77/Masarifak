import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/translation_keys.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/widgets/app_note.dart';
import '../home_cubit.dart';
import '../home_intent.dart';
import '../home_state.dart';
import 'home_header.dart';

class HomeErrorView extends StatelessWidget {
  const HomeErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HomeHeader(),
        Padding(
          padding: const EdgeInsets.all(AppDimensions.pageGutter),
          child: BlocSelector<HomeCubit, HomeState, Failure?>(
            selector: (state) => state.failure,
            builder: (context, failure) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppNote(
                  kind: AppNoteKind.critical,
                  icon: Icons.error_outline,
                  child: Text(
                    context.tr(
                      failure == null
                          ? TranslationKeys.errorUnknown
                          : failureMessageKey(failure),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.md),
                FilledButton(
                  onPressed: () =>
                      context.read<HomeCubit>().doEvent(const HomeRetried()),
                  child: Text(context.tr(TranslationKeys.commonRetry)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
