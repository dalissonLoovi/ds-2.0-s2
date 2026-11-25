import 'package:loovi_ds/loovi_ds.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// SliderSkeletonItem (seed node 4092:4005) — loading placeholder of Slider
/// (status=skeleton); shown for reference.
WidgetbookComponent looviSliderSkeletonItemComponent() => WidgetbookComponent(
  name: 'SliderSkeletonItem (internal)',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const SeedStory(component: 'SliderSkeletonItem', child: LooviSliderSkeletonItem()),
    ),
  ],
);
