import 'package:loovi_ds/loovi_ds.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// SliderRail (seed node 4073:2228) — composed track of Slider; shown for
/// reference.
WidgetbookComponent looviSliderRailComponent() => WidgetbookComponent(
  name: 'SliderRail (internal)',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        return SeedStory(
          component: 'SliderRail',
          child: LooviSliderRail(
            active: k.boolean(label: 'leftRail.active', initialValue: false),
            fraction: k.double.slider(label: 'fill (0–1)', initialValue: 0.5, min: 0, max: 1),
          ),
        );
      },
    ),
  ],
);
