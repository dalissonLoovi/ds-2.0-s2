import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// StepperPrimary (seed node 3653:4985): Playground + Flow.
WidgetbookComponent looviStepperPrimaryComponent() => WidgetbookComponent(
  name: 'StepperPrimary',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        final status = k.object.dropdown<LooviStepperPrimaryStatus>(
          label: 'status',
          options: LooviStepperPrimaryStatus.values,
          initialOption: LooviStepperPrimaryStatus.completed,
          labelBuilder: (v) => v.name,
        );
        final trail = k.object.dropdown<LooviStepperPrimaryTrail>(
          label: 'trail',
          options: LooviStepperPrimaryTrail.values,
          initialOption: LooviStepperPrimaryTrail.both,
          labelBuilder: (v) => v.name,
        );
        final wanted = k.object.dropdown<LooviStepperPrimaryTrailState>(
          label: 'trailState (sparse: falls back to none)',
          options: LooviStepperPrimaryTrailState.values,
          initialOption: LooviStepperPrimaryTrailState.none,
          labelBuilder: (v) => v.name,
        );
        return SeedStory(
          component: 'StepperPrimary',
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: LooviTokens.of(context).spacing.s1200 * 1.5,
              child: LooviStepperPrimary(
                label: k.string(label: 'label', initialValue: 'Vistoria'),
                status: status,
                trail: trail,
                trailState: _published(status, trail, wanted),
              ),
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Flow',
      builder: (context) => const SeedStory(component: 'StepperPrimary', showDescription: false, child: _Flow()),
    ),
  ],
);

/// Keeps the knob combination inside the seed sparse matrix.
LooviStepperPrimaryTrailState _published(
  LooviStepperPrimaryStatus status,
  LooviStepperPrimaryTrail trail,
  LooviStepperPrimaryTrailState s,
) {
  const none = LooviStepperPrimaryTrailState.none;
  if (status == LooviStepperPrimaryStatus.pending) return none;
  final subset = s == none ||
      trail == LooviStepperPrimaryTrail.both ||
      (s == LooviStepperPrimaryTrailState.left && trail == LooviStepperPrimaryTrail.left) ||
      (s == LooviStepperPrimaryTrailState.right && trail == LooviStepperPrimaryTrail.right);
  if (!subset) return none;
  if (status == LooviStepperPrimaryStatus.current &&
      trail == LooviStepperPrimaryTrail.both &&
      (s == LooviStepperPrimaryTrailState.both || s == LooviStepperPrimaryTrailState.right)) {
    return none;
  }
  return s;
}

/// 4-step flow + all-pending row. Same as the golden `stepper_primary_flow.png`.
class _Flow extends StatelessWidget {
  const _Flow();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Column(
      children: [
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LooviStepperPrimary(
                label: 'Dados',
                trail: LooviStepperPrimaryTrail.right,
                trailState: LooviStepperPrimaryTrailState.right,
              ),
            ),
            Expanded(child: LooviStepperPrimary(label: 'Veículo', trailState: LooviStepperPrimaryTrailState.both)),
            Expanded(
              child: LooviStepperPrimary(
                label: 'Vistoria',
                status: LooviStepperPrimaryStatus.current,
                trailState: LooviStepperPrimaryTrailState.left,
              ),
            ),
            Expanded(
              child: LooviStepperPrimary(
                label: 'Pagamento',
                status: LooviStepperPrimaryStatus.pending,
                trail: LooviStepperPrimaryTrail.left,
              ),
            ),
          ],
        ),
        SizedBox(height: t.spacing.s300),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LooviStepperPrimary(
                label: 'Dados',
                status: LooviStepperPrimaryStatus.current,
                trail: LooviStepperPrimaryTrail.right,
              ),
            ),
            Expanded(child: LooviStepperPrimary(label: 'Veículo', status: LooviStepperPrimaryStatus.pending)),
            Expanded(
              child: LooviStepperPrimary(
                label: 'Pagamento',
                status: LooviStepperPrimaryStatus.pending,
                trail: LooviStepperPrimaryTrail.left,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
