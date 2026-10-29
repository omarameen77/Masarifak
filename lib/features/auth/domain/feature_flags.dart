import 'package:equatable/equatable.dart';

class FeatureFlags extends Equatable {
  const FeatureFlags(Map<String, bool> flags) : _flags = flags;

  static const FeatureFlags empty = FeatureFlags({});

  final Map<String, bool> _flags;

  bool isEnabled(String key) => _flags[key] ?? false;

  @override
  List<Object?> get props => [_flags];
}
