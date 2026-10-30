import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_intent.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(LoginUseCase loginUseCase)
    : _loginUseCase = loginUseCase,
      super(const LoginState());

  final LoginUseCase _loginUseCase;

  void doEvent(LoginIntent intent) {
    switch (intent) {
      case LoginSubmitted(:final email, :final password):
        _submit(email, password);
      case LoginPasswordVisibilityToggled():
        emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
    }
  }

  Future<void> _submit(String email, String password) async {
    emit(
      state.copyWith(isSubmitting: true, clearFailure: true, clearOutcome: true),
    );
    switch (await _loginUseCase(email: email, password: password)) {
      case Success(:final data):
        emit(state.copyWith(isSubmitting: false, outcome: data));
      case Error(:final failure):
        emit(state.copyWith(isSubmitting: false, failure: failure));
    }
  }
}
