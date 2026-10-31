import 'package:equatable/equatable.dart';

class HomeProfile extends Equatable {
  const HomeProfile({
    required this.unreadNotifications,
    required this.hasPendingReview,
  });

  final int unreadNotifications;
  final bool hasPendingReview;

  @override
  List<Object?> get props => [unreadNotifications, hasPendingReview];
}
