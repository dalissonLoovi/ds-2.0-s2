import 'dart:ui' show SemanticsRole;

import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// Seed default composition (app onboarding).
const featureStepsDefaultItems = [
  LooviFeatureStepsItem(
    leadingIcon: LooviIcons.squareCheckOutline,
    headline: 'Permissões',
    supportingText: 'Ative localização e alertas para resposta mais rápida.',
  ),
  LooviFeatureStepsItem(
    leadingIcon: LooviIcons.carOutline,
    headline: 'Confirmar Veículo',
    supportingText: 'Vincula sua proteção ao veículo certo.',
  ),
  LooviFeatureStepsItem(
    leadingIcon: LooviIcons.trophyOutline,
    headline: 'Enviar fotos e documentos',
    supportingText: 'São as evidências usadas no momento do atendimento.',
    showConnector: false,
  ),
];

/// Story "Default": seed composition. Same as the Widgetbook story.
class FeatureStepsDefault extends StatelessWidget {
  const FeatureStepsDefault({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s300),
        child: const LooviFeatureSteps(items: featureStepsDefaultItems),
      ),
    );
  }
}

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('container: gap spacing/0, connector of item i meets badge of item i+1', (tester) async {
    await pumpLoovi(tester, const LooviFeatureSteps(items: featureStepsDefaultItems));
    final items = find.byType(LooviFeatureStepsItem);
    expect(items, findsNWidgets(3));
    expect(tester.getRect(items.at(1)).top, tester.getRect(items.first).bottom);
    final connectors = find.descendant(of: items.first, matching: find.byType(ColoredBox));
    expect(tester.getRect(connectors.first).bottom, tester.getRect(items.first).bottom);
  });

  testWidgets('semantics: list with list items (headline + supporting text)', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const LooviFeatureSteps(items: featureStepsDefaultItems, semanticLabel: 'Próximos passos'));
    final list = tester.getSemantics(find.bySemanticsLabel('Próximos passos'));
    expect(list.role, SemanticsRole.list);
    final item = tester.getSemantics(find.bySemanticsLabel(RegExp('^Permissões')));
    expect(item.role, SemanticsRole.listItem);
    expect(item.label, 'Permissões\nAtive localização e alertas para resposta mais rápida.');
    handle.dispose();
  });

  testWidgets('textScaler 2: wraps without overflow', (tester) async {
    await pumpLoovi(tester, const LooviFeatureSteps(items: featureStepsDefaultItems), textScale: 2);
    expect(tester.takeException(), isNull);
    expect(_t.spacing.s0, 0);
  });

  testWidgets('golden: default', (tester) async {
    await pumpGolden(tester, const FeatureStepsDefault(), height: 300);
    await expectLater(find.byType(FeatureStepsDefault), matchesGoldenFile('../goldens/feature_steps_default.png'));
  });
}
