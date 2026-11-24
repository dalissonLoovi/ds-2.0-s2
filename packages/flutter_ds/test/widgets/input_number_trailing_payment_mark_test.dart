import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
// Direct src import until lib/loovi_ds.dart exports wave 3 (integration).
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('40 x 40 slot; placeholder shows the brand; decorative', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      const Align(child: LooviInputNumberTrailingPaymentMark(brand: LooviInputNumberTrailingPaymentMarkBrand.visa)),
    );
    expect(tester.getSize(find.byType(LooviInputNumberTrailingPaymentMark)), Size.square(_t.spacing.s500));
    expect(find.text('VISA'), findsOneWidget);
    expect(find.bySemanticsLabel('VISA'), findsNothing);
    handle.dispose();
  });

  testWidgets('custom mark replaces the placeholder', (tester) async {
    await pumpLoovi(
      tester,
      const Align(
        child: LooviInputNumberTrailingPaymentMark(
          paymentMethodMark: SizedBox(key: ValueKey('mark'), width: 40, height: 40),
          brand: LooviInputNumberTrailingPaymentMarkBrand.elo,
        ),
      ),
    );
    expect(find.byKey(const ValueKey('mark')), findsOneWidget);
    expect(find.text('ELO'), findsNothing);
  });
}
