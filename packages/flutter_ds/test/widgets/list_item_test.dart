import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

void main() {
  setUpAll(loadGoldenFonts);

  final t = LooviTokens.appCliente;

  testWidgets('renders headline, overline, supporting and meta', (tester) async {
    await pumpLoovi(
      tester,
      const LooviListItem(
        overline: 'Plano Essencial',
        headline: 'Meu veículo',
        supportingText: 'Onix 2022 · placa ABC1D23',
        trailingSupportingText: 'Ativo',
        trailingIcon: LooviIcons.chevronRightOutline,
      ),
    );
    expect(find.text('Plano Essencial'), findsOneWidget);
    expect(find.text('Meu veículo'), findsOneWidget);
    expect(find.text('Onix 2022 · placa ABC1D23'), findsOneWidget);
    expect(find.text('Ativo'), findsOneWidget);
    expect(find.byType(LooviIcon), findsOneWidget);
  });

  testWidgets('min heights per condition (56/72/88) and oneLine hides supporting text', (tester) async {
    final heights = <LooviListItemCondition, double>{};
    for (final c in LooviListItemCondition.values) {
      await pumpLoovi(tester, LooviListItem(key: const Key('row'), condition: c, headline: 'Coberturas do plano', supportingText: 'Roubo e furto'));
      heights[c] = tester.getSize(find.byKey(const Key('row'))).height;
      if (c == LooviListItemCondition.oneLine) expect(find.text('Roubo e furto'), findsNothing);
    }
    expect(heights[LooviListItemCondition.oneLine], t.spacing.s700);
    expect(heights[LooviListItemCondition.twoLine], t.spacing.s900);
    expect(heights[LooviListItemCondition.threeLine], t.spacing.s1100);
  });

  testWidgets('tap fires onTap, pressed paints interactive/pressed, target >= 48', (tester) async {
    var taps = 0;
    await pumpLoovi(
      tester,
      LooviListItem(
        key: const Key('row'),
        condition: LooviListItemCondition.oneLine,
        headline: 'Meu veículo',
        trailingIcon: LooviIcons.chevronRightOutline,
        onTap: () => taps++,
      ),
    );
    final size = tester.getSize(find.byKey(const Key('row')));
    expect(size.height, greaterThanOrEqualTo(48));
    expect(size.width, greaterThanOrEqualTo(48));

    final gesture = await tester.startGesture(tester.getCenter(find.byKey(const Key('row'))));
    await tester.pump();
    final pressedBox = tester.widgetList<DecoratedBox>(find.descendant(of: find.byKey(const Key('row')), matching: find.byType(DecoratedBox)));
    expect(pressedBox.any((d) => (d.decoration as BoxDecoration).color == t.interactive.pressed), isTrue);
    await gesture.up();
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('without onTap: static row, no button semantics, no pressed wash', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const LooviListItem(key: Key('row'), headline: 'Meu veículo', supportingText: 'Onix 2022'));
    await tester.tap(find.byKey(const Key('row')), warnIfMissed: false);
    await tester.pump();
    expect(find.byType(FocusableActionDetector), findsNothing);
    final node = tester.getSemantics(find.byKey(const Key('row')));
    expect(node.getSemanticsData().flagsCollection.isButton, isFalse);
    handle.dispose();
  });

  testWidgets('semantics: button with combined label when interactive', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      LooviListItem(
        key: const Key('row'),
        overline: 'Plano',
        headline: 'Coberturas do plano',
        supportingText: 'Roubo, furto e assistência 24h',
        onTap: () {},
      ),
    );
    final node = tester.getSemantics(find.byKey(const Key('row')));
    expect(node.label, 'Plano, Coberturas do plano, Roubo, furto e assistência 24h');
    expect(node.getSemanticsData().flagsCollection.isButton, isTrue);
    handle.dispose();
  });

  testWidgets('divider uses color/border/2 at border/width/012', (tester) async {
    await pumpLoovi(tester, const LooviListItem(headline: 'Meu veículo', showDivider: true));
    final line = tester.widget<ColoredBox>(find.descendant(of: find.byType(LooviListItemDivider), matching: find.byType(ColoredBox)));
    expect(line.color, t.color.border2);
    expect(tester.getSize(find.byType(LooviListItemDivider)).height, t.spacing.s025);
  });

  testWidgets('golden: variants', (tester) async {
    await pumpGolden(
      tester,
      Column(
        key: const Key('golden'),
        mainAxisSize: MainAxisSize.min,
        children: [
          const LooviListItem(condition: LooviListItemCondition.oneLine, headline: 'Meu veículo', leadingIcon: LooviIcons.carOutline, trailingIcon: LooviIcons.chevronRightOutline, showDivider: true),
          const LooviListItem(condition: LooviListItemCondition.oneLine, overline: 'Titular', headline: 'Ana Souza', leadingIcon: LooviIcons.userOutline, trailingSupportingText: 'Editar', showDivider: true),
          const LooviListItem(condition: LooviListItemCondition.twoLine, headline: 'Coberturas do plano', supportingText: 'Roubo, furto e assistência 24h em todo o Brasil', leading: LooviListItemMonogram('C'), trailingIcon: LooviIcons.chevronRightOutline, showDivider: true),
          const LooviListItem(headline: 'Vistoria do veículo', supportingText: 'Envie as fotos pelo app e acompanhe a análise em até 2 dias úteis.', leading: LooviListItemImageThumbnail(), trailingIcon: LooviIcons.chevronRightOutline, showDivider: true),
          const LooviListItem(headline: 'Documentos', supportingText: 'Apólice e termos do seu plano', leadingIcon: LooviIcons.fileTextOutline),
        ],
      ),
      height: 420,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/list_item_variants.png'));
  });
}
