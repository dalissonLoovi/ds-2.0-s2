// Direct src import until the wave export lands in lib/loovi_ds.dart.
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// BrandLogo (seed node 56:6090) — Playground + type × showTrademark.
WidgetbookComponent looviBrandLogoComponent() => WidgetbookComponent(
      name: 'BrandLogo',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            final decorative = k.boolean(label: 'decorative (semanticLabel null)');
            return SeedStory(
              component: 'BrandLogo',
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  child: LooviBrandLogo(
                    type: k.object.dropdown<LooviBrandLogoType>(
                      label: 'type',
                      options: LooviBrandLogoType.values,
                      labelBuilder: (v) => v == LooviBrandLogoType.standard ? 'default' : v.name,
                    ),
                    showTrademark: k.boolean(label: 'showTrademark (app: not published)', initialValue: true),
                    semanticLabel: decorative ? null : 'Loovi',
                  ),
                ),
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Variants',
          builder: (context) => SeedStory(
            component: 'BrandLogo',
            showDescription: false,
            child: Builder(builder: (context) {
              final t = LooviTokens.of(context);
              final gap = SizedBox(height: t.spacing.s200);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final type in LooviBrandLogoType.values)
                    for (final tm in [true, false])
                      if (LooviBrandLogo.isPublished(type, tm)) ...[
                        FittedBox(child: LooviBrandLogo(type: type, showTrademark: tm)),
                        gap,
                      ],
                ],
              );
            }),
          ),
        ),
      ],
    );
