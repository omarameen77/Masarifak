import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/translation_keys.dart';
import '../login_cubit.dart';
import '../login_intent.dart';

class LoginPasswordVisibilityButton extends StatelessWidget {
  const LoginPasswordVisibilityButton({super.key, required this.isVisible});

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: context.tr(
        isVisible
            ? TranslationKeys.loginHidePassword
            : TranslationKeys.loginShowPassword,
      ),
      onPressed: () => context.read<LoginCubit>().doEvent(
        const LoginPasswordVisibilityToggled(),
      ),
      icon: Icon(
        isVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
      ),
    );
  }
}
