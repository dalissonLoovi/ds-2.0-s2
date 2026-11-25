import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// Building blocks of Slider: SliderRightRail, SliderLeftRail (active
/// false | true), SliderRail, SliderItem (active false | true),
/// SliderSkeletonItem and SliderBaseItem. Same as the Widgetbook stories.
class SliderParts extends StatelessWidget {
  const SliderParts({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final gap = SizedBox(height: t.spacing.s300);
    Widget fixed(Widget child, [double fraction = 1]) => FractionallySizedBox(
          alignment: AlignmentDirectional.centerStart,
          widthFactor: fraction,
          child: child,
        );
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s300),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LooviSliderRightRail(),
            gap,
            fixed(const LooviSliderLeftRail(), 0.5),
            gap,
            fixed(const LooviSliderLeftRail(active: true), 0.5),
            gap,
            const LooviSliderRail(),
            gap,
            const LooviSliderItem(fraction: 0.3),
            gap,
            const LooviSliderItem(active: true, fraction: 0.7),
            gap,
            const LooviSliderSkeletonItem(),
            gap,
            LooviSliderBaseItem(
              sliderItem: const SizedBox(height: 48, child: Center(child: LooviSliderItem(fraction: 0.4))),
              input: LooviInput(label: 'Label', controller: TextEditingController(text: '40'), showCursor: false),
            ),
          ],
        ),
      ),
    );
  }
}

BoxDecoration _decoration(WidgetTester tester, Key key) =>
    (tester.widget<DecoratedBox>(find.byKey(key)).decoration as BoxDecoration);

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('SliderRightRail: color/border/2, height spacing/025, radius full', (tester) async {
    await pumpLoovi(tester, const LooviSliderRightRail());
    final d = tester.widget<DecoratedBox>(find.byType(DecoratedBox)).decoration as BoxDecoration;
    expect(d.color, _t.color.border2);
    expect(d.borderRadius, BorderRadius.circular(_t.radius.full));
    expect(tester.getSize(find.byType(LooviSliderRightRail)).height, _t.spacing.s025);
  });

  for (final active in [false, true]) {
    testWidgets('SliderLeftRail active=$active: primary rail + endCap ${active ? 20 : 14}', (tester) async {
      await pumpLoovi(tester, Align(alignment: Alignment.topLeft, child: SizedBox(width: 100, child: LooviSliderLeftRail(active: active))));
      final size = active ? _t.spacing.s250 : _t.spacing.s150 + _t.spacing.s025;
      final cap = tester.getRect(find.byKey(const ValueKey('loovi-slider-end-cap')));
      final line = tester.getRect(find.byKey(const ValueKey('loovi-slider-left-rail-line')));
      expect(cap.size, Size(size, size));
      expect(cap.center.dx, closeTo(line.right, 0.01));
      expect(cap.center.dy, closeTo(line.center.dy, 0.01));
      expect(line.height, _t.spacing.s025);
      expect(_decoration(tester, const ValueKey('loovi-slider-end-cap')).color, _t.color.actionsPrimary);
    });
  }

  testWidgets('SliderLeftRail skeleton: color/border/2', (tester) async {
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: SizedBox(width: 100, child: LooviSliderLeftRail(skeleton: true))));
    expect(_decoration(tester, const ValueKey('loovi-slider-end-cap')).color, _t.color.border2);
  });

  testWidgets('SliderRail: fill = fraction (clamped), height spacing/250', (tester) async {
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: SizedBox(width: 200, child: LooviSliderRail(fraction: 0.25))));
    expect(tester.getSize(find.byType(LooviSliderRail)), const Size(200, 20));
    expect(tester.getSize(find.byKey(const ValueKey('loovi-slider-fill'))).width, 50);
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: SizedBox(width: 200, child: LooviSliderRail(fraction: 3))));
    expect(tester.getSize(find.byKey(const ValueKey('loovi-slider-fill'))).width, 200);
  });

  testWidgets('SliderItem: middle tick spacing/025 color/border/2, centered, 1 dp above the rail', (tester) async {
    await pumpLoovi(tester, const Align(alignment: Alignment.topLeft, child: SizedBox(width: 200, child: LooviSliderItem(active: true))));
    final tick = tester.getRect(find.byKey(const ValueKey('loovi-slider-middle-indicator')));
    final line = tester.getRect(find.byKey(const ValueKey('loovi-slider-left-rail-line')));
    expect(tick.size, Size(_t.spacing.s025, _t.spacing.s025));
    expect(tick.center.dx, closeTo(100, 0.01));
    expect(line.top - tick.bottom, closeTo(_t.borderWidth.s012, 0.01));
    final box = tester.widget<ColoredBox>(
      find.descendant(of: find.byKey(const ValueKey('loovi-slider-middle-indicator')), matching: find.byType(ColoredBox)),
    );
    expect(box.color, _t.color.border2);
    expect(tester.widget<LooviSliderLeftRail>(find.byType(LooviSliderLeftRail)).active, isTrue);
  });

  testWidgets('SliderSkeletonItem: bones border/2 radius/100, row padding spacing/200, no primary', (tester) async {
    await pumpLoovi(tester, const LooviSliderSkeletonItem());
    for (final k in ['label', 'min', 'max']) {
      final d = (tester.widget<SizedBox>(find.byKey(ValueKey('loovi-slider-bone-$k'))).child! as DecoratedBox).decoration
          as BoxDecoration;
      expect(d.color, _t.color.border2);
      expect(d.borderRadius, BorderRadius.circular(_t.radius.s100));
    }
    expect(tester.getSize(find.byKey(const ValueKey('loovi-slider-bone-label'))), Size(_t.spacing.s500, _t.spacing.s100));
    expect(_decoration(tester, const ValueKey('loovi-slider-end-cap')).color, _t.color.border2);
    expect(tester.widget<LooviSliderLeftRail>(find.byType(LooviSliderLeftRail)).active, isFalse);
    final label = tester.getRect(find.byKey(const ValueKey('loovi-slider-bone-label')));
    final item = tester.getRect(find.byType(LooviSliderItem));
    // label + gap spacing/100 + row padding spacing/200 → rail box top.
    expect(item.top - label.bottom, closeTo(_t.spacing.s100 + _t.spacing.s200, 0.01));
  });

  testWidgets('SliderBaseItem: label/min/max tokens, decorative texts, disabled → text/placeholder', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const LooviSliderBaseItem(label: 'Faixa', minValue: '1', maxValue: '9', sliderItem: LooviSliderItem()));
    expect(tester.widget<Text>(find.text('Faixa')).style!.color, _t.text.secondary);
    expect(tester.widget<Text>(find.text('9')).style!.color, _t.text.primary);
    expect(find.bySemanticsLabel('Faixa'), findsNothing);
    await pumpLoovi(tester, const LooviSliderBaseItem(label: 'Faixa', sliderItem: LooviSliderItem(), disabled: true));
    expect(tester.widget<Text>(find.text('Faixa')).style!.color, _t.text.placeholder);
    expect(tester.widget<Text>(find.text('100')).style!.color, _t.text.placeholder);
    handle.dispose();
  });

  testWidgets('textScaler 2: parts do not overflow', (tester) async {
    await pumpLoovi(tester, const SingleChildScrollView(child: SliderParts()), textScale: 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: parts', (tester) async {
    await pumpGolden(tester, const SliderParts(), height: 520);
    await expectLater(find.byType(SliderParts), matchesGoldenFile('../goldens/slider_parts.png'));
  });
}
