import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

Widget _left(Widget child) => Align(alignment: Alignment.topLeft, child: child);

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('web: inverse-4 surface, text tokens, info icon, no leading icon', (tester) async {
    await pumpLoovi(tester, _left(const LooviDashboardCardPrimary()));
    final deco = tester
        .widget<DecoratedBox>(find.descendant(of: find.byType(LooviDashboardCardPrimary), matching: find.byType(DecoratedBox)).first)
        .decoration as BoxDecoration;
    expect(deco.color, _t.color.backgroundSurfaceInverse4);
    expect(deco.borderRadius, BorderRadius.circular(_t.radius.s400));
    expect(tester.widget<Text>(find.text('Title')).style!.color, _t.text.onColorDisabled);
    expect(tester.widget<Text>(find.text('6.838')).style!.color, _t.text.onColor);
    expect(tester.widget<Text>(find.text('6.838')).style!.fontSize, _t.typography.headingH1SemiBold.fontSize);
    final icons = tester.widgetList<LooviIcon>(find.byType(LooviIcon)).map((i) => i.name).toList();
    expect(icons, [LooviIcons.infoCircleOutline]);
  });

  testWidgets('web showInfo=false hides info; mobile has currency icon and never info', (tester) async {
    await pumpLoovi(tester, _left(const LooviDashboardCardPrimary(showInfo: false)));
    expect(find.byType(LooviIcon), findsNothing);
    await pumpLoovi(tester, _left(const LooviDashboardCardPrimary(type: LooviDashboardCardPrimaryType.mobile)));
    final icon = tester.widget<LooviIcon>(find.byType(LooviIcon));
    expect(icon.name, LooviIcons.currencyDollarOutline);
    expect(icon.color, _t.text.onColor);
    expect(tester.widget<Text>(find.text('Title')).style!.fontSize, _t.typography.bodySmallSemiBold.fontSize);
  });

  testWidgets('semantics: one node with title, value and labelled metrics', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      _left(const LooviDashboardCardPrimary(
        title: 'Economia',
        primaryValue: 'R\$ 120',
        label1: 'Mês',
        description1: '10',
        label2: 'Ano',
        description2: '90',
        showInfo: false,
      )),
    );
    expect(find.bySemanticsLabel('Economia: R\$ 120. Mês: 10. Ano: 90'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('info becomes a 48 dp button with onInfoPressed', (tester) async {
    final handle = tester.ensureSemantics();
    var taps = 0;
    await pumpLoovi(tester, _left(LooviDashboardCardPrimary(onInfoPressed: () => taps++)));
    final info = find.bySemanticsLabel('Mais informações');
    expect(info, findsOneWidget);
    expect(tester.getSize(find.byType(LooviTapTarget)), const Size(48, 48));
    await tester.tap(find.byType(LooviTapTarget));
    expect(taps, 1);
    handle.dispose();
  });

  testWidgets('textScaler 2: no overflow', (tester) async {
    await pumpLoovi(tester, _left(const LooviDashboardCardPrimary()), textScale: 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: web + mobile', (tester) async {
    await pumpGolden(
      tester,
      Padding(
        key: const Key('golden'),
        padding: EdgeInsets.all(_t.spacing.s200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LooviDashboardCardPrimary(),
            SizedBox(height: _t.spacing.s200),
            const LooviDashboardCardPrimary(type: LooviDashboardCardPrimaryType.mobile),
          ],
        ),
      ),
      height: 420,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/dashboard_card_primary_variants.png'));
  });
}
