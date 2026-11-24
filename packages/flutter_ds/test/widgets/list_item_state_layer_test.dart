import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

void main() {
  setUpAll(loadGoldenFonts);

  final t = LooviTokens.appCliente;

  BoxDecoration outer(WidgetTester tester) => tester
      .widget<DecoratedBox>(find.descendant(of: find.byType(LooviListItemStateLayer), matching: find.byType(DecoratedBox)).first)
      .decoration as BoxDecoration;

  Widget layer(LooviListItemStateLayerState s) =>
      SizedBox(height: 56, child: LooviListItemStateLayer(state: s));

  testWidgets('standard: no fill, no ring', (tester) async {
    await pumpLoovi(tester, layer(LooviListItemStateLayerState.standard));
    expect(outer(tester).color, isNull);
    expect(outer(tester).boxShadow, isNull);
    expect(find.descendant(of: find.byType(LooviListItemStateLayer), matching: find.byType(DecoratedBox)), findsOneWidget);
  });

  testWidgets('pressed: interactive/pressed wash', (tester) async {
    await pumpLoovi(tester, layer(LooviListItemStateLayerState.pressed));
    expect(outer(tester).color, t.interactive.pressed);
  });

  testWidgets('dragged: interactive/selected + elevation/1', (tester) async {
    await pumpLoovi(tester, layer(LooviListItemStateLayerState.dragged));
    expect(outer(tester).color, t.interactive.selected);
    expect(outer(tester).boxShadow, LooviEffects.box(t.effects.elevation1));
  });

  testWidgets('focus: ring only (interactive/focus, border/width/025, radius/200)', (tester) async {
    await pumpLoovi(tester, layer(LooviListItemStateLayerState.focus));
    expect(outer(tester).color, isNull);
    final ring = tester
        .widgetList<DecoratedBox>(find.descendant(of: find.byType(LooviListItemStateLayer), matching: find.byType(DecoratedBox)))
        .last
        .decoration as BoxDecoration;
    final border = ring.border! as Border;
    expect(border.top.color, t.interactive.focus);
    expect(border.top.width, t.borderWidth.s025);
    expect(ring.borderRadius, BorderRadius.circular(t.radius.s200));
  });

  testWidgets('no semantics and no hit testing', (tester) async {
    final handle = tester.ensureSemantics();
    var taps = 0;
    await pumpLoovi(
      tester,
      GestureDetector(onTap: () => taps++, child: layer(LooviListItemStateLayerState.pressed)),
    );
    expect(find.descendant(of: find.byType(LooviListItemStateLayer), matching: find.byType(IgnorePointer)), findsWidgets);
    expect(tester.getSemantics(find.byType(LooviListItemStateLayer)).label, isEmpty);
    handle.dispose();
    expect(taps, 0);
  });

  testWidgets('golden: states', (tester) async {
    await pumpGolden(
      tester,
      Padding(
        key: const Key('golden'),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (final s in LooviListItemStateLayerState.values) ...[
              SizedBox(
                height: 56,
                child: Stack(
                  children: [
                    Positioned.fill(child: LooviListItemStateLayer(state: s)),
                    Center(child: Text(s.name)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
      height: 340,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/list_item_state_layer_states.png'));
  });
}
