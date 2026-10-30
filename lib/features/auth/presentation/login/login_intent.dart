sealed class LoginIntent {
  const LoginIntent();
}

final class LoginSubmitted extends LoginIntent {
  const LoginSubmitted(this.email, this.password);

  final String email;
  final String password;
}

final class LoginPasswordVisibilityToggled extends LoginIntent {
  const LoginPasswordVisibilityToggled();
}
