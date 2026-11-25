import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// SliderLeftRail (seed node 4073:2214) — filled segment of the Slider track;
/// shown for reference: Active (false | true). The parent sets its width
/// (half of the story here).
WidgetbookComponent looviSliderLeftRailComponent() => WidgetbookComponent(
  name: 'SliderLeftRail (internal)',
  useCases: [
    WidgetbookUseCase(
      name: 'Active',
      builder: (context) {
        final t = LooviTokens.of(context);
        Widget half(Widget child) => FractionallySizedBox(
              alignment: AlignmentDirectional.centerStart,
              widthFactor: 0.5,
              child: child,
            );
        return SeedStory(
          component: 'SliderLeftRail',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              half(const LooviSliderLeftRail()),
              SizedBox(height: t.spacing.s300),
              half(const LooviSliderLeftRail(active: true)),
            ],
          ),
        );
      },
    ),
  ],
);
