import 'dart:ui' show SemanticsRole;

import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// Story "Variants": md | sm at several values + showValue=false. Same as the
/// Widgetbook story.
class ProgressBarVariants extends StatelessWidget {
  const ProgressBarVariants({super.key});

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
            for (final s in LooviProgressBarSize.values)
              for (final p in const [0.0, 40.0, 100.0]) ...[
                LooviProgressBar(size: s, progress: p),
                SizedBox(height: t.spacing.s200),
              ],
            const LooviProgressBar(progress: 60, showValue: false, semanticLabel: 'Envio das fotos'),
          ],
        ),
      ),
    );
  }
}

Rect _indicator(WidgetTester tester) => tester.getRect(find.byKey(const ValueKey('loovi-progress-indicator')));

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('md: track 16 surface/2 radius/150, indicator actions/primary, value body/medium/medium', (tester) async {
    await pumpLoovi(tester, const LooviProgressBar(progress: 50));
    final boxes = tester
        .widgetList<DecoratedBox>(find.descendant(of: find.byType(LooviProgressBar), matching: find.byType(DecoratedBox)))
        .map((d) => d.decoration as BoxDecoration)
        .toList();
    expect(boxes[0].color, _t.color.backgroundSurface2);
    expect(boxes[0].borderRadius, BorderRadius.circular(_t.radius.s150));
    expect(boxes[1].color, _t.color.actionsPrimary);
    expect(_indicator(tester).height, _t.spacing.s200);
    final txt = tester.widget<Text>(find.text('50%'));
    expect(txt.style!.color, _t.text.primary);
    expect(txt.style!.fontSize, _t.typography.bodyMediumMedium.fontSize);
    expect(txt.style!.fontWeight, _t.typography.bodyMediumMedium.fontWeight);
    expect(tester.getRect(find.text('50%')).left - tester.getRect(find.byType(ClipRRect)).right, _t.spacing.s100);
  });

  testWidgets('sm: track 8, value body/small/medium', (tester) async {
    await pumpLoovi(tester, const LooviProgressBar(progress: 50, size: LooviProgressBarSize.sm));
    expect(_indicator(tester).height, _t.spacing.s100);
    expect(tester.widget<Text>(find.text('50%')).style!.fontSize, _t.typography.bodySmallMedium.fontSize);
  });

  testWidgets('progress drives the fill and clamps 0..100; value overrides the label', (tester) async {
    await pumpLoovi(tester, const LooviProgressBar(progress: 25, showValue: false));
    final track = tester.getRect(find.byType(ClipRRect));
    expect(_indicator(tester).width, closeTo(track.width * 0.25, 0.01));

    await pumpLoovi(tester, const LooviProgressBar(progress: 150, value: '3 de 3'));
    expect(find.text('3 de 3'), findsOneWidget);
    final track2 = tester.getRect(find.byType(ClipRRect));
    expect(_indicator(tester).width, closeTo(track2.width, 0.01));
  });

  testWidgets('showValue=false hides the label', (tester) async {
    await pumpLoovi(tester, const LooviProgressBar(progress: 30, showValue: false));
    expect(find.byType(Text), findsNothing);
  });

  testWidgets('semantics: progressBar role, value %, min 0, max 100, label', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const LooviProgressBar(progress: 42.4, showValue: false, semanticLabel: 'Envio das fotos'));
    final s = tester.getSemantics(find.byType(LooviProgressBar));
    final data = s.getSemanticsData();
    expect(data.role, SemanticsRole.progressBar);
    expect(data.label, 'Envio das fotos');
    expect(data.value, '42%');
    expect(data.minValue, '0');
    expect(data.maxValue, '100');
    handle.dispose();
  });

  testWidgets('textScaler 2: no overflow', (tester) async {
    await pumpLoovi(tester, const LooviProgressBar(progress: 80), textScale: 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden: variants', (tester) async {
    await pumpGolden(tester, const ProgressBarVariants(), height: 320);
    await expectLater(find.byType(ProgressBarVariants), matchesGoldenFile('../goldens/progress_bar_variants.png'));
  });
}
