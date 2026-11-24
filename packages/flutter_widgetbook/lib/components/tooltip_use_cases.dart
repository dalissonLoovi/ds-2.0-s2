import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

const _copy = 'A franquia é o valor que você paga em caso de sinistro.';

/// Tooltip (seed node 3566:10587): Interactive (tap/long-press the icon) +
/// Placements (static bubbles).
WidgetbookComponent looviTooltipComponent() => WidgetbookComponent(
  name: 'Tooltip',
  useCases: [
    WidgetbookUseCase(
      name: 'Interactive',
      builder: (context) {
        final k = context.knobs;
        final t = LooviTokens.of(context);
        final placement = k.object.dropdown<LooviTooltipPlacement>(
          label: 'placement (arrow edge)',
          options: LooviTooltipPlacement.values,
          initialOption: LooviTooltipPlacement.bottomCenter,
          labelBuilder: (v) => v.name,
        );
        return SeedStory(
          component: 'Tooltip',
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: t.spacing.s1200 * 2),
            child: Align(
              alignment: switch (placement.arrowAlign) {
                -1 => Alignment.centerLeft,
                1 => Alignment.centerRight,
                _ => Alignment.center,
              },
              child: LooviTooltip(
                description: k.string(label: 'description', initialValue: _copy),
                placement: placement,
                child: LooviTapTarget(
                  child: LooviIcon(LooviIcons.infoCircleOutline, size: t.spacing.s300, semanticLabel: 'Ajuda'),
                ),
              ),
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Placements',
      builder: (context) {
        final t = LooviTokens.of(context);
        return SeedStory(
          component: 'Tooltip',
          showDescription: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final p in LooviTooltipPlacement.values) ...[
                LooviTooltip(placement: p, description: _copy),
                SizedBox(height: t.spacing.s200),
              ],
            ],
          ),
        );
      },
    ),
  ],
);
