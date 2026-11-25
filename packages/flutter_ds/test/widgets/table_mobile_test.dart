import 'dart:ui' show Tristate;

import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _tag = LooviChipTag(label: 'Ativo', size: LooviChipTagSize.sm, intent: LooviChipTagIntent.success);

void main() {
  setUpAll(loadGoldenFonts);

  final t = LooviTokens.appCliente;

  Iterable<LooviTableMobileCell> cells(WidgetTester tester) =>
      tester.widgetList<LooviTableMobileCell>(find.byType(LooviTableMobileCell));

  group('layout by columnCount', () {
    testWidgets('2, no tag: primary + secondary, 64 tall + divider', (tester) async {
      await pumpLoovi(tester, const LooviTableMobile(values: ['Placa', 'ABC1D23']));
      expect(cells(tester).map((c) => c.type), [LooviTableMobileCellType.primary, LooviTableMobileCellType.secondary]);
      expect(tester.getSize(find.byType(LooviTableMobile)).height, t.spacing.s800);
      final deco = tester
          .widget<DecoratedBox>(find.descendant(of: find.byType(LooviTableMobile), matching: find.byType(DecoratedBox)).first)
          .decoration as BoxDecoration;
      expect((deco.border! as Border).bottom.color, t.color.border2);
      expect(tester.widget<DecoratedBox>(find.descendant(of: find.byType(LooviTableMobile), matching: find.byType(DecoratedBox)).first).position, DecorationPosition.foreground);
      expect(find.byType(LooviButton), findsNothing);
    });

    testWidgets('3 with tag: primary, primary, tag', (tester) async {
      await pumpLoovi(tester, const LooviTableMobile(values: ['Plano', 'Mensal'], tag: _tag));
      expect(cells(tester).map((c) => c.type),
          [LooviTableMobileCellType.primary, LooviTableMobileCellType.primary, LooviTableMobileCellType.tag]);
      expect(find.byType(LooviChipTag), findsOneWidget);
    });

    testWidgets('6 with tag: chevron + 3 primary; details hidden until expanded', (tester) async {
      final expandedLog = <bool>[];
      await pumpLoovi(
        tester,
        LooviTableMobile(
          values: const ['Fatura', 'Mar/26', 'R\$ 89', 'Venc. 10/03', 'Pix'],
          tag: _tag,
          onExpandedChanged: expandedLog.add,
        ),
      );
      expect(find.text('Venc. 10/03'), findsNothing);
      expect(find.byType(LooviChipTag), findsNothing);
      expect(tester.getSize(find.byType(LooviTableMobile)).height, t.spacing.s800);

      await tester.tap(find.byType(LooviButton));
      await tester.pumpAndSettle();
      expect(expandedLog, [true]);
      expect(find.text('Venc. 10/03'), findsOneWidget);
      expect(find.byType(LooviChipTag), findsOneWidget);
      expect(tester.getSize(find.byType(LooviTableMobile)).height, t.spacing.s800 + t.spacing.s500);
      // detailRow: first cell starts at spacing/700.
      expect(tester.getRect(find.text('Venc. 10/03')).left, t.spacing.s700);
      final secondary = cells(tester).firstWhere((c) => c.label == 'Venc. 10/03');
      expect(secondary.type, LooviTableMobileCellType.secondary);
    });

    testWidgets('4 without tag, initially expanded: 1 secondary in detailRow', (tester) async {
      await pumpLoovi(tester, const LooviTableMobile(values: ['A', 'B', 'C', 'D'], initiallyExpanded: true));
      expect(cells(tester).where((c) => c.type == LooviTableMobileCellType.secondary).map((c) => c.label), ['D']);
    });
  });

  testWidgets('plus-outline action: 48 dp target and callback', (tester) async {
    var taps = 0;
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      LooviTableMobile(values: const ['A', 'B', 'C'], tag: _tag, onAction: () => taps++, actionLabel: 'Adicionar item'),
    );
    final finder = find.bySemanticsLabel('Adicionar item');
    expect(finder, findsOneWidget);
    final icon = find.byWidgetPredicate((w) => w is LooviIcon && w.name == LooviIcons.plusOutline);
    expect(icon, findsOneWidget);
    await tester.tap(icon);
    expect(taps, 1);
    final cell = find.ancestor(of: icon, matching: find.byType(LooviTableMobileCell));
    final size = tester.getSize(cell);
    expect(size.width, greaterThanOrEqualTo(48));
    expect(size.height, greaterThanOrEqualTo(48));
    handle.dispose();
  });

  testWidgets('row tap: pressed fill while touched, then callback', (tester) async {
    var taps = 0;
    await pumpLoovi(tester, LooviTableMobile(values: const ['Placa', 'ABC1D23'], onTap: () => taps++));
    final gesture = await tester.startGesture(tester.getCenter(find.text('Placa')));
    await tester.pump();
    expect(cells(tester).every((c) => c.state == LooviTableMobileCellState.pressed), isTrue);
    await gesture.up();
    await tester.pump();
    expect(taps, 1);
    expect(cells(tester).every((c) => c.state == LooviTableMobileCellState.standard), isTrue);
  });

  testWidgets('semantics: labelled row with headers; chevron exposes expanded', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      LooviTableMobile(
        values: const ['Fatura', 'Mar/26', 'R\$ 89', 'Pix'],
        headers: const ['Tipo', 'Mês', 'Valor', 'Forma'],
        onTap: () {},
      ),
    );
    final row = tester.getSemantics(find.bySemanticsLabel('Tipo: Fatura, Mês: Mar/26, Valor: R\$ 89'));
    expect(row.getSemanticsData().flagsCollection.isButton, isTrue);

    final toggle = tester.getSemantics(find.bySemanticsLabel('Mostrar detalhes'));
    expect(toggle.getSemanticsData().flagsCollection.isExpanded, Tristate.isFalse);
    await tester.tap(find.byType(LooviButton));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Tipo: Fatura, Mês: Mar/26, Valor: R\$ 89, Forma: Pix'), findsOneWidget);
    final collapse = tester.getSemantics(find.bySemanticsLabel('Ocultar detalhes'));
    expect(collapse.getSemanticsData().flagsCollection.isExpanded, Tristate.isTrue);
    handle.dispose();
  });

  testWidgets('long values truncate on one line; textScaler grows the row', (tester) async {
    await pumpLoovi(
      tester,
      const LooviTableMobile(values: ['Um valor muito longo que não cabe', 'Outro valor longo demais']),
      textScale: 2,
    );
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(LooviTableMobile)).height, greaterThanOrEqualTo(t.spacing.s800));
  });

  testWidgets('golden: compact, collapsed and expanded rows', (tester) async {
    await pumpGolden(
      tester,
      const Column(
        key: Key('golden'),
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LooviTableMobile(values: ['Placa', 'ABC1D23']),
          LooviTableMobile(values: ['Plano', 'Mensal'], tag: _tag),
          LooviTableMobile(values: ['Fatura', 'Mar/26', 'R\$ 89', 'Venc. 10/03', 'Pix'], tag: _tag),
          LooviTableMobile(
            values: ['Fatura', 'Fev/26', 'R\$ 89', 'Venc. 10/02', 'Pix'],
            tag: _tag,
            initiallyExpanded: true,
          ),
          LooviTableMobile(values: ['Fatura', 'Jan/26', 'R\$ 89', 'Venc. 10/01', 'Boleto', 'Pago'], initiallyExpanded: true),
        ],
      ),
      height: 420,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/table_mobile.png'));
  });
}
