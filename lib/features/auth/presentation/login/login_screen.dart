import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/translation_keys.dart';
import '../../../../core/widgets/app_error_dialog.dart';
import 'login_cubit.dart';
import 'login_failure_message.dart';
import 'login_state.dart';
import 'widgets/login_footer_links.dart';
import 'widgets/login_form.dart';
import 'widgets/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr(TranslationKeys.loginTitle))),
      body: BlocConsumer<LoginCubit, LoginState>(
        listenWhen: (previous, current) =>
            current.failure != null && current.failure != previous.failure,
        listener: (context, state) {
          if (state.failure case final failure?) {
            AppErrorDialog.show(context, messageKey: loginFailureKey(failure));
          }
        },
        builder: (context, state) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.pageGutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LoginHeader(),
              const SizedBox(height: AppDimensions.lg),
              LoginForm(state: state),
              const SizedBox(height: AppDimensions.sm),
              const LoginFooterLinks(),
            ],
          ),
        ),
      ),
    );
  }
}
