import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../core/constants/app_dimensions.dart';
import '../core/constants/app_locales.dart';
import '../core/constants/translation_keys.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.titleKey,
    this.showHomeActions = false,
  });

  final String titleKey;
  final bool showHomeActions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titleKey.tr())),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.pageGutter),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(TranslationKeys.placeholderText.tr()),
            if (showHomeActions) ...[
              const SizedBox(height: AppDimensions.lg),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.setLocale(
                        context.locale == AppLocales.arabic
                            ? AppLocales.english
                            : AppLocales.arabic,
                      ),
                      child: Text(TranslationKeys.languageToggle.tr()),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  const IconButton.outlined(
                    onPressed: null,
                    icon: Icon(Icons.logout_outlined),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
