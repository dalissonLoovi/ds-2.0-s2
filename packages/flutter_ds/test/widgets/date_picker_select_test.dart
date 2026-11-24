// Direct src imports until lib/loovi_ds.dart exports DatePickerSelect / Item (wave 3 integration).
import 'dart:ui' show Tristate;

import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

BoxDecoration _deco(WidgetTester tester, Finder item) =>
    tester.widget<DecoratedBox>(find.descendant(of: item, matching: find.byType(DecoratedBox)).first).decoration
        as BoxDecoration;

void main() {
  setUpAll(loadGoldenFonts);

  group('DatePickerSelectItem', () {
    testWidgets('renders value + chevron-down; tap calls back', (tester) async {
      var taps = 0;
      await pumpLoovi(
        tester,
        Center(
          child: LooviDatePickerSelectItem(value: '21', onTap: () => taps++),
        ),
      );
      expect(find.text('21'), findsOneWidget);
      expect(tester.widget<LooviIcon>(find.byType(LooviIcon)).name, LooviIcons.chevronDownOutline);
      await tester.tap(find.byType(LooviDatePickerSelectItem));
      expect(taps, 1);
    });

    testWidgets('expanded: chevron-up + interactive/focus 1 dp stroke', (tester) async {
      await pumpLoovi(tester, Center(child: LooviDatePickerSelectItem(expanded: true, onTap: () {})));
      expect(tester.widget<LooviIcon>(find.byType(LooviIcon)).name, LooviIcons.chevronUpOutline);
      final deco = _deco(tester, find.byType(LooviDatePickerSelectItem));
      expect(deco.border, Border.all(color: _t.interactive.focus, width: _t.borderWidth.s012));
      expect(deco.borderRadius, BorderRadius.circular(_t.radius.s100));
    });

    testWidgets('disabled: placeholder colors, no tap, never expanded', (tester) async {
      var taps = 0;
      await pumpLoovi(
        tester,
        Center(child: LooviDatePickerSelectItem(enabled: false, expanded: true, onTap: () => taps++)),
      );
      await tester.tap(find.byType(LooviDatePickerSelectItem));
      expect(taps, 0);
      expect(tester.widget<Text>(find.text('21')).style!.color, _t.text.placeholder);
      final icon = tester.widget<LooviIcon>(find.byType(LooviIcon));
      expect(icon.name, LooviIcons.chevronDownOutline);
      expect(icon.color, _t.text.placeholder);
    });

    testWidgets('paint 40 inside a 48 dp target; icon 20', (tester) async {
      await pumpLoovi(tester, Center(child: LooviDatePickerSelectItem(onTap: () {})));
      final paint = find
          .descendant(of: find.byType(LooviDatePickerSelectItem), matching: find.byType(DecoratedBox))
          .first;
      expect(tester.getSize(paint).height, _t.spacing.s500);
      expect(tester.getSize(find.byType(LooviDatePickerSelectItem)).height, greaterThanOrEqualTo(48));
      expect(tester.getSize(find.byType(LooviIcon)), Size.square(_t.spacing.s250));
    });

    testWidgets('pressed: interactive/pressed fill', (tester) async {
      await pumpLoovi(tester, Center(child: LooviDatePickerSelectItem(onTap: () {})));
      final gesture = await tester.startGesture(tester.getCenter(find.byType(LooviDatePickerSelectItem)));
      await tester.pump();
      expect(_deco(tester, find.byType(LooviDatePickerSelectItem)).color, _t.interactive.pressed);
      await gesture.up();
    });

    testWidgets('semantics: button named unit + value, expanded flag', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpLoovi(
        tester,
        Center(
          child: LooviDatePickerSelectItem(
            unit: LooviDatePickerSelectItemUnit.month,
            value: 'Abril',
            expanded: true,
            onTap: () {},
          ),
        ),
      );
      final data = tester.getSemantics(find.byType(LooviDatePickerSelectItem)).getSemanticsData();
      expect(data.label, 'Mês Abril');
      expect(data.flagsCollection.isButton, isTrue);
      expect(data.flagsCollection.isExpanded, Tristate.isTrue);
      handle.dispose();
    });
  });

  group('DatePickerSelect', () {
    testWidgets('format composes the right units in order', (tester) async {
      for (final (format, units) in [
        (LooviDatePickerSelectFormat.dayMonthYear, ['21', 'Abril', '2025']),
        (LooviDatePickerSelectFormat.dayMonth, ['21', 'Abril']),
        (LooviDatePickerSelectFormat.monthYear, ['Abril', '2025']),
        (LooviDatePickerSelectFormat.year, ['2025']),
      ]) {
        await pumpLoovi(tester, LooviDatePickerSelect(format: format));
        final values = tester
            .widgetList<LooviDatePickerSelectItem>(find.byType(LooviDatePickerSelectItem))
            .map((i) => i.value)
            .toList();
        expect(values, units, reason: format.name);
      }
    });

    testWidgets('unit taps report the unit; expandedUnit opens one block', (tester) async {
      final taps = <LooviDatePickerSelectItemUnit>[];
      await pumpLoovi(
        tester,
        LooviDatePickerSelect(expandedUnit: LooviDatePickerSelectItemUnit.year, onUnitTap: taps.add),
      );
      await tester.tap(find.text('Abril'));
      expect(taps, [LooviDatePickerSelectItemUnit.month]);
      final expanded = tester
          .widgetList<LooviDatePickerSelectItem>(find.byType(LooviDatePickerSelectItem))
          .map((i) => i.expanded)
          .toList();
      expect(expanded, [false, false, true]);
    });

    testWidgets('disabled propagates to every block; gap spacing/100', (tester) async {
      await pumpLoovi(tester, LooviDatePickerSelect(enabled: false, onUnitTap: (_) {}));
      final items = tester.widgetList<LooviDatePickerSelectItem>(find.byType(LooviDatePickerSelectItem));
      expect(items.every((i) => !i.enabled), isTrue);
      expect(tester.widget<Wrap>(find.byType(Wrap)).spacing, _t.spacing.s100);
    });

    testWidgets('textScaler 2: wraps without overflow', (tester) async {
      await pumpLoovi(tester, LooviDatePickerSelect(onUnitTap: (_) {}), textScale: 2);
      expect(tester.takeException(), isNull);
    });

    testWidgets('golden: DatePickerSelect formats + item states (app-cliente)', (tester) async {
      await pumpGolden(tester, const _DatePickerSelectMatrix(), height: 420);
      await expectLater(
        find.byType(_DatePickerSelectMatrix),
        matchesGoldenFile('../goldens/date_picker_select_matrix.png'),
      );
    });
  });
}

class _DatePickerSelectMatrix extends StatelessWidget {
  const _DatePickerSelectMatrix();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget gap() => SizedBox(height: t.spacing.s200);
    void noop(LooviDatePickerSelectItemUnit _) {}
    return Padding(
      padding: EdgeInsets.all(t.spacing.s200),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LooviDatePickerSelectItem(onTap: () {}),
              SizedBox(width: t.spacing.s100),
              LooviDatePickerSelectItem(expanded: true, onTap: () {}),
              SizedBox(width: t.spacing.s100),
              const LooviDatePickerSelectItem(enabled: false),
            ],
          ),
          gap(),
          LooviDatePickerSelect(onUnitTap: noop),
          gap(),
          LooviDatePickerSelect(format: LooviDatePickerSelectFormat.dayMonth, onUnitTap: noop),
          gap(),
          LooviDatePickerSelect(
            format: LooviDatePickerSelectFormat.monthYear,
            expandedUnit: LooviDatePickerSelectItemUnit.month,
            onUnitTap: noop,
          ),
          gap(),
          LooviDatePickerSelect(format: LooviDatePickerSelectFormat.year, onUnitTap: noop),
          gap(),
          const LooviDatePickerSelect(enabled: false),
        ],
      ),
    );
  }
}
