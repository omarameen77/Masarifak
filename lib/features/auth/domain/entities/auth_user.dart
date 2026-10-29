import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerified,
  });

  final String id;
  final String name;
  final String email;
  final bool emailVerified;

  @override
  List<Object?> get props => [id, name, email, emailVerified];
}
