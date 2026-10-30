import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_error_dialog.dart';
import '../session/session_cubit.dart';
import 'login_cubit.dart';
import 'login_failure_message.dart';
import 'login_state.dart';
import 'widgets/login_brand.dart';
import 'widgets/login_divider.dart';
import 'widgets/login_form.dart';
import 'widgets/login_header.dart';
import 'widgets/login_register_prompt.dart';
import 'widgets/login_telegram_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<LoginCubit, LoginState>(
          listenWhen: (previous, current) =>
              current.outcome != previous.outcome ||
              current.failure != previous.failure,
          listener: (context, state) {
            if (state.outcome case final outcome?) {
              context.read<SessionCubit>().onSignedIn(
                outcome.session,
                outcome.flags,
              );
              return;
            }
            if (state.failure case final failure?) {
              AppErrorDialog.show(
                context,
                messageKey: loginFailureKey(failure),
              );
            }
          },
          builder: (context, state) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.pageGutter,
              vertical: AppDimensions.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LoginBrand(),
                const SizedBox(height: AppDimensions.xl),
                const LoginHeader(),
                const SizedBox(height: AppDimensions.xl),
                LoginForm(state: state),
                const SizedBox(height: AppDimensions.lg),
                const LoginDivider(),
                const SizedBox(height: AppDimensions.lg),
                const LoginTelegramButton(),
                const SizedBox(height: AppDimensions.lg),
                const LoginRegisterPrompt(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
