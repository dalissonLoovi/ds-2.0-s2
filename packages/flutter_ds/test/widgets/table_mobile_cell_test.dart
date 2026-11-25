import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

void main() {
  setUpAll(loadGoldenFonts);

  final t = LooviTokens.appCliente;

  Widget left(Widget child) => Align(alignment: Alignment.topLeft, child: child);

  Color fill(WidgetTester tester) =>
      tester.widget<ColoredBox>(find.descendant(of: find.byType(LooviTableMobileCell), matching: find.byType(ColoredBox)).first).color;

  testWidgets('primary / secondary typography and 64 dp height', (tester) async {
    await pumpLoovi(tester, left(const LooviTableMobileCell(label: 'Nome')));
    final primary = tester.widget<Text>(find.text('Nome'));
    expect(primary.style!.color, t.text.primary);
    expect(primary.style!.fontWeight, t.typography.bodyMediumMedium.fontWeight);
    expect(primary.maxLines, 1);
    expect(tester.getSize(find.byType(LooviTableMobileCell)).height, t.spacing.s800);
    expect(tester.getRect(find.text('Nome')).left, t.spacing.s100);

    await pumpLoovi(tester, left(const LooviTableMobileCell(type: LooviTableMobileCellType.secondary, label: 'Apoio')));
    final secondary = tester.widget<Text>(find.text('Apoio'));
    expect(secondary.style!.color, t.text.secondary);
    expect(secondary.style!.fontSize, t.typography.bodySmallMedium.fontSize);
  });

  testWidgets('state fills', (tester) async {
    for (final (state, color) in [
      (LooviTableMobileCellState.standard, t.color.backgroundSurface0),
      (LooviTableMobileCellState.pressed, t.interactive.pressed),
      (LooviTableMobileCellState.selected, t.interactive.selected),
    ]) {
      await pumpLoovi(tester, left(LooviTableMobileCell(label: 'X', state: state)));
      expect(fill(tester), color, reason: '$state');
    }
  });

  testWidgets('tag renders the slot', (tester) async {
    await pumpLoovi(
      tester,
      left(const LooviTableMobileCell(
        type: LooviTableMobileCellType.tag,
        child: LooviChipTag(label: 'Ativo', size: LooviChipTagSize.sm),
      )),
    );
    expect(find.text('Ativo'), findsOneWidget);
  });

  testWidgets('action: info icon button with callback (48 dp target)', (tester) async {
    var taps = 0;
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      left(LooviTableMobileCell(type: LooviTableMobileCellType.action, label: 'Detalhes', onPressed: () => taps++)),
    );
    expect(find.byWidgetPredicate((w) => w is LooviIcon && w.name == LooviIcons.infoCircleOutline), findsOneWidget);
    await tester.tap(find.byType(LooviButton));
    expect(taps, 1);
    expect(tester.getSize(find.byType(LooviButton)).width, greaterThanOrEqualTo(48));
    expect(tester.getSemantics(find.bySemanticsLabel('Detalhes')).getSemanticsData().flagsCollection.isButton, isTrue);
    handle.dispose();
  });

  testWidgets('action with tooltip: tap opens the LooviTooltip bubble', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(
      tester,
      left(const LooviTableMobileCell(
        type: LooviTableMobileCellType.action,
        label: 'Sobre o valor',
        tooltip: 'Valor com desconto do Pix.',
      )),
    );
    expect(find.text('Valor com desconto do Pix.'), findsNothing);
    await tester.tap(find.byType(LooviTableMobileCell));
    await tester.pumpAndSettle();
    expect(find.text('Valor com desconto do Pix.'), findsOneWidget);
    final data = tester.getSemantics(find.bySemanticsLabel(RegExp('Sobre o valor'))).getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.tooltip, 'Valor com desconto do Pix.');
    handle.dispose();
  });

  testWidgets('icon: plus-outline 24, tappable cell when onPressed', (tester) async {
    var taps = 0;
    await pumpLoovi(
      tester,
      left(LooviTableMobileCell(type: LooviTableMobileCellType.icon, label: 'Adicionar', onPressed: () => taps++)),
    );
    final icon = tester.widget<LooviIcon>(find.byType(LooviIcon));
    expect(icon.name, LooviIcons.plusOutline);
    expect(icon.size, t.spacing.s300);
    expect(icon.color, t.text.primary);
    await tester.tap(find.byType(LooviTableMobileCell));
    expect(taps, 1);
  });

  testWidgets('golden: types × states', (tester) async {
    await pumpGolden(
      tester,
      Column(
        key: const Key('golden'),
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final state in LooviTableMobileCellState.values)
            Row(
              children: [
                Expanded(child: LooviTableMobileCell(label: 'Name of cell', state: state)),
                Expanded(child: LooviTableMobileCell(type: LooviTableMobileCellType.secondary, label: 'Name of cell', state: state)),
                Expanded(
                  child: LooviTableMobileCell(
                    type: LooviTableMobileCellType.tag,
                    state: state,
                    child: const LooviChipTag(label: 'Ativo', size: LooviChipTagSize.sm, intent: LooviChipTagIntent.success),
                  ),
                ),
                LooviTableMobileCell(type: LooviTableMobileCellType.action, label: 'Info', state: state, onPressed: () {}),
                LooviTableMobileCell(type: LooviTableMobileCellType.icon, label: 'Adicionar', state: state),
              ],
            ),
        ],
      ),
      height: 200,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/table_mobile_cell.png'));
  });
}
