import 'dart:ui' show SemanticsRole;

import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// Story "Variants": master defaults, no supporting text, no connector.
class FeatureStepsItemVariants extends StatelessWidget {
  const FeatureStepsItemVariants({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s300),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LooviFeatureStepsItem(),
            SizedBox(height: t.spacing.s300),
            const LooviFeatureStepsItem(leadingIcon: LooviIcons.carOutline, showSupportingText: false),
            SizedBox(height: t.spacing.s300),
            const LooviFeatureStepsItem(showConnector: false),
          ],
        ),
      ),
    );
  }
}

Finder _badge() => find
    .descendant(of: find.byType(LooviFeatureStepsItem), matching: find.byType(Container))
    .first;

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('paint: badge 48 surface/2 radius full pad spacing/150, icon 24 text/primary', (tester) async {
    await pumpLoovi(tester, const LooviFeatureStepsItem());
    expect(tester.getSize(_badge()), Size.square(_t.spacing.s600));
    final c = tester.widget<Container>(_badge());
    final deco = c.decoration! as BoxDecoration;
    expect(deco.color, _t.color.backgroundSurface2);
    expect(deco.borderRadius, BorderRadius.circular(_t.radius.full));
    expect(c.padding, EdgeInsets.all(_t.spacing.s150));
    final icon = tester.widget<LooviIcon>(find.byType(LooviIcon));
    expect(icon.name, LooviIcons.squareCheckOutline);
    expect(icon.size, _t.spacing.s300);
    expect(icon.color, _t.text.primary);
  });

  testWidgets('texts: headline body/large/semi-bold text/primary; supporting body/medium/regular text/secondary', (tester) async {
    await pumpLoovi(tester, const LooviFeatureStepsItem());
    final h = tester.widget<Text>(find.text('Label')).style!;
    expect(h.fontSize, _t.typography.bodyLargeSemiBold.fontSize);
    expect(h.fontWeight, _t.typography.bodyLargeSemiBold.fontWeight);
    expect(h.color, _t.text.primary);
    final s = tester.widget<Text>(find.text('Description')).style!;
    expect(s.fontSize, _t.typography.bodyMediumRegular.fontSize);
    expect(s.fontWeight, _t.typography.bodyMediumRegular.fontWeight);
    expect(s.color, _t.text.secondary);
  });

  testWidgets('layout: gap spacing/200, content padding-bottom spacing/300, height 66 (Figma)', (tester) async {
    await pumpLoovi(tester, const LooviFeatureStepsItem());
    final root = tester.getRect(find.byType(LooviFeatureStepsItem));
    expect(root.height, 22 + 20 + _t.spacing.s300);
    expect(tester.getRect(find.text('Label')).left - tester.getRect(_badge()).right, _t.spacing.s200);
    // Connector: spacing/100 wide, from badge bottom to row bottom.
    final connector = find.descendant(of: find.byType(LooviFeatureStepsItem), matching: find.byType(ColoredBox)).first;
    final r = tester.getRect(connector);
    expect(r.width, _t.spacing.s100);
    expect(r.top, tester.getRect(_badge()).bottom);
    expect(r.bottom, root.bottom);
    expect(tester.widget<ColoredBox>(connector).color, _t.color.backgroundSurface2);
  });

  testWidgets('showSupportingText=false: row never shorter than the badge', (tester) async {
    await pumpLoovi(tester, const LooviFeatureStepsItem(showSupportingText: false));
    expect(find.text('Description'), findsNothing);
    expect(tester.getSize(find.byType(LooviFeatureStepsItem)).height, _t.spacing.s600);
  });

  testWidgets('showConnector=false: no connector', (tester) async {
    await pumpLoovi(tester, const LooviFeatureStepsItem(showConnector: false));
    expect(find.descendant(of: find.byType(LooviFeatureStepsItem), matching: find.byType(ColoredBox)), findsNothing);
  });

  testWidgets('semantics: one node, icon decorative; no list role outside FeatureSteps', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const LooviFeatureStepsItem(headline: 'Permissões', supportingText: 'Ative alertas.'));
    final node = tester.getSemantics(find.bySemanticsLabel('Permissões\nAtive alertas.'));
    expect(node.role, SemanticsRole.none);
    expect(node.label, 'Permissões\nAtive alertas.');
    handle.dispose();
  });

  testWidgets('textScaler 2: long copy wraps without overflow', (tester) async {
    await pumpLoovi(
      tester,
      const LooviFeatureStepsItem(headline: 'Enviar fotos e documentos', supportingText: 'São as evidências usadas no momento do atendimento.'),
      textScale: 2,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: variants', (tester) async {
    await pumpGolden(tester, const FeatureStepsItemVariants(), height: 280);
    await expectLater(find.byType(FeatureStepsItemVariants), matchesGoldenFile('../goldens/feature_steps_item_variants.png'));
  });
}
