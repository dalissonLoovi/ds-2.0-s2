import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:loovi_ds/src/widgets/tooltip/loovi_tooltip_anchor.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

const _copy = 'A franquia é o valor que você paga em caso de sinistro.';

/// Story "Placements": the six static bubbles. Same as the Widgetbook story.
class TooltipPlacements extends StatelessWidget {
  const TooltipPlacements({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final p in LooviTooltipPlacement.values) ...[
              LooviTooltip(placement: p, description: _copy),
              SizedBox(height: t.spacing.s200),
            ],
          ],
        ),
      ),
    );
  }
}

Widget _trigger() => const SizedBox(
      key: Key('trigger'),
      width: 48,
      height: 48,
      child: ColoredBox(color: Color(0x00000000)),
    );

/// Places the tooltip host away from the screen edges.
Widget _host(Widget child, {double top = 120}) =>
    Padding(padding: EdgeInsets.only(top: top), child: Align(alignment: Alignment.topCenter, child: child));

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('surface: inverse-3, radius/300 shape, elevation/6 shadow, padding spacing/200 + arrow area', (tester) async {
    await pumpLoovi(tester, const LooviTooltip(description: 'Texto'));
    final d = tester
        .widget<DecoratedBox>(find.descendant(of: find.byType(LooviTooltip), matching: find.byType(DecoratedBox)))
        .decoration as ShapeDecoration;
    expect(d.color, _t.color.backgroundSurfaceInverse3);
    final shape = d.shape as LooviTooltipShape;
    expect(shape.radius, _t.radius.s300);
    expect(shape.arrowWidth, _t.spacing.s200);
    expect(shape.arrowHeight, _t.spacing.s150);
    expect(shape.protrusion, _t.spacing.s100);
    expect(d.shadows!.single.color, _t.color.elevation6);
    expect(d.shadows!.single.blurRadius, _t.spacing.s100);
    expect(d.shadows!.single.offset, Offset(0, _t.spacing.s100));
    final root = tester.getRect(find.byType(LooviTooltip));
    final text = tester.getRect(find.text('Texto'));
    // top placement: arrow area on top.
    expect(text.top - root.top, _t.spacing.s100 + _t.spacing.s200);
    expect(text.left - root.left, _t.spacing.s200);
    expect(root.bottom - text.bottom, _t.spacing.s200);
    final txt = tester.widget<Text>(find.text('Texto'));
    expect(txt.style!.color, _t.text.onColor);
    expect(txt.style!.fontSize, _t.typography.bodySmallRegular.fontSize);
  });

  test('placement geometry: arrow edge and alignment', () {
    expect(LooviTooltipPlacement.topLeft.arrowOnTop, isTrue);
    expect(LooviTooltipPlacement.bottomRight.arrowOnTop, isFalse);
    expect(LooviTooltipPlacement.bottomLeft.arrowAlign, -1);
    expect(LooviTooltipPlacement.topCenter.arrowAlign, 0);
    const shape = LooviTooltipShape(
      placement: LooviTooltipPlacement.bottomRight,
      radius: 12,
      arrowWidth: 16,
      arrowHeight: 12,
      protrusion: 8,
      inset: 16,
    );
    const rect = Rect.fromLTWH(0, 0, 168, 142);
    expect(shape.arrowTipX(rect), 168 - 24);
    expect(shape.bodyRect(rect).bottom, 134);
  });

  testWidgets('initiallyOpen shows the bubble after the first frame; tap on the trigger closes it', (tester) async {
    await pumpLoovi(tester, _host(LooviTooltip(description: _copy, initiallyOpen: true, child: _trigger())));
    await tester.pump();
    expect(find.text(_copy), findsOneWidget);
    await tester.tap(find.byKey(const Key('trigger')));
    await tester.pumpAndSettle();
    expect(find.text(_copy), findsNothing);
  });

  testWidgets('trigger: tap opens below the trigger (top placement), tap outside closes', (tester) async {
    await pumpLoovi(tester, _host(LooviTooltip(description: _copy, child: _trigger())));
    expect(find.text(_copy), findsNothing);
    await tester.tap(find.byKey(const Key('trigger')));
    await tester.pumpAndSettle();
    expect(find.text(_copy), findsOneWidget);
    final trigger = tester.getRect(find.byKey(const Key('trigger')));
    final bubble = tester.getRect(find.ancestor(of: find.text(_copy), matching: find.byType(DecoratedBox)).first);
    expect(bubble.top, closeTo(trigger.bottom + _t.spacing.s050, 0.01));
    expect(bubble.center.dx, closeTo(trigger.center.dx, 0.01));
    await tester.tapAt(const Offset(380, 590));
    await tester.pumpAndSettle();
    expect(find.text(_copy), findsNothing);
  });

  testWidgets('bottom-left: bubble above, arrow tip over the trigger center', (tester) async {
    await pumpLoovi(
      tester,
      _host(LooviTooltip(description: 'Oi', placement: LooviTooltipPlacement.bottomLeft, child: _trigger()), top: 300),
    );
    await tester.longPress(find.byKey(const Key('trigger')));
    await tester.pumpAndSettle();
    final trigger = tester.getRect(find.byKey(const Key('trigger')));
    final bubble = tester.getRect(find.ancestor(of: find.text('Oi'), matching: find.byType(DecoratedBox)).first);
    expect(bubble.bottom, closeTo(trigger.top - _t.spacing.s050, 0.01));
    expect(bubble.left + LooviTooltipSurface.arrowTipInset(_t), closeTo(trigger.center.dx, 0.01));
  });

  testWidgets('Escape closes; second tap toggles closed', (tester) async {
    final changes = <bool>[];
    await pumpLoovi(tester, _host(LooviTooltip(description: _copy, onOpenChange: changes.add, child: _trigger())));
    await tester.tap(find.byKey(const Key('trigger')));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text(_copy), findsNothing);
    await tester.tap(find.byKey(const Key('trigger')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('trigger')));
    await tester.pumpAndSettle();
    expect(find.text(_copy), findsNothing);
    expect(changes, [true, false, true, false]);
  });

  testWidgets('semantics: trigger carries the tooltip text; bubble excluded; focus not moved', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, _host(LooviTooltip(description: _copy, child: _trigger())));
    expect(find.bySemanticsLabel(_copy), findsNothing);
    final node = tester.getSemantics(find.byKey(const Key('trigger')));
    expect(node.tooltip, _copy);
    await tester.tap(find.byKey(const Key('trigger')));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel(_copy), findsNothing);
    expect(FocusManager.instance.primaryFocus?.context?.widget, isNot(isA<LooviTooltip>()));
    handle.dispose();
  });

  testWidgets('textScaler 2: no overflow', (tester) async {
    await pumpLoovi(tester, const LooviTooltip(description: _copy), textScale: 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: placements', (tester) async {
    await pumpGolden(tester, const TooltipPlacements(), height: 760);
    await expectLater(find.byType(TooltipPlacements), matchesGoldenFile('../goldens/tooltip_placements.png'));
  });
}
