import 'dart:io';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
// Direct src import until lib/loovi_ds.dart exports wave 4 (integration).
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

String _asset(WidgetTester tester) =>
    (tester.widget<SvgPicture>(find.byType(SvgPicture)).bytesLoader as SvgAssetLoader).assetName;

void main() {
  setUpAll(loadGoldenFonts);

  test('every published variant has a packaged SVG (and nothing else is packaged)', () {
    final expected = <String>{};
    for (final b in LooviPaymentMethodMarkBrand.values) {
      for (final type in LooviPaymentMethodMarkType.values) {
        for (final bg in [false, true]) {
          if (LooviPaymentMethodMark.isPublished(b, type, bg)) {
            expected.add(LooviPaymentMethodMark.assetFor(b, type, bg));
          }
        }
      }
    }
    expect(expected, hasLength(25 * 2 + 11));
    final onDisk = Directory('assets/payment_marks')
        .listSync()
        .whereType<File>()
        .map((f) => 'assets/payment_marks/${f.uri.pathSegments.last}')
        .where((p) => p.endsWith('.svg'))
        .toSet();
    expect(onDisk, expected);
  });

  test('25 brands with kebab-case slugs from the seed catalog', () {
    expect(LooviPaymentMethodMarkBrand.values, hasLength(25));
    expect(LooviPaymentMethodMarkBrand.ifoodBeneficios.slug, 'ifood-beneficios');
    expect(LooviPaymentMethodMarkBrand.values.where((b) => b.hasLogo), hasLength(11));
  });

  testWidgets('icon: 40 x 40, labelled with the brand name', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const Align(child: LooviPaymentMethodMark(brand: LooviPaymentMethodMarkBrand.pix)));
    expect(tester.getSize(find.byType(LooviPaymentMethodMark)), Size.square(_t.spacing.s500));
    expect(_asset(tester), 'assets/payment_marks/pix-icon.svg');
    expect(find.bySemanticsLabel('Pix'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('icon + showBackground uses the badge asset', (tester) async {
    await pumpLoovi(
      tester,
      const Align(child: LooviPaymentMethodMark(brand: LooviPaymentMethodMarkBrand.visa, showBackground: true)),
    );
    expect(_asset(tester), 'assets/payment_marks/visa-icon-bg.svg');
  });

  testWidgets('logo: h = 40, 86:40 lockup', (tester) async {
    await pumpLoovi(
      tester,
      const Align(child: LooviPaymentMethodMark(brand: LooviPaymentMethodMarkBrand.mastercard, type: LooviPaymentMethodMarkType.logo)),
    );
    expect(_asset(tester), 'assets/payment_marks/mastercard-logo.svg');
    expect(tester.getSize(find.byType(LooviPaymentMethodMark)), Size(_t.spacing.s500 * 86 / 40, _t.spacing.s500));
  });

  testWidgets('unpublished combos fall back to the icon', (tester) async {
    // visa has no type=logo.
    const noLogo = LooviPaymentMethodMark(brand: LooviPaymentMethodMarkBrand.visa, type: LooviPaymentMethodMarkType.logo);
    expect(noLogo.resolvedType, LooviPaymentMethodMarkType.icon);
    await pumpLoovi(tester, const Align(child: noLogo));
    expect(_asset(tester), 'assets/payment_marks/visa-icon.svg');
    expect(tester.getSize(find.byType(LooviPaymentMethodMark)), Size.square(_t.spacing.s500));

    // logo never publishes showBackground=true → badge form.
    const logoBg = LooviPaymentMethodMark(
      brand: LooviPaymentMethodMarkBrand.pix,
      type: LooviPaymentMethodMarkType.logo,
      showBackground: true,
    );
    expect(logoBg.resolvedType, LooviPaymentMethodMarkType.icon);
    await pumpLoovi(tester, const Align(child: logoBg));
    expect(_asset(tester), 'assets/payment_marks/pix-icon-bg.svg');
  });

  testWidgets('decorative excludes the label', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      const Align(child: LooviPaymentMethodMark(brand: LooviPaymentMethodMarkBrand.pix, decorative: true)),
    );
    expect(find.bySemanticsLabel('Pix'), findsNothing);
    handle.dispose();
  });

  testWidgets('golden: all brands × published variants', (tester) async {
    final gap = _t.spacing.s100;
    Widget cell(Widget child) => SizedBox(width: _t.spacing.s500 * 86 / 40, height: _t.spacing.s500, child: Align(alignment: Alignment.centerLeft, child: child));
    await pumpGolden(
      tester,
      Padding(
        key: const Key('golden'),
        padding: EdgeInsets.all(_t.spacing.s100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final b in LooviPaymentMethodMarkBrand.values) ...[
              Row(
                children: [
                  SizedBox(
                    width: 96,
                    child: Text(b.slug, style: _t.typography.captionSmallMedium.copyWith(color: _t.text.secondary)),
                  ),
                  cell(LooviPaymentMethodMark(brand: b)),
                  SizedBox(width: gap),
                  cell(LooviPaymentMethodMark(brand: b, showBackground: true)),
                  SizedBox(width: gap),
                  if (b.hasLogo) cell(LooviPaymentMethodMark(brand: b, type: LooviPaymentMethodMarkType.logo)),
                ],
              ),
              SizedBox(height: _t.spacing.s050),
            ],
          ],
        ),
      ),
      height: 1120,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/payment_method_mark_matrix.png'));
  });
}
