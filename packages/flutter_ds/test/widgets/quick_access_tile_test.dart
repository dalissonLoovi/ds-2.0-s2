import 'package:loovi_ds/loovi_ds.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

Color? _iconColor(WidgetTester tester) => tester.widget<LooviIcon>(find.byType(LooviIcon)).color;

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('renders label + default apps-outline icon at 80 x 88 on surface/2', (tester) async {
    await pumpLoovi(tester, Align(alignment: Alignment.topLeft, child: LooviQuickAccessTile(key: const Key('tile'), label: 'Label', onPressed: () {})));
    expect(find.text('Label'), findsOneWidget);
    expect(tester.widget<LooviIcon>(find.byType(LooviIcon)).name, LooviIcons.appsOutline);
    expect(_iconColor(tester), _t.text.brand);
    expect(tester.widget<Text>(find.text('Label')).style!.color, _t.text.primary);
    final size = tester.getSize(find.byKey(const Key('tile')));
    expect(size, Size(_t.spacing.s1000, _t.spacing.s1100));
    final box = tester.widget<DecoratedBox>(find.descendant(of: find.byKey(const Key('tile')), matching: find.byType(DecoratedBox)).first);
    expect((box.decoration as BoxDecoration).color, _t.color.backgroundSurface2);
  });

  testWidgets('tap fires onPressed and pressed paints interactive/pressed', (tester) async {
    var taps = 0;
    await pumpLoovi(tester, Align(alignment: Alignment.topLeft, child: LooviQuickAccessTile(key: const Key('tile'), label: 'Assistência', onPressed: () => taps++)));
    final gesture = await tester.startGesture(tester.getCenter(find.byKey(const Key('tile'))));
    await tester.pump();
    final boxes = tester.widgetList<DecoratedBox>(find.descendant(of: find.byKey(const Key('tile')), matching: find.byType(DecoratedBox)));
    expect(boxes.any((d) => (d.decoration as BoxDecoration).color == _t.interactive.pressed), isTrue);
    await gesture.up();
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('disabled: placeholder ink, no tap, not focusable', (tester) async {
    final handle = tester.ensureSemantics();
    var taps = 0;
    await pumpLoovi(
      tester,
      Align(alignment: Alignment.topLeft, child: LooviQuickAccessTile(key: const Key('tile'), label: 'Meu plano', disabled: true, onPressed: () => taps++)),
    );
    await tester.tap(find.byKey(const Key('tile')), warnIfMissed: false);
    await tester.pump();
    expect(taps, 0);
    expect(_iconColor(tester), _t.text.placeholder);
    expect(tester.widget<Text>(find.text('Meu plano')).style!.color, _t.text.placeholder);
    expect(find.byType(FocusableActionDetector), findsNothing);
    expect(
      tester.getSemantics(find.byKey(const Key('tile'))),
      isSemantics(label: 'Meu plano', isButton: true, hasEnabledState: true, isEnabled: false, isFocusable: false),
    );
    handle.dispose();
  });

  testWidgets('semantics: button named by the label', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, Align(alignment: Alignment.topLeft, child: LooviQuickAccessTile(key: const Key('tile'), label: 'Pagar fatura', onPressed: () {})));
    final node = tester.getSemantics(find.byKey(const Key('tile')));
    expect(node.label, 'Pagar fatura');
    expect(node.getSemanticsData().flagsCollection.isButton, isTrue);
    handle.dispose();
  });

  testWidgets('larger text scale grows the tile instead of overflowing', (tester) async {
    await pumpLoovi(
      tester,
      Align(alignment: Alignment.topLeft, child: LooviQuickAccessTile(key: const Key('tile'), label: 'Assistência ao veículo', onPressed: () {})),
      textScale: 2,
    );
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byKey(const Key('tile'))).height, greaterThanOrEqualTo(_t.spacing.s1100));
  });

  testWidgets('golden: states', (tester) async {
    await pumpGolden(
      tester,
      Padding(
        key: const Key('golden'),
        padding: EdgeInsets.all(_t.spacing.s200),
        child: Row(
          children: [
            LooviQuickAccessTile(label: 'Label', onPressed: () {}),
            SizedBox(width: _t.spacing.s200),
            LooviQuickAccessTile(key: const Key('pressed'), label: 'Pagar fatura', icon: LooviIcons.walletOutline, onPressed: () {}),
            SizedBox(width: _t.spacing.s200),
            LooviQuickAccessTile(label: 'Assistência', icon: LooviIcons.headsetOutline, disabled: true, onPressed: () {}),
          ],
        ),
      ),
      height: 130,
    );
    final gesture = await tester.startGesture(tester.getCenter(find.byKey(const Key('pressed'))));
    await tester.pump();
    await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('../goldens/quick_access_tile_states.png'));
    await gesture.up();
  });
}
