import 'dart:ui' show Tristate;

import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// Story "Variants": 3 / 5 steps, 8 steps with counter, error. Same as the
/// Widgetbook story.
class StepProgressIndicatorVariants extends StatelessWidget {
  const StepProgressIndicatorVariants({super.key});

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
            const LooviStepProgressIndicator(stepCount: 3, currentStep: 1, showCounter: false),
            SizedBox(height: t.spacing.s300),
            const LooviStepProgressIndicator(stepCount: 5, currentStep: 3, showCounter: false),
            SizedBox(height: t.spacing.s300),
            const LooviStepProgressIndicator(stepCount: 8, currentStep: 6, showCounter: true),
            SizedBox(height: t.spacing.s300),
            const LooviStepProgressIndicator(stepCount: 4, currentStep: 2, showCounter: true, hasError: true),
          ],
        ),
      ),
    );
  }
}

List<LooviStepProgressSegmentStatus> _statuses(WidgetTester tester) =>
    tester.widgetList<LooviStepProgressSegment>(find.byType(LooviStepProgressSegment)).map((s) => s.status).toList();

void main() {
  setUpAll(loadGoldenFonts);

  test('statusFor: completed before, current, pending after; error replaces current', () {
    expect(LooviStepProgressIndicator.statusFor(1, 2), LooviStepProgressSegmentStatus.completed);
    expect(LooviStepProgressIndicator.statusFor(2, 2), LooviStepProgressSegmentStatus.current);
    expect(LooviStepProgressIndicator.statusFor(3, 2), LooviStepProgressSegmentStatus.pending);
    expect(LooviStepProgressIndicator.statusFor(2, 2, hasError: true), LooviStepProgressSegmentStatus.error);
  });

  testWidgets('segments: equal widths, gap spacing/100, height spacing/050', (tester) async {
    await pumpLoovi(tester, const LooviStepProgressIndicator(stepCount: 4, currentStep: 3));
    expect(_statuses(tester), [
      LooviStepProgressSegmentStatus.completed,
      LooviStepProgressSegmentStatus.completed,
      LooviStepProgressSegmentStatus.current,
      LooviStepProgressSegmentStatus.pending,
    ]);
    final rects = tester.getRect(find.byType(LooviStepProgressSegment).at(0));
    final next = tester.getRect(find.byType(LooviStepProgressSegment).at(1));
    expect(rects.height, _t.spacing.s050);
    expect(next.left - rects.right, _t.spacing.s100);
    expect(next.width, closeTo(rects.width, 0.01));
  });

  testWidgets('hasError paints the current segment error', (tester) async {
    await pumpLoovi(tester, const LooviStepProgressIndicator(stepCount: 3, currentStep: 2, hasError: true));
    expect(_statuses(tester)[1], LooviStepProgressSegmentStatus.error);
  });

  testWidgets('counter: shown by default; body/small/medium text/secondary, gap spacing/100', (tester) async {
    await pumpLoovi(tester, const LooviStepProgressIndicator(stepCount: 6, currentStep: 2, showCounter: false));
    expect(find.text('Etapa 2 de 6'), findsNothing);
    await pumpLoovi(tester, const LooviStepProgressIndicator(stepCount: 6, currentStep: 2, showCounter: true));
    final txt = tester.widget<Text>(find.text('Etapa 2 de 6'));
    expect(txt.style!.color, _t.text.secondary);
    expect(txt.style!.fontSize, _t.typography.bodySmallMedium.fontSize);
    expect(
      tester.getRect(find.byType(LooviStepProgressSegment).first).top - tester.getRect(find.text('Etapa 2 de 6')).bottom,
      _t.spacing.s100,
    );
  });

  testWidgets('semantics: "Etapa X de Y" (or custom), segments hidden, no focus', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const LooviStepProgressIndicator(stepCount: 5, currentStep: 2));
    expect(tester.getSemantics(find.byType(LooviStepProgressIndicator)).label, 'Etapa 2 de 5');
    await pumpLoovi(
      tester,
      const LooviStepProgressIndicator(stepCount: 5, currentStep: 2, semanticLabel: 'Etapa 2 de 5: Dados do veículo'),
    );
    final s = tester.getSemantics(find.byType(LooviStepProgressIndicator));
    expect(s.label, 'Etapa 2 de 5: Dados do veículo');
    expect(s.flagsCollection.isFocused, Tristate.none);
    handle.dispose();
  });

  testWidgets('asserts the sparse matrix', (tester) async {
    expect(() => LooviStepProgressIndicator(stepCount: 3, currentStep: 4), throwsAssertionError);
    expect(() => LooviStepProgressIndicator(stepCount: 9, currentStep: 1), throwsAssertionError);
  });

  testWidgets('golden: variants', (tester) async {
    await pumpGolden(tester, const StepProgressIndicatorVariants(), height: 200);
    await expectLater(
      find.byType(StepProgressIndicatorVariants),
      matchesGoldenFile('../goldens/step_progress_indicator_variants.png'),
    );
  });
}
