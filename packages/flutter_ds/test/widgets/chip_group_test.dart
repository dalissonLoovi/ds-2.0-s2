import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

List<LooviChipGroupEntry> _entries({int count = 9, int? selected, VoidCallback? onTap, VoidCallback? onDelete}) => [
      for (var i = 0; i < count; i++)
        LooviChipGroupEntry(
          label: 'Chip 0${i + 1}',
          onPressed: onTap ?? () {},
          selected: i == selected,
          onDelete: onDelete,
        ),
    ];

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('every chip is ChipClickable outline / sm / hug (seed chipMapping)', (tester) async {
    await pumpLoovi(tester, LooviChipGroup(entries: _entries(count: 3), semanticLabel: 'Chips'));
    final chips = tester.widgetList<LooviChipClickable>(find.byType(LooviChipClickable)).toList();
    expect(chips, hasLength(3));
    for (final c in chips) {
      expect(c.intent, LooviChipClickableIntent.outline);
      expect(c.size, LooviChipClickableSize.sm);
      expect(c.width, LooviChipClickableWidth.hug);
      expect(c.showDeleteAction, isFalse);
      expect(c.avatar, isNull);
    }
  });

  testWidgets('single-row-scrollable scrolls horizontally; chips keep one row', (tester) async {
    await pumpLoovi(tester, LooviChipGroup(entries: _entries(count: 12), semanticLabel: 'Chips'));
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    final first = tester.getRect(find.text('Chip 01'));
    final second = tester.getRect(find.text('Chip 02'));
    expect(first.top, second.top);
    expect(tester.getSize(find.byType(LooviChipGroup)).height, 48);
  });

  testWidgets('multi-row-wrap wraps onto more rows', (tester) async {
    await pumpLoovi(
      tester,
      LooviChipGroup(entries: _entries(count: 12), semanticLabel: 'Chips', layout: LooviChipGroupLayout.multiRowWrap),
    );
    expect(find.byType(Wrap), findsOneWidget);
    expect(tester.getSize(find.byType(LooviChipGroup)).height, greaterThan(48));
  });

  testWidgets('filter: tap toggles via callback; selected exposed in semantics', (tester) async {
    final handle = tester.ensureSemantics();
    var taps = 0;
    await pumpLoovi(
      tester,
      LooviChipGroup(
        entries: _entries(count: 3, selected: 0, onTap: () => taps++),
        semanticLabel: 'Filtros',
        type: LooviChipGroupType.filter,
      ),
    );
    await tester.tap(find.text('Chip 02'));
    expect(taps, 1);
    expect(
      tester.getSemantics(find.byType(LooviChipClickable).first),
      isSemantics(label: 'Chip 01', isButton: true, isSelected: true, hasSelectedState: true),
    );
    expect(find.bySemanticsLabel('Filtros'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('input: delete action only when the entry asks for it', (tester) async {
    var deleted = 0;
    await pumpLoovi(
      tester,
      LooviChipGroup(entries: _entries(count: 2, onDelete: () => deleted++), semanticLabel: 'Chips'),
    );
    expect(tester.widget<LooviChipClickable>(find.byType(LooviChipClickable).first).showDeleteAction, isTrue);
    await tester.tap(find.bySemanticsLabel('Remover Chip 01'));
    expect(deleted, 1);
  });

  testWidgets('golden: layouts (single-row / wrap / filter)', (tester) async {
    await pumpGolden(
      tester,
      Container(
        key: const Key('golden'),
        color: LooviTokens.appCliente.color.backgroundSurface0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LooviChipGroup(entries: _entries(), semanticLabel: 'input'),
            LooviChipGroup(entries: _entries(), semanticLabel: 'wrap', layout: LooviChipGroupLayout.multiRowWrap),
            LooviChipGroup(
              entries: _entries(selected: 0),
              semanticLabel: 'filter',
              type: LooviChipGroupType.filter,
              layout: LooviChipGroupLayout.multiRowWrap,
            ),
          ],
        ),
      ),
      height: 260,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/chip_group_layouts.png'));
  });
}
