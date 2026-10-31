import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarifak/core/constants/translation_keys.dart';
import 'package:masarifak/core/theme/app_colors.dart';
import 'package:masarifak/core/widgets/app_bottom_sheet.dart';
import 'package:masarifak/core/widgets/app_bottom_tab_bar.dart';
import 'package:masarifak/core/widgets/app_bottom_tab_item.dart';
import 'package:masarifak/core/widgets/app_choice_cards.dart';
import 'package:masarifak/core/widgets/app_choice_chips.dart';
import 'package:masarifak/core/widgets/app_choice_option.dart';
import 'package:masarifak/core/widgets/app_money_field.dart';
import 'package:masarifak/core/widgets/app_note.dart';
import 'package:masarifak/core/widgets/step_progress_bar.dart';

import '../../helpers/localized_app.dart';

void main() {
  late Map<String, dynamic> arabic;

  setUpAll(() async => arabic = await readArabicTranslations());

  testWidgets('step progress bar fills the bars up to the current step', (tester) async {
    await pumpLocalized(tester, const StepProgressBar(current: 2, total: 4));

    final colors = AppColors.light;
    final fills = tester
        .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
        .map((bar) => (bar.decoration! as BoxDecoration).color)
        .toList();
    expect(fills, [colors.acc, colors.acc, colors.line, colors.line]);
  });

  testWidgets('choice chips report the tapped value', (tester) async {
    int? picked;
    await pumpLocalized(
      tester,
      StatefulBuilder(
        builder: (context, setState) => AppChoiceChips<int>(
          options: const [
            AppChoiceOption(value: 1, label: '١'),
            AppChoiceOption(value: 15, label: '١٥'),
          ],
          selected: picked,
          onSelected: (value) => setState(() => picked = value),
        ),
      ),
    );

    await tester.tap(find.text('١٥'));
    await tester.pump();

    expect(picked, 15);
    expect(
      tester.getSemantics(find.text('١٥')),
      isSemantics(isSelected: true),
    );
  });

  testWidgets('choice cards show the description and select on tap', (tester) async {
    String? picked;
    await pumpLocalized(
      tester,
      StatefulBuilder(
        builder: (context, setState) => AppChoiceCards<String>(
          options: const [
            AppChoiceOption(
              value: 'fixed',
              label: 'Fixed',
              description: 'Known amount',
              icon: Icons.repeat,
            ),
            AppChoiceOption(value: 'variable', label: 'Variable'),
          ],
          selected: picked,
          onSelected: (value) => setState(() => picked = value),
        ),
      ),
    );

    expect(find.text('Known amount'), findsOneWidget);
    await tester.tap(find.text('Variable'));
    await tester.pump();
    expect(picked, 'variable');
  });

  testWidgets('money field accepts Arabic digits and shows the symbol', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await pumpLocalized(
      tester,
      AppMoneyField(
        controller: controller,
        labelKey: TranslationKeys.onboardingIncomeTitle,
        currencySymbol: 'ج.م',
        large: true,
      ),
    );

    await tester.enterText(find.byType(TextField), '٥٠٠٠');
    await tester.pump();

    expect(controller.text, '5000');
    expect(find.text('ج.م'), findsOneWidget);
    expect(
      find.text(arabic[TranslationKeys.onboardingIncomeTitle] as String),
      findsOneWidget,
    );
  });

  testWidgets('note shows its icon and content', (tester) async {
    await pumpLocalized(
      tester,
      const AppNote(
        kind: AppNoteKind.warn,
        icon: Icons.warning_amber_outlined,
        child: Text('Careful'),
      ),
    );

    expect(find.byIcon(Icons.warning_amber_outlined), findsOneWidget);
    expect(find.text('Careful'), findsOneWidget);
  });

  testWidgets('bottom tab bar keeps its own height and reports taps', (tester) async {
    int? tapped;
    await pumpLocalized(
      tester,
      Column(
        children: [
          const Expanded(child: SizedBox.expand()),
          AppBottomTabBar(
            selectedIndex: 0,
            onSelected: (index) => tapped = index,
            items: const [
              AppBottomTabItem(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: 'Home',
              ),
              AppBottomTabItem(
                icon: Icons.list_outlined,
                selectedIcon: Icons.list,
                label: 'List',
              ),
            ],
          ),
        ],
      ),
    );

    final barHeight = tester.getSize(find.byType(AppBottomTabBar)).height;
    expect(barHeight, lessThan(tester.view.physicalSize.height / 4));
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.list_outlined), findsOneWidget);

    await tester.tap(find.text('List'));
    expect(tapped, 1);
  });

  testWidgets('bottom sheet shows its title, body and footer and closes', (tester) async {
    await pumpLocalized(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => AppBottomSheet.show<void>(
            context,
            builder: (_) => const AppBottomSheet(
              titleKey: TranslationKeys.onboardingObligationsTitle,
              body: Text('Body'),
              footer: Text('Footer'),
            ),
          ),
          child: const Text('Open'),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(
      find.text(arabic[TranslationKeys.onboardingObligationsTitle] as String),
      findsOneWidget,
    );
    expect(find.text('Body'), findsOneWidget);
    expect(find.text('Footer'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('Body'), findsNothing);
  });
}
