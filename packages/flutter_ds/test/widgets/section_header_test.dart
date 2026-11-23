import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// Story "Variants": emphasis × showAction (4/4 published). Same as the Widgetbook story.
class SectionHeaderVariants extends StatelessWidget {
  const SectionHeaderVariants({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final e in LooviSectionHeaderEmphasis.values)
              for (final action in [false, true]) ...[
                LooviSectionHeader(
                  title: e == LooviSectionHeaderEmphasis.primary ? 'Coberturas' : 'Ofertas para você',
                  emphasis: e,
                  showAction: action,
                  onActionPressed: () {},
                ),
                SizedBox(height: t.spacing.s300),
              ],
          ],
        ),
      ),
    );
  }
}

Finder _action() => find.byType(LooviHeaderIconAction);

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('primary: body/large/semi-bold + text/primary; secondary: body/medium/regular + text/secondary', (tester) async {
    await pumpLoovi(
      tester,
      const Column(children: [
        LooviSectionHeader(title: 'Coberturas'),
        LooviSectionHeader(title: 'Ofertas', emphasis: LooviSectionHeaderEmphasis.secondary),
      ]),
    );
    final p = tester.widget<Text>(find.text('Coberturas')).style!;
    expect(p.fontSize, _t.typography.bodyLargeSemiBold.fontSize);
    expect(p.fontWeight, _t.typography.bodyLargeSemiBold.fontWeight);
    expect(p.color, _t.text.primary);
    final s = tester.widget<Text>(find.text('Ofertas')).style!;
    expect(s.fontSize, _t.typography.bodyMediumRegular.fontSize);
    expect(s.fontWeight, _t.typography.bodyMediumRegular.fontWeight);
    expect(s.color, _t.text.secondary);
    expect(_action(), findsNothing);
    // showAction=false: height = title line height (22 / 20).
    expect(tester.getSize(find.byType(LooviSectionHeader).first).height, closeTo(22, 0.01));
  });

  testWidgets('action: 32 chip, surface/2 + radius full, icon 16 arrow-narrow-right; flush right', (tester) async {
    var taps = 0;
    await pumpLoovi(tester, LooviSectionHeader(title: 'Coberturas', showAction: true, onActionPressed: () => taps++));
    final chip = find.descendant(of: _action(), matching: find.byType(DecoratedBox)).first;
    final deco = tester.widget<DecoratedBox>(chip).decoration as BoxDecoration;
    expect(deco.color, _t.component.sectionHeader.actionBackground);
    expect(deco.color, _t.color.backgroundSurface2);
    expect(deco.borderRadius, BorderRadius.circular(_t.component.sectionHeader.actionRadius));
    expect(_t.component.sectionHeader.actionRadius, _t.radius.full);
    expect(tester.getSize(chip), Size.square(_t.spacing.s400));
    expect(tester.getRect(chip).right, tester.getRect(find.byType(LooviSectionHeader)).right);
    final icon = tester.widget<LooviIcon>(find.byType(LooviIcon));
    expect(icon.name, LooviIcons.arrowNarrowRightOutline);
    expect(icon.size, _t.spacing.s200);
    expect(icon.color, _t.text.primary);
    await tester.tap(_action());
    expect(taps, 1);
  });

  testWidgets('secondary action icon uses text/secondary', (tester) async {
    await pumpLoovi(
      tester,
      LooviSectionHeader(title: 'T', emphasis: LooviSectionHeaderEmphasis.secondary, showAction: true, onActionPressed: () {}),
    );
    expect(tester.widget<LooviIcon>(find.byType(LooviIcon)).color, _t.text.secondary);
  });

  testWidgets('semantics: title header, action labelled button with >= 48 target', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, LooviSectionHeader(title: 'Coberturas', showAction: true, onActionPressed: () {}));
    expect(tester.getSemantics(find.text('Coberturas')), isSemantics(label: 'Coberturas', isHeader: true));
    expect(
      tester.getSemantics(find.bySemanticsLabel('Ver mais')),
      isSemantics(label: 'Ver mais', isButton: true, isEnabled: true, hasEnabledState: true, hasTapAction: true),
    );
    final s = tester.getSize(_action());
    expect(s.width, greaterThanOrEqualTo(48));
    expect(s.height, greaterThanOrEqualTo(48));
    handle.dispose();
  });

  testWidgets('pressed: interactive/pressed Plus Darker over the chip fill', (tester) async {
    await pumpLoovi(tester, LooviSectionHeader(title: 'T', showAction: true, onActionPressed: () {}));
    final g = await tester.startGesture(tester.getCenter(_action()));
    await tester.pump();
    final deco = tester.widget<DecoratedBox>(find.descendant(of: _action(), matching: find.byType(DecoratedBox)).first).decoration
        as BoxDecoration;
    expect(deco.color, looviPlusDarker(_t.component.sectionHeader.actionBackground, _t.interactive.pressed));
    await g.up();
  });

  testWidgets('textScaler 2: long title ellipsizes without overflow', (tester) async {
    await pumpLoovi(
      tester,
      LooviSectionHeader(title: 'Ofertas exclusivas para o seu veículo', showAction: true, onActionPressed: () {}),
      textScale: 2,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: variants', (tester) async {
    await pumpGolden(tester, const SectionHeaderVariants(), height: 270);
    await expectLater(find.byType(SectionHeaderVariants), matchesGoldenFile('../goldens/section_header_variants.png'));
  });
}
