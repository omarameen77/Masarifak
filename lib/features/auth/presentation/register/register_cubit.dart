import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../../domain/usecases/register_usecase.dart';
import 'register_intent.dart';
import 'register_state.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(RegisterUseCase registerUseCase)
    : _registerUseCase = registerUseCase,
      super(const RegisterState());

  final RegisterUseCase _registerUseCase;

  void doEvent(RegisterIntent intent) {
    switch (intent) {
      case RegisterSubmitted():
        _submit(intent);
      case RegisterSubmitAttempted():
        emit(state.copyWith(hasSubmitted: true));
      case RegisterPasswordVisibilityToggled():
        emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
    }
  }

  Future<void> _submit(RegisterSubmitted intent) async {
    emit(
      state.copyWith(isSubmitting: true, clearFailure: true, clearResult: true),
    );
    final outcome = await _registerUseCase(
      name: intent.name,
      email: intent.email,
      password: intent.password,
      locale: intent.locale,
      digits: intent.digits,
    );
    switch (outcome) {
      case Success(:final data):
        emit(state.copyWith(isSubmitting: false, result: data));
      case Error(:final failure):
        emit(state.copyWith(isSubmitting: false, failure: failure));
    }
  }
}
