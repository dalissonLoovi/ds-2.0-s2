// Direct src import until the wave export lands in lib/loovi_ds.dart.

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

Widget _slot(BuildContext context) {
  final t = LooviTokens.of(context);
  return Container(
    height: t.spacing.s800,
    decoration: BoxDecoration(color: t.color.backgroundSurface2, borderRadius: BorderRadius.circular(t.radius.s300)),
  );
}

/// CardHorizontal (seed node 4170:4506) — Playground + style × layout.
WidgetbookComponent looviCardHorizontalComponent() => WidgetbookComponent(
      name: 'CardHorizontal',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            return SeedStory(
              component: 'CardHorizontal',
              child: LooviCardHorizontal(
                style: k.object.dropdown<LooviCardHorizontalStyle>(
                  label: 'style',
                  options: LooviCardHorizontalStyle.values,
                  labelBuilder: (v) => v.name,
                ),
                layout: k.object.dropdown<LooviCardHorizontalLayout>(
                  label: 'layout',
                  options: LooviCardHorizontalLayout.values,
                  labelBuilder: (v) => v == LooviCardHorizontalLayout.mediaAndText ? 'media-and-text' : v.name,
                ),
                headerText: k.string(label: 'headerText', initialValue: 'Header'),
                subheadText: k.string(label: 'subheadText', initialValue: 'Subhead'),
                avatarInitials: k.string(label: 'avatar initials', initialValue: 'AB'),
                slot: _slot(context),
                dragged: k.boolean(label: 'background dragged'),
                onPressed: k.boolean(label: 'onPressed') ? () {} : null,
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Variants',
          builder: (context) => SeedStory(
            component: 'CardHorizontal',
            showDescription: false,
            child: Builder(builder: (context) {
              final t = LooviTokens.of(context);
              final gap = SizedBox(height: t.spacing.s200);
              return Column(
                children: [
                  for (final s in LooviCardHorizontalStyle.values) ...[
                    LooviCardHorizontal(style: s, avatarInitials: 'AB'),
                    gap,
                    LooviCardHorizontal(style: s, layout: LooviCardHorizontalLayout.slot, slot: _slot(context)),
                    gap,
                  ],
                ],
              );
            }),
          ),
        ),
      ],
    );
