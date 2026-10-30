import 'package:flutter/widgets.dart';

class AppChoiceOption<T> {
  const AppChoiceOption({
    required this.value,
    required this.label,
    this.description,
    this.icon,
  });

  final T value;
  final String label;
  final String? description;
  final IconData? icon;
}
