// Direct src imports until the wave export lands in lib/loovi_ds.dart.

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// PhotoTextItem (seed node 4149:479) — internal overlay of ImageItem, shown
/// here over the `background-surface/1` placeholder.
WidgetbookComponent looviPhotoTextItemComponent() => WidgetbookComponent(
  name: 'PhotoTextItem',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        final t = LooviTokens.of(context);
        final showSupporting = k.boolean(label: 'showSupportingText', initialValue: true);
        return SeedStory(
          component: 'PhotoTextItem',
          child: SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(t.radius.s200),
              child: ColoredBox(
                color: t.color.backgroundSurface1,
                child: LooviPhotoTextItem(
                  label: k.string(label: 'label', initialValue: 'Label'),
                  supportingText: showSupporting ? k.string(label: 'supportingText', initialValue: 'Supporting text') : null,
                ),
              ),
            ),
          ),
        );
      },
    ),
  ],
);
