import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
// Direct src import until lib/loovi_ds.dart exports wave 4 (integration).
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

SvgAssetLoader _loader(WidgetTester tester) => tester.widget<SvgPicture>(find.byType(SvgPicture)).bytesLoader as SvgAssetLoader;

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('default: mark + wordmark with TM, h = 40, labelled Loovi', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: LooviBrandLogo()));
    expect(_loader(tester).assetName, 'assets/brand/brand-logo-default-tm.svg');
    expect(tester.getSize(find.byType(LooviBrandLogo)), Size(_t.spacing.s500 * 239 / 40, _t.spacing.s500));
    expect(find.bySemanticsLabel('Loovi'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('asset + height per type x showTrademark', (tester) async {
    final cases = {
      (LooviBrandLogoType.standard, false): ('brand-logo-default.svg', _t.spacing.s500),
      (LooviBrandLogoType.extended, true): ('brand-logo-extended-tm.svg', _t.spacing.s500),
      (LooviBrandLogoType.extended, false): ('brand-logo-extended.svg', _t.spacing.s500),
      (LooviBrandLogoType.icon, true): ('brand-logo-icon-tm.svg', _t.spacing.s200),
      (LooviBrandLogoType.icon, false): ('brand-logo-icon.svg', _t.spacing.s200),
      (LooviBrandLogoType.app, false): ('brand-logo-app.svg', _t.spacing.s500),
    };
    for (final MapEntry(key: (type, tm), value: (file, h)) in cases.entries) {
      await pumpLoovi(tester, Align(alignment: Alignment.topLeft, child: LooviBrandLogo(type: type, showTrademark: tm)));
      expect(_loader(tester).assetName, 'assets/brand/$file');
      expect(tester.getSize(find.byType(LooviBrandLogo)).height, h);
    }
  });

  testWidgets('app ignores showTrademark (not published) and is a 40 x 40 tile', (tester) async {
    expect(LooviBrandLogo.isPublished(LooviBrandLogoType.app, true), isFalse);
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: LooviBrandLogo(type: LooviBrandLogoType.app)));
    expect(_loader(tester).assetName, 'assets/brand/brand-logo-app.svg');
    expect(tester.getSize(find.byType(LooviBrandLogo)), Size.square(_t.spacing.s500));
  });

  testWidgets('fills re-bind to tokens (color/palette/brand, text/on-color)', (tester) async {
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: LooviBrandLogo(type: LooviBrandLogoType.app)));
    final mapper = _loader(tester).colorMapper! as LooviBrandLogoColorMapper;
    expect(mapper.brand, _t.color.paletteBrand);
    expect(mapper.onColor, _t.text.onColor);
    const other = Color(0xFF123456);
    const custom = LooviBrandLogoColorMapper(brand: other, onColor: other);
    expect(custom.substitute(null, 'path', 'fill', _t.color.paletteBrand), other);
    expect(custom.substitute(null, 'path', 'fill', _t.text.onColor), other);
    expect(custom.substitute(null, 'path', 'fill', const Color(0xFF000000)), const Color(0xFF000000));
  });

  testWidgets('semanticLabel null: decorative', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: LooviBrandLogo(semanticLabel: null)));
    expect(find.bySemanticsLabel('Loovi'), findsNothing);
    handle.dispose();
  });

  testWidgets('golden: type x showTrademark', (tester) async {
    final gap = SizedBox(height: _t.spacing.s200);
    await pumpGolden(
      tester,
      Padding(
        key: const Key('golden'),
        padding: EdgeInsets.all(_t.spacing.s200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LooviBrandLogo(),
            gap,
            const LooviBrandLogo(showTrademark: false),
            gap,
            const FittedBox(child: LooviBrandLogo(type: LooviBrandLogoType.extended)),
            gap,
            const FittedBox(child: LooviBrandLogo(type: LooviBrandLogoType.extended, showTrademark: false)),
            gap,
            const Row(
              children: [
                LooviBrandLogo(type: LooviBrandLogoType.icon),
                SizedBox(width: 16),
                LooviBrandLogo(type: LooviBrandLogoType.icon, showTrademark: false),
                SizedBox(width: 16),
                LooviBrandLogo(type: LooviBrandLogoType.app),
              ],
            ),
          ],
        ),
      ),
      height: 320,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/brand_logo_variants.png'));
  });
}
