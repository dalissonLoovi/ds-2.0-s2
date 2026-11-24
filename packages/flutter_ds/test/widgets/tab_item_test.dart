import 'package:loovi_ds/loovi_ds.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/src/foundation/loovi_blend.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

const _tab = LooviTab(label: 'Label', showIcon: true);
const _disabledTab = LooviTab(label: 'Label', showIcon: true, disabled: true);

Color? _fill(WidgetTester tester) {
  final boxes = tester
      .widgetList<DecoratedBox>(find.descendant(of: find.byType(LooviTabItem), matching: find.byType(DecoratedBox)))
      .map((b) => b.decoration)
      .whereType<BoxDecoration>()
      .where((d) => d.border == null && d.borderRadius != null);
  return boxes.isEmpty ? null : boxes.first.color;
}

Color _label(WidgetTester tester) => tester.widget<Text>(find.text('Label')).style!.color!;

Color _icon(WidgetTester tester) => tester
    .widgetList<LooviIcon>(find.byType(LooviIcon))
    .firstWhere((i) => i.name == LooviIcons.userOutline)
    .color!;

Future<void> _pumpItem(WidgetTester tester, LooviTabItem item) =>
    pumpLoovi(tester, Align(alignment: Alignment.topLeft, child: item));

/// Story "Matrix" (mobile): variant × state (+ inverse for primary).
class TabItemMatrix extends StatelessWidget {
  const TabItemMatrix({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget row(LooviTabItemVariant v, {LooviTabItemAppearance a = LooviTabItemAppearance.standard}) => Padding(
          padding: EdgeInsets.all(t.spacing.s100),
          child: Row(
            children: [
              LooviTabItem(tab: _tab, variant: v, appearance: a, onTap: () {}),
              SizedBox(width: t.spacing.s100),
              LooviTabItem(tab: _tab, variant: v, appearance: a, selected: true, onTap: () {}),
              SizedBox(width: t.spacing.s100),
              LooviTabItem(tab: _disabledTab, variant: v, appearance: a, onTap: () {}),
            ],
          ),
        );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        row(LooviTabItemVariant.primary),
        ColoredBox(
          color: t.color.backgroundSurfaceInverse2,
          child: row(LooviTabItemVariant.primary, a: LooviTabItemAppearance.inverse),
        ),
        row(LooviTabItemVariant.secondary),
        row(LooviTabItemVariant.segmented),
        Padding(
          padding: EdgeInsets.all(t.spacing.s100),
          child: Row(
            children: [
              LooviTabItem(
                tab: const LooviTab(label: 'Pix', showAttention: true),
                selected: true,
                onTap: () {},
              ),
              SizedBox(width: t.spacing.s100),
              LooviTabItem(tab: const LooviTab(label: 'Foco'), showFocusRing: true, onTap: () {}),
              SizedBox(width: t.spacing.s100),
              LooviTabItem(
                tab: const LooviTab(label: 'Foco'),
                variant: LooviTabItemVariant.segmented,
                showFocusRing: true,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void main() {
  setUpAll(loadGoldenFonts);

  group('primary paint (mobile)', () {
    testWidgets('default: surface/0, label text/secondary, icon text/placeholder', (tester) async {
      await _pumpItem(tester, LooviTabItem(tab: _tab, onTap: () {}));
      expect(_fill(tester), _t.color.backgroundSurface0);
      expect(_label(tester), _t.text.secondary);
      expect(_icon(tester), _t.text.placeholder);
      // padding spacing/150 + 20 line = 44; radius border/radius/200.
      expect(tester.getSize(find.byType(LooviTabItem)).height, 2 * _t.spacing.s150 + 20);
    });

    testWidgets('selected: surface/2, label text/primary (AA), icon text/brand', (tester) async {
      await _pumpItem(tester, LooviTabItem(tab: _tab, selected: true, onTap: () {}));
      expect(_fill(tester), _t.color.backgroundSurface2);
      expect(_label(tester), _t.text.primary);
      expect(_icon(tester), _t.text.brand);
    });

    testWidgets('disabled: disabled-surface + text/placeholder', (tester) async {
      await _pumpItem(tester, LooviTabItem(tab: _disabledTab, onTap: () {}));
      expect(_fill(tester), _t.interactive.disabledSurface);
      expect(_label(tester), _t.text.placeholder);
      expect(_icon(tester), _t.text.placeholder);
    });

    testWidgets('inverse: default / selected (Plus Darker) / disabled', (tester) async {
      const inv = LooviTabItemAppearance.inverse;
      await _pumpItem(tester, LooviTabItem(tab: _tab, appearance: inv, onTap: () {}));
      expect(_fill(tester), _t.color.backgroundSurfaceInverse2);
      expect(_label(tester), _t.text.onColor);
      expect(_icon(tester), _t.text.onColorDisabled);

      await _pumpItem(tester, LooviTabItem(tab: _tab, appearance: inv, selected: true, onTap: () {}));
      expect(_fill(tester), looviPlusDarker(_t.color.backgroundSurfaceInverse3, _t.interactive.selected));
      expect(_label(tester), _t.color.actionsTertiary);
      expect(_icon(tester), _t.color.actionsTertiary);

      await _pumpItem(tester, LooviTabItem(tab: _disabledTab, appearance: inv, onTap: () {}));
      expect(_fill(tester), _t.color.backgroundSurfaceInverse2);
      expect(_label(tester), _t.text.placeholderInverse);
    });
  });

  testWidgets('secondary: indicator only when selected, height constant', (tester) async {
    await pumpLoovi(
      tester,
      Row(children: [
        LooviTabItem(key: const Key('a'), tab: _tab, variant: LooviTabItemVariant.secondary, onTap: () {}),
        LooviTabItem(
            key: const Key('b'), tab: _tab, variant: LooviTabItemVariant.secondary, selected: true, onTap: () {}),
      ]),
    );
    BoxDecoration ind(String k) => tester
        .widget<DecoratedBox>(find.descendant(of: find.byKey(Key(k)), matching: find.byKey(const Key('loovi-tab-item-indicator'))))
        .decoration as BoxDecoration;
    expect(ind('a').color, isNull);
    expect(ind('b').color, _t.color.actionsPrimary);
    expect(tester.getSize(find.byKey(const Key('a'))).height, tester.getSize(find.byKey(const Key('b'))).height);
    // 12 + 20 + 4 + 2 = 38 (Figma selected frame).
    expect(tester.getSize(find.byKey(const Key('b'))).height, _t.spacing.s150 + 20 + _t.spacing.s050 + _t.spacing.s025);
    final labels = tester.widgetList<Text>(find.text('Label')).toList();
    expect(labels[0].style!.color, _t.text.secondary);
    expect(labels[1].style!.color, _t.text.primary);
  });

  testWidgets('segmented: selected actions/primary + on-color; default transparent', (tester) async {
    await _pumpItem(
        tester, LooviTabItem(tab: _tab, variant: LooviTabItemVariant.segmented, selected: true, onTap: () {}));
    expect(_fill(tester), _t.color.actionsPrimary);
    expect(_label(tester), _t.text.onColor);
    expect(_icon(tester), _t.text.onColor);
    expect(tester.getSize(find.byType(LooviTabItem)).height, 2 * _t.spacing.s050 + 20);
    await _pumpItem(tester, LooviTabItem(tab: _tab, variant: LooviTabItemVariant.segmented, onTap: () {}));
    expect(_fill(tester), isNull);
    expect(_label(tester), _t.text.secondary);
  });

  testWidgets('attention icon: feedback/danger, in the accessible name', (tester) async {
    final handle = tester.ensureSemantics();
    await _pumpItem(tester, LooviTabItem(tab: const LooviTab(label: 'Pix', showAttention: true), onTap: () {}));
    final icon = tester.widget<LooviIcon>(find.byType(LooviIcon));
    expect(icon.name, LooviIcons.alertCircleFilled);
    expect(icon.color, _t.feedback.danger);
    expect(icon.size, _t.spacing.s200);
    expect(find.bySemanticsLabel('Pix, requer atenção'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('tap fires onTap; disabled does not', (tester) async {
    var taps = 0;
    await pumpLoovi(
      tester,
      Row(children: [
        LooviTabItem(tab: const LooviTab(label: 'On'), onTap: () => taps++),
        LooviTabItem(tab: const LooviTab(label: 'Off', disabled: true), onTap: () => taps++),
      ]),
    );
    await tester.tap(find.text('On'));
    await tester.tap(find.text('Off'), warnIfMissed: false);
    expect(taps, 1);
  });

  testWidgets('golden: matrix', (tester) async {
    await pumpGolden(tester, const TabItemMatrix(), height: 360);
    await expectLater(find.byType(TabItemMatrix), matchesGoldenFile('../goldens/tab_item_matrix.png'));
  });
}
