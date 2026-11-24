import 'package:flutter_test/flutter_test.dart';
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump.dart';

const _t = LooviTokens.appCliente;

/// Every status, 4 dp tall. Same as the Widgetbook story.
class StepProgressSegmentStatuses extends StatelessWidget {
  const StepProgressSegmentStatuses({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ColoredBox(
      color: t.color.backgroundSurface0,
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s200),
        child: Row(
          children: [
            for (final s in LooviStepProgressSegmentStatus.values) ...[
              if (s.index > 0) SizedBox(width: t.spacing.s100),
              Expanded(child: LooviStepProgressSegment(status: s)),
            ],
          ],
        ),
      ),
    );
  }
}

void main() {
  setUpAll(loadGoldenFonts);

  for (final s in LooviStepProgressSegmentStatus.values) {
    testWidgets('status=${s.name}: color, radius full, height spacing/050', (tester) async {
      await pumpLoovi(tester, LooviStepProgressSegment(status: s));
      final d = tester
          .widget<DecoratedBox>(find.descendant(of: find.byType(LooviStepProgressSegment), matching: find.byType(DecoratedBox)))
          .decoration as BoxDecoration;
      expect(d.color, switch (s) {
        LooviStepProgressSegmentStatus.completed => LooviStepProgressSegment.colorFor(_t, LooviStepProgressSegmentStatus.completed),
        LooviStepProgressSegmentStatus.current => _t.color.actionsPrimary,
        LooviStepProgressSegmentStatus.pending => _t.color.backgroundSurface2,
        LooviStepProgressSegmentStatus.error => _t.feedback.danger,
      });
      expect(d.borderRadius, BorderRadius.circular(_t.radius.full));
      expect(tester.getSize(find.byType(LooviStepProgressSegment)).height, _t.spacing.s050);
    });
  }

  testWidgets('default status is completed (Figma default)', (tester) async {
    expect(const LooviStepProgressSegment().status, LooviStepProgressSegmentStatus.completed);
  });

  testWidgets('decorative: no semantics', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoovi(tester, const LooviStepProgressSegment());
    expect(find.descendant(of: find.byType(LooviStepProgressSegment), matching: find.byType(ExcludeSemantics)), findsWidgets);
    handle.dispose();
  });

  testWidgets('golden: statuses', (tester) async {
    await pumpGolden(tester, const StepProgressSegmentStatuses(), height: 40);
    await expectLater(
      find.byType(StepProgressSegmentStatuses),
      matchesGoldenFile('../goldens/step_progress_segment_status.png'),
    );
  });
}
