import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
// Direct src import until lib/loovi_ds.dart exports wave 4 (integration).
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('defaults to visa icon (Figma instance), 40 x 40, decorative', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: LooviListItemLeadingPaymentMark()));
    expect(tester.getSize(find.byType(LooviListItemLeadingPaymentMark)), Size.square(_t.spacing.s500));
    final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect((svg.bytesLoader as SvgAssetLoader).assetName, 'assets/payment_marks/visa-icon.svg');
    expect(find.bySemanticsLabel('Visa'), findsNothing);
    handle.dispose();
  });

  testWidgets('logo keeps h = 40 and widens the slot', (tester) async {
    await pumpLoovi(
      tester,
      const Align(
        alignment: Alignment.topLeft,
        child: LooviListItemLeadingPaymentMark(brand: LooviPaymentMethodMarkBrand.pix, type: LooviPaymentMethodMarkType.logo),
      ),
    );
    expect(tester.getSize(find.byType(LooviListItemLeadingPaymentMark)), Size(_t.spacing.s500 * 86 / 40, _t.spacing.s500));
  });

  testWidgets('works as LooviListItem.leading; headline owns the label', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      const LooviListItem(
        headline: 'Cartão de crédito',
        supportingText: 'Final 1234',
        leading: LooviListItemLeadingPaymentMark(brand: LooviPaymentMethodMarkBrand.mastercard),
      ),
    );
    expect(find.byType(LooviPaymentMethodMark), findsOneWidget);
    expect(find.bySemanticsLabel('Mastercard'), findsNothing);
    handle.dispose();
  });

  testWidgets('golden: in ListItem rows', (tester) async {
    await pumpGolden(
      tester,
      const Column(
        key: Key('golden'),
        mainAxisSize: MainAxisSize.min,
        children: [
          LooviListItem(headline: 'Visa', supportingText: 'Final 1234', leading: LooviListItemLeadingPaymentMark()),
          LooviListItem(
            headline: 'Mastercard',
            supportingText: 'Final 5678',
            leading: LooviListItemLeadingPaymentMark(brand: LooviPaymentMethodMarkBrand.mastercard, showBackground: true),
          ),
          LooviListItem(headline: 'Pix', leading: LooviListItemLeadingPaymentMark(brand: LooviPaymentMethodMarkBrand.pix)),
        ],
      ),
      height: 300,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/list_item_leading_payment_mark_rows.png'));
  });
}
