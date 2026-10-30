import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants/template_syntax.dart';

class AppTemplateText extends StatelessWidget {
  const AppTemplateText({
    super.key,
    required this.templateKey,
    required this.values,
    this.emphasized = const {},
    this.style,
  });

  final String templateKey;
  final Map<String, String> values;
  final Set<String> emphasized;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final template = context.tr(templateKey);
    final spans = <InlineSpan>[];
    var cursor = 0;
    for (final match in TemplateSyntax.placeholder.allMatches(template)) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: template.substring(cursor, match.start)));
      }
      final name = match.group(1)!;
      spans.add(
        TextSpan(
          text: values[name] ?? match.group(0),
          style: emphasized.contains(name)
              ? const TextStyle(fontWeight: FontWeight.w600)
              : null,
        ),
      );
      cursor = match.end;
    }
    if (cursor < template.length) {
      spans.add(TextSpan(text: template.substring(cursor)));
    }
    return Text.rich(TextSpan(children: spans), style: style);
  }
}
