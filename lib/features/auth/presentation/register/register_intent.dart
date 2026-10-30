sealed class RegisterIntent {
  const RegisterIntent();
}

final class RegisterSubmitted extends RegisterIntent {
  const RegisterSubmitted({
    required this.name,
    required this.email,
    required this.password,
    required this.locale,
    required this.digits,
  });

  final String name;
  final String email;
  final String password;
  final String locale;
  final String digits;
}

final class RegisterSubmitAttempted extends RegisterIntent {
  const RegisterSubmitAttempted();
}

final class RegisterPasswordVisibilityToggled extends RegisterIntent {
  const RegisterPasswordVisibilityToggled();
}
