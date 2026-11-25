import 'package:loovi_ds/loovi_ds.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// SliderRightRail (seed node 4073:2224) — residual segment of the Slider
/// track; shown for reference.
WidgetbookComponent looviSliderRightRailComponent() => WidgetbookComponent(
  name: 'SliderRightRail (internal)',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const SeedStory(component: 'SliderRightRail', child: LooviSliderRightRail()),
    ),
  ],
);
