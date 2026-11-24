import 'package:loovi_ds/loovi_ds.dart';
import 'dart:ui' show Tristate;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

LooviIcon _chevron(WidgetTester tester) => tester.widget<LooviIcon>(find.descendant(
      of: find.byType(LooviAccordion),
      matching: find.byWidgetPredicate(
          (w) => w is LooviIcon && (w.name == LooviIcons.chevronDownOutline || w.name == LooviIcons.chevronUpOutline)),
    ));

Widget _full({bool? expanded, bool initiallyExpanded = false, ValueChanged<bool>? onChange, bool disabled = false,
        LooviAccordionSize size = LooviAccordionSize.md, LooviAccordionPadding padding = LooviAccordionPadding.padded}) =>
    LooviAccordion(
      label: 'Plano Loovi',
      showSubtitle: true,
      subtitle: 'Cobertura completa',
      showSummary: true,
      summary: r'R$ 89,90',
      showAction: true,
      actionLabel: 'Ver detalhes',
      onAction: () {},
      expanded: expanded,
      initiallyExpanded: initiallyExpanded,
      onExpandedChange: onChange,
      disabled: disabled,
      size: size,
      padding: padding,
      child: const SizedBox(key: Key('slot'), height: 80),
    );

/// Story "Variants".
class AccordionVariants extends StatelessWidget {
  const AccordionVariants({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget slot() => Text(
          'Assistência 24h, guincho e carro reserva.',
          style: t.typography.bodyMediumRegular.copyWith(color: t.text.secondary),
        );
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LooviAccordion(
            label: 'Plano Loovi',
            showSubtitle: true,
            subtitle: 'Cobertura completa',
            showSummary: true,
            summary: r'R$ 89,90',
            showAction: true,
            actionLabel: 'Ver detalhes',
            onAction: () {},
            initiallyExpanded: true,
            child: slot(),
          ),
          const LooviAccordion(
            label: 'Plano Loovi',
            showSubtitle: true,
            subtitle: 'Cobertura completa',
            showSummary: true,
            summary: r'R$ 89,90',
          ),
          const LooviAccordion(
            label: 'Plano Loovi',
            showSubtitle: true,
            subtitle: 'Cobertura completa',
            showSummary: true,
            summary: r'R$ 89,90',
            disabled: true,
          ),
          LooviAccordion(
            label: 'Plano Loovi',
            showSubtitle: true,
            subtitle: 'Cobertura completa',
            showSummary: true,
            summary: r'R$ 89,90',
            size: LooviAccordionSize.sm,
            initiallyExpanded: true,
            child: slot(),
          ),
          const LooviAccordion(
            label: 'Plano Loovi',
            showSubtitle: true,
            subtitle: 'Cobertura completa',
            size: LooviAccordionSize.sm,
            padding: LooviAccordionPadding.flush,
          ),
        ],
      ),
    );
  }
}

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('uncontrolled: tap toggles, chevron down/up, panel shows slot + action', (tester) async {
    await pumpLoovi(tester, _full());
    expect(find.byKey(const Key('slot')), findsNothing);
    expect(_chevron(tester).name, LooviIcons.chevronDownOutline);
    await tester.tap(find.text('Plano Loovi'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('slot')), findsOneWidget);
    expect(find.text('Ver detalhes'), findsOneWidget);
    expect(_chevron(tester).name, LooviIcons.chevronUpOutline);
    await tester.tap(find.text('Plano Loovi'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('slot')), findsNothing);
  });

  testWidgets('controlled: reports the request, follows the prop', (tester) async {
    final requests = <bool>[];
    await pumpLoovi(tester, _full(expanded: false, onChange: requests.add));
    await tester.tap(find.text('Plano Loovi'));
    await tester.pumpAndSettle();
    expect(requests, [true]);
    expect(find.byKey(const Key('slot')), findsNothing);
  });

  testWidgets('disabled: collapsed, no toggle, text/secondary + chevron text/placeholder', (tester) async {
    final requests = <bool>[];
    await pumpLoovi(tester, _full(disabled: true, initiallyExpanded: true, onChange: requests.add));
    expect(find.byKey(const Key('slot')), findsNothing);
    await tester.tap(find.text('Plano Loovi'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(requests, isEmpty);
    expect(tester.widget<Text>(find.text('Plano Loovi')).style!.color, _t.text.secondary);
    expect(_chevron(tester).color, _t.text.placeholder);
  });

  testWidgets('paint: typography, ink, divider, Figma heights (md 65 / sm 61 / md expanded)', (tester) async {
    await pumpLoovi(tester, _full());
    final label = tester.widget<Text>(find.text('Plano Loovi')).style!;
    expect(label.fontSize, _t.typography.bodyLargeMedium.fontSize);
    expect(label.color, _t.text.primary);
    expect(tester.widget<Text>(find.text('Cobertura completa')).style!.fontSize, _t.typography.bodySmallRegular.fontSize);
    expect(tester.widget<Text>(find.text(r'R$ 89,90')).style!.fontSize, _t.typography.bodyMediumMedium.fontSize);
    expect(_chevron(tester).size, _t.spacing.s200);
    expect(_chevron(tester).color, _t.text.primary);
    final root = tester.widget<DecoratedBox>(
        find.descendant(of: find.byType(LooviAccordion), matching: find.byType(DecoratedBox)).first);
    final side = ((root.decoration as BoxDecoration).border! as Border).bottom;
    expect(side.color, _t.color.border2);
    expect(side.width, _t.borderWidth.s012);
    expect(tester.getSize(find.byType(LooviAccordion)).height, 65);

    await pumpLoovi(tester, _full(size: LooviAccordionSize.sm));
    expect(tester.getSize(find.byType(LooviAccordion)).height, 61);
    expect(tester.widget<Text>(find.text('Plano Loovi')).style!.fontSize, _t.typography.bodyMediumMedium.fontSize);

    // Expanded: 12 + 41 + 12 + slot 80 + 12 + button (40 painted, 48 touch box) + 12.
    await pumpLoovi(tester, KeyedSubtree(key: UniqueKey(), child: _full(initiallyExpanded: true)));
    expect(tester.getSize(find.byType(LooviAccordion)).height, 65 + 80 + _t.spacing.s150 + _t.spacing.s600 + _t.spacing.s150);
  });

  testWidgets('padding: padded spacing/150, flush spacing/0', (tester) async {
    await pumpLoovi(tester, _full());
    expect(tester.getTopLeft(find.text('Plano Loovi')).dx, _t.spacing.s150);
    await pumpLoovi(tester, _full(padding: LooviAccordionPadding.flush));
    expect(tester.getTopLeft(find.text('Plano Loovi')).dx, 0);
  });

  testWidgets('trigger touch area ≥ 48 dp', (tester) async {
    await pumpLoovi(tester, _full(size: LooviAccordionSize.sm));
    expect(tester.getSize(find.byKey(const Key('loovi-accordion-trigger'))).height, greaterThanOrEqualTo(_t.spacing.s600));
  });

  testWidgets('semantics: button + expanded state + full label', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, _full());
    final node = tester.getSemantics(find.bySemanticsLabel(r'Plano Loovi, Cobertura completa, R$ 89,90'));
    expect(node.flagsCollection.isButton, isTrue);
    expect(node.flagsCollection.isExpanded, Tristate.isFalse);
    await tester.tap(find.text('Plano Loovi'));
    await tester.pumpAndSettle();
    expect(
      tester.getSemantics(find.bySemanticsLabel(r'Plano Loovi, Cobertura completa, R$ 89,90')).flagsCollection.isExpanded,
      Tristate.isTrue,
    );
    handle.dispose();
  });

  testWidgets('keyboard: Tab + Enter/Space toggle', (tester) async {
    await pumpLoovi(tester, _full());
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('slot')), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('slot')), findsNothing);
  });

  testWidgets('animates the height; reduced motion = instant', (tester) async {
    await pumpLoovi(tester, _full());
    await tester.tap(find.text('Plano Loovi'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final mid = tester.getSize(find.byType(LooviAccordion)).height;
    expect(mid, greaterThan(65));
    expect(mid, lessThan(65 + 80 + 12 + 48 + 12));
    await tester.pumpAndSettle();

    await tester.pumpWidget(looviHarness(MediaQuery(
      data: const MediaQueryData(disableAnimations: true),
      child: _full(),
    )));
    await tester.tap(find.text('Plano Loovi'));
    await tester.pump();
    await tester.pump();
    expect(tester.getSize(find.byType(LooviAccordion)).height, 65 + 80 + 12 + 48 + 12);
  });

  testWidgets('golden: variants', (tester) async {
    await pumpGolden(tester, const AccordionVariants(), height: 520);
    await expectLater(find.byType(AccordionVariants), matchesGoldenFile('../goldens/accordion_variants.png'));
  });
}
