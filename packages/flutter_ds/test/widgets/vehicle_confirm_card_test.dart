import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('plate hero + brandModel, tokens', (tester) async {
    await pumpLoovi(tester, const LooviVehicleConfirmCard(plate: 'ABC1D23', brandModel: 'Fiat Palio'));
    final plate = tester.widget<Text>(find.text('ABC1D23'));
    expect(plate.style!.color, _t.text.primary);
    expect(plate.style!.fontSize, _t.typography.headingH1SemiBold.fontSize);
    expect(tester.widget<Text>(find.text('Fiat Palio')).style!.color, _t.text.secondary);
    final decos = tester
        .widgetList<DecoratedBox>(find.descendant(of: find.byType(LooviVehicleConfirmCard), matching: find.byType(DecoratedBox)))
        .map((d) => d.decoration as BoxDecoration)
        .toList();
    expect(decos.any((d) => d.color == _t.color.backgroundSurface1 && d.borderRadius == BorderRadius.circular(_t.radius.s400)), isTrue);
    expect(decos.any((d) => d.border is Border && (d.border as Border).top.color == _t.color.elevationDisabled), isTrue);
    expect(decos.any((d) => d.color == _t.color.elevationInverse4), isTrue);
    expect(find.byWidgetPredicate((w) => w is ColoredBox && w.color == _t.color.backgroundSurfaceBrand), findsOneWidget);
  });

  testWidgets('semantics: one static node "plate, brandModel"', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const LooviVehicleConfirmCard(key: Key('c'), plate: 'ABC1D23', brandModel: 'Fiat Palio'));
    final node = tester.getSemantics(find.byKey(const Key('c')));
    expect(node.label, 'ABC1D23, Fiat Palio');
    expect(node.getSemanticsData().flagsCollection.isButton, isFalse);
    handle.dispose();
  });

  testWidgets('grows with the text scale (no clipping)', (tester) async {
    await pumpLoovi(tester, const LooviVehicleConfirmCard(key: Key('c')));
    final h1 = tester.getSize(find.byKey(const Key('c'))).height;
    await pumpLoovi(tester, const LooviVehicleConfirmCard(key: Key('c')), textScale: 2);
    expect(tester.getSize(find.byKey(const Key('c'))).height, greaterThan(h1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden', (tester) async {
    await pumpGolden(
      tester,
      Padding(
        key: const Key('golden'),
        padding: EdgeInsets.all(_t.spacing.s300),
        child: const LooviVehicleConfirmCard(),
      ),
      height: 160,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/vehicle_confirm_card.png'));
  });
}
