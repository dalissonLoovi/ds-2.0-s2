import 'dart:ui' show Tristate;

import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
// Direct src import until lib/loovi_ds.dart exports wave 3 (integration).
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

LooviIcon _chevron(WidgetTester tester) => tester.widget<LooviIcon>(find.byWidgetPredicate(
    (w) => w is LooviIcon && (w.name == LooviIcons.chevronDownOutline || w.name == LooviIcons.chevronUpOutline)));

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('tap calls onPressed; chevron follows expanded', (tester) async {
    var taps = 0;
    await pumpLoovi(tester, LooviSelectCountry(onPressed: () => taps++));
    expect(_chevron(tester).name, LooviIcons.chevronDownOutline);
    expect(_chevron(tester).color, _t.text.primary);
    await tester.tap(find.byType(LooviSelectCountry));
    expect(taps, 1);

    await pumpLoovi(tester, LooviSelectCountry(expanded: true, onPressed: () {}));
    expect(_chevron(tester).name, LooviIcons.chevronUpOutline);
  });

  testWidgets('semantics: named button with expanded state', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, LooviSelectCountry(expanded: true, onPressed: () {}));
    final data = tester.getSemantics(find.bySemanticsLabel('Selecionar país, Brasil')).getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.flagsCollection.isExpanded, Tristate.isTrue);
    handle.dispose();
  });

  testWidgets('disabled: opacity 0.64, placeholder chevron, never expanded, no tap', (tester) async {
    var taps = 0;
    await pumpLoovi(tester, LooviSelectCountry(disabled: true, expanded: true, onPressed: () => taps++));
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, LooviSelectCountry.disabledOpacity);
    expect(_chevron(tester).name, LooviIcons.chevronDownOutline);
    expect(_chevron(tester).color, _t.text.placeholder);
    await tester.tap(find.byType(LooviSelectCountry), warnIfMissed: false);
    expect(taps, 0);
  });

  testWidgets('sm paints 52 x 28 inside a 48 dp target', (tester) async {
    await pumpLoovi(tester, Align(child: LooviSelectCountry(size: LooviSelectCountrySize.sm, onPressed: () {})));
    final paint = find.descendant(of: find.byType(LooviSelectCountry), matching: find.byType(DecoratedBox)).first;
    expect(tester.getSize(paint), const Size(52, 28));
    expect(tester.getSize(find.byType(LooviSelectCountry)).height, greaterThanOrEqualTo(48));
  });

  testWidgets('golden: SelectCountry sizes and states (app-cliente)', (tester) async {
    await pumpGolden(tester, const _States(), height: 120);
    await expectLater(find.byType(_States), matchesGoldenFile('../goldens/select_country_states.png'));
  });
}

class _States extends StatelessWidget {
  const _States();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Padding(
      padding: EdgeInsets.all(t.spacing.s200),
      child: Wrap(
        spacing: t.spacing.s200,
        runSpacing: t.spacing.s100,
        children: [
          const LooviSelectCountry(size: LooviSelectCountrySize.md, onPressed: noop),
          const LooviSelectCountry(size: LooviSelectCountrySize.md, expanded: true, onPressed: noop),
          const LooviSelectCountry(size: LooviSelectCountrySize.md, disabled: true, onPressed: noop),
          const LooviSelectCountry(size: LooviSelectCountrySize.sm, onPressed: noop),
          const LooviSelectCountry(size: LooviSelectCountrySize.sm, expanded: true, onPressed: noop),
          const LooviSelectCountry(size: LooviSelectCountrySize.sm, disabled: true, onPressed: noop),
        ],
      ),
    );
  }
}

void noop() {}
