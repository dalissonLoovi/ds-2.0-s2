import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:loovi_ds/src/foundation/loovi_blend.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// Surface BoxDecoration (the one with a fill).
BoxDecoration _surface(WidgetTester tester, Finder of) => tester
    .widgetList<DecoratedBox>(find.descendant(of: of, matching: find.byType(DecoratedBox)))
    .map((d) => d.decoration as BoxDecoration)
    .firstWhere((d) => d.color != null);

bool _hasBorder(WidgetTester tester, Finder of, Color color) => tester
    .widgetList<DecoratedBox>(find.descendant(of: of, matching: find.byType(DecoratedBox)))
    .map((d) => d.decoration as BoxDecoration)
    .any((d) => d.border is Border && (d.border as Border).top.color == color);

Widget _box() => const SizedBox(height: 40);

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('outlined: surface/0 + border/2 outline, radius/300, no shadow', (tester) async {
    await pumpLoovi(tester, LooviCardOutlinedItem(key: const Key('c'), child: _box()));
    final d = _surface(tester, find.byKey(const Key('c')));
    expect(d.color, _t.color.backgroundSurface0);
    expect(d.borderRadius, BorderRadius.circular(_t.radius.s300));
    expect(d.boxShadow, isNull);
    expect(_hasBorder(tester, find.byKey(const Key('c')), _t.color.border2), isTrue);
  });

  testWidgets('elevated: surface/1, effects/elevation/1 shadow, no outline', (tester) async {
    await pumpLoovi(tester, LooviCardElevatedItem(key: const Key('c'), child: _box()));
    final d = _surface(tester, find.byKey(const Key('c')));
    expect(d.color, _t.color.backgroundSurface1);
    expect(d.boxShadow, LooviEffects.box(_t.effects.elevation1));
    expect(_hasBorder(tester, find.byKey(const Key('c')), _t.color.border2), isFalse);
  });

  testWidgets('filled: surface/2, no shadow; dragged: interactive/selected + elevation/2', (tester) async {
    await pumpLoovi(tester, LooviCardFilledItem(key: const Key('c'), child: _box()));
    var d = _surface(tester, find.byKey(const Key('c')));
    expect(d.color, _t.color.backgroundSurface2);
    expect(d.boxShadow, isNull);
    await pumpLoovi(tester, LooviCardFilledItem(key: const Key('c'), dragged: true, child: _box()));
    d = _surface(tester, find.byKey(const Key('c')));
    expect(d.color, _t.interactive.selected);
    expect(d.boxShadow, LooviEffects.box(_t.effects.elevation2));
  });

  testWidgets('static surface is not a button', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, LooviCardOutlinedItem(key: const Key('c'), child: _box()));
    final node = tester.getSemantics(find.byKey(const Key('c')));
    expect(node.getSemanticsData().flagsCollection.isButton, isFalse);
    handle.dispose();
  });

  testWidgets('pressable: button semantics, pressed Plus Darker wash, tap fires', (tester) async {
    final handle = tester.ensureSemantics();
    var taps = 0;
    await pumpLoovi(
      tester,
      LooviCardOutlinedItem(key: const Key('c'), semanticLabel: 'Card', onPressed: () => taps++, child: _box()),
    );
    final node = tester.getSemantics(find.byKey(const Key('c')));
    expect(node.label, 'Card');
    expect(node.getSemanticsData().flagsCollection.isButton, isTrue);
    final gesture = await tester.startGesture(tester.getCenter(find.byKey(const Key('c'))));
    await tester.pump();
    expect(_surface(tester, find.byKey(const Key('c'))).color,
        looviPlusDarker(_t.color.backgroundSurface0, _t.interactive.pressed));
    await gesture.up();
    await tester.pump();
    expect(taps, 1);
    expect(_surface(tester, find.byKey(const Key('c'))).color, _t.color.backgroundSurface0);
    expect(tester.getSize(find.byKey(const Key('c'))).height, greaterThanOrEqualTo(48));
    handle.dispose();
  });

  testWidgets('keyboard focus draws the actions/primary ring unless showFocusIndicator=false', (tester) async {
    FocusManager.instance.highlightStrategy = FocusHighlightStrategy.alwaysTraditional;
    addTearDown(() => FocusManager.instance.highlightStrategy = FocusHighlightStrategy.automatic);
    for (final show in [true, false]) {
      final node = FocusNode();
      addTearDown(node.dispose);
      await pumpLoovi(
        tester,
        LooviCardElevatedItem(key: ValueKey(show), focusNode: node, showFocusIndicator: show, onPressed: () {}, child: _box()),
      );
      node.requestFocus();
      await tester.pump();
      await tester.pump(); // focus highlight callback runs post-frame
      expect(_hasBorder(tester, find.byKey(ValueKey(show)), _t.color.actionsPrimary), show);
    }
  });

  testWidgets('golden: kind x (enabled, dragged)', (tester) async {
    Widget row(Widget Function(bool dragged) b) => Padding(
          padding: EdgeInsets.only(bottom: _t.spacing.s300),
          child: Row(children: [
            Expanded(child: b(false)),
            SizedBox(width: _t.spacing.s300),
            Expanded(child: b(true)),
          ]),
        );
    await pumpGolden(
      tester,
      Padding(
        key: const Key('golden'),
        padding: EdgeInsets.all(_t.spacing.s300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            row((d) => LooviCardOutlinedItem(dragged: d, child: _box())),
            row((d) => LooviCardElevatedItem(dragged: d, child: _box())),
            row((d) => LooviCardFilledItem(dragged: d, child: _box())),
          ],
        ),
      ),
      height: 300,
    );
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/card_items_variants.png'));
  });
}
