import 'dart:ui' show SemanticsRole;

import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

List<Widget> _rows({VoidCallback? onTap}) => [
      LooviListItem(condition: LooviListItemCondition.twoLine, headline: 'Meu veículo', supportingText: 'Onix 2022 · ABC1D23', leading: const LooviListItemMonogram('O'), showDivider: true, onTap: onTap),
      LooviListItem(condition: LooviListItemCondition.twoLine, headline: 'Coberturas do plano', supportingText: 'Roubo, furto e assistência 24h', leadingIcon: LooviIcons.shieldCheckOutline, showDivider: true, onTap: onTap),
      LooviListItem(condition: LooviListItemCondition.twoLine, headline: 'Pagamentos', supportingText: 'Próxima fatura em 10/12', leadingIcon: LooviIcons.walletOutline, onTap: onTap),
    ];

BoxDecoration _shell(WidgetTester tester) => tester
    .widget<DecoratedBox>(find.descendant(of: find.byType(LooviList), matching: find.byType(DecoratedBox)).first)
    .decoration as BoxDecoration;

void main() {
  setUpAll(loadGoldenFonts);

  final t = LooviTokens.appCliente;

  testWidgets('container radius == component.listAction.containerRadius (20) on both types', (tester) async {
    expect(t.component.listAction.containerRadius, 20);
    for (final type in LooviListType.values) {
      await pumpLoovi(tester, LooviList(type: type, children: _rows()));
      expect(_shell(tester).borderRadius, BorderRadius.circular(20));
      expect(_shell(tester).color, t.color.backgroundSurface0);
    }
  });

  testWidgets('dropdown: elevation/2 shadow + 8 dp vertical padding; plain: none', (tester) async {
    await pumpLoovi(tester, LooviList(children: _rows()));
    expect(_shell(tester).boxShadow, LooviEffects.box(t.effects.elevation2));
    final dropdownH = tester.getSize(find.byType(LooviList)).height;

    await pumpLoovi(tester, LooviList(type: LooviListType.plain, children: _rows()));
    expect(_shell(tester).boxShadow, isNull);
    expect(dropdownH - tester.getSize(find.byType(LooviList)).height, t.spacing.s100 * 2);
  });

  testWidgets('rows are tappable inside the list; each row >= 48 dp', (tester) async {
    var taps = 0;
    await pumpLoovi(tester, LooviList(children: _rows(onTap: () => taps++)));
    await tester.tap(find.text('Coberturas do plano'));
    expect(taps, 1);
    for (final e in find.byType(LooviListItem).evaluate()) {
      expect(tester.getSize(find.byWidget(e.widget)).height, greaterThanOrEqualTo(48));
    }
  });

  testWidgets('semantics: list role with listItem rows', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, LooviList(type: LooviListType.plain, semanticLabel: 'Meu plano', children: _rows(onTap: () {})));
    final list = tester.getSemantics(find.byType(LooviList));
    expect(list.getSemanticsData().role, SemanticsRole.list);
    final row = tester.getSemantics(find.byType(LooviListItem).first);
    expect(row.getSemanticsData().role, SemanticsRole.listItem);
    expect(row.getSemanticsData().flagsCollection.isButton, isTrue);
    handle.dispose();
  });

  testWidgets('showScroll paints the palette/graph thumb', (tester) async {
    await pumpLoovi(tester, LooviList(showScroll: true, children: _rows()));
    final thumb = find.byWidgetPredicate((w) => w is Container && w.decoration is BoxDecoration && (w.decoration! as BoxDecoration).color == t.color.paletteGraph);
    expect(thumb, findsOneWidget);
    expect(tester.getSize(thumb), Size(t.spacing.s050, t.spacing.s800));
  });

  testWidgets('golden: variants', (tester) async {
    await pumpGolden(
      tester,
      ColoredBox(
        key: const Key('golden'),
        color: t.color.backgroundSurface1,
        child: Padding(
          padding: EdgeInsets.all(t.spacing.s200),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LooviList(children: _rows()),
              SizedBox(height: t.spacing.s400),
              LooviList(type: LooviListType.plain, showScroll: true, children: _rows()),
            ],
          ),
        ),
      ),
      height: 560,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/list_variants.png'));
  });
}
