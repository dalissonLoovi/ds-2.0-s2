import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// StepProgressSegment (seed node 3807:31) — INTERNAL to
/// StepProgressIndicator; shown for reference only: Status.
WidgetbookComponent looviStepProgressSegmentComponent() => WidgetbookComponent(
  name: 'StepProgressSegment (internal)',
  useCases: [
    WidgetbookUseCase(
      name: 'Status',
      builder: (context) {
        final t = LooviTokens.of(context);
        return SeedStory(
          component: 'StepProgressSegment',
          child: Row(
            children: [
              for (final s in LooviStepProgressSegmentStatus.values) ...[
                if (s.index > 0) SizedBox(width: t.spacing.s100),
                Expanded(child: LooviStepProgressSegment(status: s)),
              ],
            ],
          ),
        );
      },
    ),
  ],
);
