import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// SliderItem (seed node 4073:2232) — track cell of Slider; shown for
/// reference: Playground + Active.
WidgetbookComponent looviSliderItemComponent() => WidgetbookComponent(
  name: 'SliderItem (internal)',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        return SeedStory(
          component: 'SliderItem',
          child: LooviSliderItem(
            active: k.boolean(label: 'active', initialValue: false),
            fraction: k.double.slider(label: 'fill (0–1)', initialValue: 0.5, min: 0, max: 1),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Active',
      builder: (context) {
        final t = LooviTokens.of(context);
        return SeedStory(
          component: 'SliderItem',
          showDescription: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LooviSliderItem(fraction: 0.3),
              SizedBox(height: t.spacing.s300),
              const LooviSliderItem(active: true, fraction: 0.7),
            ],
          ),
        );
      },
    ),
  ],
);
