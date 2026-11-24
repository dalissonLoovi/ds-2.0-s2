import 'package:loovi_ds/loovi_ds.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// Story "Variants": full-width · inset · middle-inset · with-subhead.
class DividerHorizontalVariants extends StatelessWidget {
  const DividerHorizontalVariants({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: t.spacing.s200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final v in LooviDividerHorizontalVariant.values) ...[
              LooviDividerHorizontal(variant: v, label: 'Meus veículos'),
              SizedBox(height: t.spacing.s400),
            ],
          ],
        ),
      ),
    );
  }
}

Rect _line(WidgetTester tester, Key key) => tester.getRect(
      find.descendant(of: find.byKey(key), matching: find.byType(ColoredBox)).first,
    );

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('line: border/width/012 in color/border/2', (tester) async {
    await pumpLoovi(tester, const LooviDividerHorizontal());
    final box = tester.widget<ColoredBox>(find.descendant(of: find.byType(LooviDividerHorizontal), matching: find.byType(ColoredBox)));
    expect(box.color, _t.color.border2);
    expect(tester.getSize(find.byType(LooviDividerHorizontal)).height, _t.borderWidth.s012);
  });

  testWidgets('insets: full-width 0 · inset start spacing/250 · middle-inset both', (tester) async {
    await pumpLoovi(
      tester,
      const Column(children: [
        LooviDividerHorizontal(key: Key('f')),
        LooviDividerHorizontal(key: Key('i'), variant: LooviDividerHorizontalVariant.inset),
        LooviDividerHorizontal(key: Key('m'), variant: LooviDividerHorizontalVariant.middleInset),
      ]),
    );
    final f = _line(tester, const Key('f'));
    expect(f.left, 0);
    expect(f.width, 390);
    final i = _line(tester, const Key('i'));
    expect(i.left, _t.spacing.s250);
    expect(i.right, 390);
    final m = _line(tester, const Key('m'));
    expect(m.left, _t.spacing.s250);
    expect(m.right, 390 - _t.spacing.s250);
  });

  testWidgets('with-subhead: padding spacing/250, gap spacing/050, body/small/medium on-color-disabled', (tester) async {
    await pumpLoovi(
      tester,
      const LooviDividerHorizontal(key: Key('s'), variant: LooviDividerHorizontalVariant.withSubhead, label: 'Pagamentos'),
    );
    final line = _line(tester, const Key('s'));
    final label = tester.getRect(find.text('Pagamentos'));
    expect(line.left, _t.spacing.s250);
    expect(line.right, 390 - _t.spacing.s250);
    expect(label.top - line.bottom, _t.spacing.s050);
    expect(label.left, _t.spacing.s250);
    final style = tester.widget<Text>(find.text('Pagamentos')).style!;
    expect(style.color, _t.text.secondary);
    expect(style.fontSize, _t.typography.bodySmallMedium.fontSize);
    expect(style.fontWeight, _t.typography.bodySmallMedium.fontWeight);
  });

  testWidgets('label is ignored outside with-subhead', (tester) async {
    await pumpLoovi(tester, const LooviDividerHorizontal(variant: LooviDividerHorizontalVariant.inset, label: 'X'));
    expect(find.text('X'), findsNothing);
  });

  testWidgets('semantics: decorative by default; separator opt-in; subhead label exposed', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      const Column(children: [
        LooviDividerHorizontal(),
        LooviDividerHorizontal(key: Key('sep'), decorative: false),
        LooviDividerHorizontal(variant: LooviDividerHorizontalVariant.withSubhead, label: 'Pagamentos'),
      ]),
    );
    expect(find.bySemanticsLabel('Separador'), findsOneWidget);
    expect(find.bySemanticsLabel('Pagamentos'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('non-interactive', (tester) async {
    await pumpLoovi(tester, const LooviDividerHorizontal(variant: LooviDividerHorizontalVariant.withSubhead, label: 'A'));
    expect(find.descendant(of: find.byType(LooviDividerHorizontal), matching: find.byType(GestureDetector)), findsNothing);
  });

  testWidgets('golden: variants', (tester) async {
    await pumpGolden(tester, const DividerHorizontalVariants(), height: 200);
    await expectLater(find.byType(DividerHorizontalVariants), matchesGoldenFile('../goldens/divider_horizontal_variants.png'));
  });
}
