import 'dart:ui' show SemanticsRole;

import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

/// Seed default composition: completed, current, pending, pending without
/// connector. Same as the Widgetbook story.
class VerticalStepperDefault extends StatelessWidget {
  const VerticalStepperDefault({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: t.spacing.s200),
        child: const LooviVerticalStepper(
          semanticLabel: 'Etapas da adesão',
          items: [
            LooviVerticalStepperItem(headline: 'Dados pessoais', supportingText: 'Nome, CPF e contato'),
            LooviVerticalStepperItem(
              headline: 'Dados do veículo',
              supportingText: 'Placa e modelo',
              status: LooviVerticalStepperItemStatus.current,
            ),
            LooviVerticalStepperItem(
              headline: 'Vistoria',
              supportingText: 'Fotos do carro',
              status: LooviVerticalStepperItemStatus.pending,
            ),
            LooviVerticalStepperItem(
              headline: 'Pagamento',
              supportingText: 'Forma de pagamento',
              status: LooviVerticalStepperItemStatus.pending,
              showConnector: false,
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('stacks items with no gap; fills the width', (tester) async {
    await pumpLoovi(tester, const VerticalStepperDefault());
    final items = find.byType(LooviVerticalStepperItem);
    expect(items, findsNWidgets(4));
    expect(tester.getRect(items.at(1)).top, tester.getRect(items.at(0)).bottom);
    expect(tester.getSize(items.first).width, tester.getSize(find.byType(LooviVerticalStepper)).width);
    expect(find.byKey(const ValueKey('connector')), findsNWidgets(3));
  });

  testWidgets('semantics: list of list items, current one says "Etapa atual"', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const VerticalStepperDefault());
    final list = tester.getSemantics(find.byType(LooviVerticalStepper));
    expect(list.getSemanticsData().role, SemanticsRole.list);
    expect(list.label, 'Etapas da adesão');
    final item = tester.getSemantics(find.byType(LooviVerticalStepperItem).at(1));
    expect(item.getSemanticsData().role, SemanticsRole.listItem);
    expect(find.bySemanticsLabel(RegExp(r'^Etapa atual\. Dados do veículo')), findsOneWidget);
    handle.dispose();
  });

  testWidgets('items outside a stepper have no listItem role', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const LooviVerticalStepperItem(headline: 'H'));
    expect(tester.getSemantics(find.byType(LooviVerticalStepperItem)).getSemanticsData().role, SemanticsRole.none);
    handle.dispose();
  });

  testWidgets('golden: default composition', (tester) async {
    await pumpGolden(tester, const VerticalStepperDefault(), height: 360);
    await expectLater(find.byType(VerticalStepperDefault), matchesGoldenFile('../goldens/vertical_stepper_default.png'));
  });
}
