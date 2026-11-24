import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// ProgressBar (seed node 3653:5393): Playground + Variants.
WidgetbookComponent looviProgressBarComponent() => WidgetbookComponent(
  name: 'ProgressBar',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        final value = k.string(label: 'value (empty = progress %)', initialValue: '');
        return SeedStory(
          component: 'ProgressBar',
          child: LooviProgressBar(
            progress: k.double.slider(label: 'progress (0–100)', initialValue: 40, min: 0, max: 100),
            value: value.isEmpty ? null : value,
            showValue: k.boolean(label: 'showValue', initialValue: true),
            size: k.object.dropdown<LooviProgressBarSize>(
              label: 'size',
              options: LooviProgressBarSize.values,
              initialOption: LooviProgressBarSize.md,
              labelBuilder: (v) => v.name,
            ),
            semanticLabel: k.string(label: 'semanticLabel', initialValue: 'Envio das fotos'),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Variants',
      builder: (context) => const SeedStory(component: 'ProgressBar', showDescription: false, child: _Variants()),
    ),
  ],
);

/// md | sm at 0 / 40 / 100 + showValue=false. Same as the golden
/// `progress_bar_variants.png`.
class _Variants extends StatelessWidget {
  const _Variants();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final s in LooviProgressBarSize.values)
          for (final p in const [0.0, 40.0, 100.0]) ...[
            LooviProgressBar(size: s, progress: p),
            SizedBox(height: t.spacing.s200),
          ],
        const LooviProgressBar(progress: 60, showValue: false, semanticLabel: 'Envio das fotos'),
      ],
    );
  }
}
