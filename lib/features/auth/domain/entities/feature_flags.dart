import 'package:equatable/equatable.dart';

class FeatureFlags extends Equatable {
  const FeatureFlags(this.values);

  const FeatureFlags.empty() : values = const {};

  final Map<String, bool> values;

  bool isEnabled(String key) => values[key] ?? false;

  @override
  List<Object?> get props => [values];
}
