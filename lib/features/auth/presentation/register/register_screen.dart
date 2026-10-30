import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_error_dialog.dart';
import '../session/session_cubit.dart';
import 'register_cubit.dart';
import 'register_failure_message.dart';
import 'register_state.dart';
import 'widgets/register_footer_link.dart';
import 'widgets/register_form.dart';
import 'widgets/register_header.dart';
import 'widgets/register_next_steps_note.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  void _onStateChanged(BuildContext context, RegisterState state) {
    if (state.result case final result?) {
      context.read<SessionCubit>().onSignedIn(result.session, result.flags);
      return;
    }
    if (state.failure case final failure? when !isEmailTakenFailure(failure)) {
      AppErrorDialog.show(context, messageKey: registerFailureKey(failure));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<RegisterCubit, RegisterState>(
        listenWhen: (previous, current) =>
            current.result != previous.result ||
            current.failure != previous.failure,
        listener: _onStateChanged,
        builder: (context, state) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.pageGutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const RegisterHeader(),
              const SizedBox(height: AppDimensions.xl),
              RegisterForm(state: state),
              const SizedBox(height: AppDimensions.md),
              const RegisterNextStepsNote(),
              const SizedBox(height: AppDimensions.lg),
              const RegisterFooterLink(),
            ],
          ),
        ),
      ),
    );
  }
}
