import 'package:equatable/equatable.dart';

class VerifiedEmail extends Equatable {
  const VerifiedEmail({required this.email, required this.emailVerified});

  final String email;
  final bool emailVerified;

  @override
  List<Object?> get props => [email, emailVerified];
}
