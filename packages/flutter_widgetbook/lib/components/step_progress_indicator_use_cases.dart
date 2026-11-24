import 'dart:math' as math;

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// StepProgressIndicator (seed node 3809:765): Playground + Variants.
WidgetbookComponent looviStepProgressIndicatorComponent() => WidgetbookComponent(
  name: 'StepProgressIndicator',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        final total = k.int.slider(label: 'stepCount', initialValue: 5, min: 3, max: 8);
        // Sparse matrix: currentStep never exceeds stepCount.
        final current = math.min(k.int.slider(label: 'currentStep', initialValue: 2, min: 1, max: 8), total);
        return SeedStory(
          component: 'StepProgressIndicator',
          child: LooviStepProgressIndicator(
            stepCount: total,
            currentStep: current,
            showCounter: k.boolean(label: 'showCounter', initialValue: true),
            hasError: k.boolean(label: 'hasError'),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Variants',
      builder: (context) =>
          const SeedStory(component: 'StepProgressIndicator', showDescription: false, child: _Variants()),
    ),
  ],
);

/// 3 / 5 steps, 8 with counter, error. Same as the golden
/// `step_progress_indicator_variants.png`.
class _Variants extends StatelessWidget {
  const _Variants();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const LooviStepProgressIndicator(stepCount: 3, currentStep: 1),
        SizedBox(height: t.spacing.s300),
        const LooviStepProgressIndicator(stepCount: 5, currentStep: 3),
        SizedBox(height: t.spacing.s300),
        const LooviStepProgressIndicator(stepCount: 8, currentStep: 6, showCounter: true),
        SizedBox(height: t.spacing.s300),
        const LooviStepProgressIndicator(stepCount: 4, currentStep: 2, showCounter: true, hasError: true),
      ],
    );
  }
}
