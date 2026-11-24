import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
// Direct src import until lib/loovi_ds.dart exports wave 4 (integration).
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('40 x 40 slot; brand paints the payment-method icon artwork; decorative', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      const Align(child: LooviInputNumberTrailingPaymentMark(brand: LooviInputNumberTrailingPaymentMarkBrand.visa)),
    );
    expect(tester.getSize(find.byType(LooviInputNumberTrailingPaymentMark)), Size.square(_t.spacing.s500));
    final mark = tester.widget<LooviPaymentMethodMark>(find.byType(LooviPaymentMethodMark));
    expect(mark.brand, LooviPaymentMethodMarkBrand.visa);
    expect(mark.type, LooviPaymentMethodMarkType.icon);
    expect(mark.showBackground, isFalse);
    final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect((svg.bytesLoader as SvgAssetLoader).assetName, 'assets/payment_marks/visa-icon.svg');
    expect(find.bySemanticsLabel('Visa'), findsNothing);
    handle.dispose();
  });

  test('preferred brands map to payment-method brands', () {
    expect(
      LooviInputNumberTrailingPaymentMarkBrand.values.map((b) => b.paymentMethodMarkBrand.slug),
      ['visa', 'mastercard', 'elo', 'amex'],
    );
  });

  testWidgets('custom mark replaces the brand artwork', (tester) async {
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
    expect(find.byType(LooviPaymentMethodMark), findsNothing);
  });

  testWidgets('no brand and no mark: empty token placeholder', (tester) async {
    await pumpLoovi(tester, const Align(child: LooviInputNumberTrailingPaymentMark()));
    expect(find.byType(SvgPicture), findsNothing);
    final box = tester.widget<DecoratedBox>(
      find.descendant(of: find.byType(LooviInputNumberTrailingPaymentMark), matching: find.byType(DecoratedBox)),
    );
    expect((box.decoration as BoxDecoration).borderRadius, BorderRadius.circular(_t.radius.s200));
  });

  testWidgets('golden: preferred brands + placeholder', (tester) async {
    await pumpGolden(
      tester,
      Padding(
        key: const Key('golden'),
        padding: EdgeInsets.all(_t.spacing.s200),
        child: Wrap(
          spacing: _t.spacing.s200,
          children: [
            for (final b in LooviInputNumberTrailingPaymentMarkBrand.values) LooviInputNumberTrailingPaymentMark(brand: b),
            const LooviInputNumberTrailingPaymentMark(),
          ],
        ),
      ),
      height: 72,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/input_number_trailing_payment_mark_brands.png'));
  });
}
