import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/translation_keys.dart';
import 'login_cubit.dart';
import 'login_failure_message.dart';
import 'login_state.dart';
import 'widgets/login_error_note.dart';
import 'widgets/login_footer_links.dart';
import 'widgets/login_form.dart';
import 'widgets/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr(TranslationKeys.loginTitle))),
      body: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.pageGutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LoginHeader(),
              const SizedBox(height: AppDimensions.lg),
              if (state.failure case final failure?) ...[
                LoginErrorNote(messageKey: loginFailureKey(failure)),
                const SizedBox(height: AppDimensions.md),
              ],
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
