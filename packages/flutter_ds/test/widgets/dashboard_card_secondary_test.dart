import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

LooviIcon _icon(WidgetTester tester, String name) =>
    tester.widgetList<LooviIcon>(find.byType(LooviIcon)).firstWhere((i) => i.name == name);

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('web/up: surface/0, brand icon chip, success text + icon, info in text/secondary', (tester) async {
    await pumpLoovi(tester, const SizedBox(width: 210, child: LooviDashboardCardSecondary()));
    final deco = tester
        .widget<DecoratedBox>(find.descendant(of: find.byType(LooviDashboardCardSecondary), matching: find.byType(DecoratedBox)).first)
        .decoration as BoxDecoration;
    expect(deco.color, _t.color.backgroundSurface0);
    expect(_icon(tester, LooviIcons.fileDescriptionOutline).color, _t.text.onColor);
    expect(find.byWidgetPredicate((w) => w is Container && (w.decoration as BoxDecoration?)?.color == _t.text.brand), findsOneWidget);
    expect(tester.widget<Text>(find.text('100%')).style!.color, _t.text.success);
    final growth = _icon(tester, LooviIcons.circleArrowUpRightFilled);
    expect(growth.color, _t.color.actionsSuccess);
    expect(growth.size, _t.spacing.s300);
    expect(_icon(tester, LooviIcons.infoCircleOutline).color, _t.text.secondary);
    expect(tester.widget<Text>(find.text('25')).style!.fontSize, _t.typography.displayLargeBold.fontSize);
  });

  testWidgets('down: danger text + down icon', (tester) async {
    await pumpLoovi(tester, const LooviDashboardCardSecondary(growth: LooviDashboardCardSecondaryGrowth.down));
    expect(tester.widget<Text>(find.text('100%')).style!.color, _t.text.danger);
    expect(_icon(tester, LooviIcons.circleArrowDownRightFilled).color, _t.color.actionsDanger);
  });

  testWidgets('mobile: surface/1, no icon chip, 16 growth icon', (tester) async {
    await pumpLoovi(tester, const SizedBox(width: 116, child: LooviDashboardCardSecondary(type: LooviDashboardCardSecondaryType.mobile)));
    final deco = tester
        .widget<DecoratedBox>(find.descendant(of: find.byType(LooviDashboardCardSecondary), matching: find.byType(DecoratedBox)).first)
        .decoration as BoxDecoration;
    expect(deco.color, _t.color.backgroundSurface1);
    expect(find.byWidgetPredicate((w) => w is LooviIcon && w.name == LooviIcons.fileDescriptionOutline), findsNothing);
    expect(_icon(tester, LooviIcons.circleArrowUpRightFilled).size, _t.spacing.s200);
    expect(tester.takeException(), isNull);
  });

  testWidgets('toggles: showIcon, showInfo, showDescription', (tester) async {
    await pumpLoovi(tester, const LooviDashboardCardSecondary(showIcon: false, showInfo: false, showDescription: false));
    expect(find.byWidgetPredicate((w) => w is LooviIcon && w.name == LooviIcons.fileDescriptionOutline), findsNothing);
    expect(find.byWidgetPredicate((w) => w is LooviIcon && w.name == LooviIcons.infoCircleOutline), findsNothing);
    expect(find.text('12 no mês anterior'), findsNothing);
  });

  testWidgets('semantics: direction spoken, not color only', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const LooviDashboardCardSecondary(showInfo: false, growth: LooviDashboardCardSecondaryGrowth.down));
    expect(find.bySemanticsLabel('Title: 25, Queda de 100%, 12 no mês anterior'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('info button with onInfoPressed', (tester) async {
    var taps = 0;
    await pumpLoovi(tester, Align(alignment: Alignment.topLeft, child: SizedBox(width: 210, child: LooviDashboardCardSecondary(onInfoPressed: () => taps++))));
    await tester.tap(find.byType(LooviTapTarget));
    expect(taps, 1);
  });

  testWidgets('golden: type x growth', (tester) async {
    await pumpGolden(
      tester,
      Padding(
        key: const Key('golden'),
        padding: EdgeInsets.all(_t.spacing.s200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Expanded(child: LooviDashboardCardSecondary()),
              SizedBox(width: _t.spacing.s200),
              const Expanded(child: LooviDashboardCardSecondary(growth: LooviDashboardCardSecondaryGrowth.down)),
            ]),
            SizedBox(height: _t.spacing.s200),
            Row(children: [
              const SizedBox(width: 116, child: LooviDashboardCardSecondary(type: LooviDashboardCardSecondaryType.mobile)),
              SizedBox(width: _t.spacing.s200),
              const SizedBox(
                width: 116,
                child: LooviDashboardCardSecondary(
                  type: LooviDashboardCardSecondaryType.mobile,
                  growth: LooviDashboardCardSecondaryGrowth.down,
                ),
              ),
            ]),
          ],
        ),
      ),
      height: 400,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/dashboard_card_secondary_variants.png'));
  });
}
