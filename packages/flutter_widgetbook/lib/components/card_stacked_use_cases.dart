// Direct src import until the wave export lands in lib/loovi_ds.dart.

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

Widget _slot(BuildContext context) {
  final t = LooviTokens.of(context);
  return Container(
    height: t.spacing.s1200,
    padding: EdgeInsets.all(t.spacing.s100),
    decoration: BoxDecoration(color: t.color.backgroundSurface2, borderRadius: BorderRadius.circular(t.radius.s200)),
    child: Text('Slot content', style: t.typography.bodyMediumRegular.copyWith(color: t.text.secondary)),
  );
}

/// CardStacked (seed node 4170:4433) — Playground + style × layout.
WidgetbookComponent looviCardStackedComponent() => WidgetbookComponent(
      name: 'CardStacked',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            return SeedStory(
              component: 'CardStacked',
              child: LooviCardStacked(
                style: k.object.dropdown<LooviCardStackedStyle>(
                  label: 'style',
                  options: LooviCardStackedStyle.values,
                  labelBuilder: (v) => v.name,
                ),
                layout: k.object.dropdown<LooviCardStackedLayout>(
                  label: 'layout',
                  options: LooviCardStackedLayout.values,
                  labelBuilder: (v) => v == LooviCardStackedLayout.mediaAndText ? 'media-and-text' : v.name,
                ),
                headerText: k.string(label: 'headerText', initialValue: 'Header'),
                subheadText: k.string(label: 'subheadText', initialValue: 'Subhead'),
                titleText: k.string(label: 'titleText', initialValue: 'Title'),
                subtitleText: k.string(label: 'subtitleText', initialValue: 'Subtitle'),
                supportingText: k.string(
                  label: 'supportingText',
                  initialValue: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
                ),
                avatarInitials: k.string(label: 'avatar initials', initialValue: 'AB'),
                showSecondaryAction: k.boolean(label: 'showSecondaryAction', initialValue: true),
                showMenuAction: k.boolean(label: 'menuAction', initialValue: true),
                primaryActionLabel: k.string(label: 'primaryAction label', initialValue: 'Primary'),
                secondaryActionLabel: k.string(label: 'secondaryAction label', initialValue: 'Secondary'),
                onMenuPressed: () {},
                onPrimaryPressed: () {},
                onSecondaryPressed: () {},
                slot: _slot(context),
                dragged: k.boolean(label: 'background dragged'),
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Variants',
          builder: (context) => SeedStory(
            component: 'CardStacked',
            showDescription: false,
            child: Builder(builder: (context) {
              final t = LooviTokens.of(context);
              final gap = SizedBox(height: t.spacing.s200);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final s in LooviCardStackedStyle.values) ...[
                    LooviCardStacked(
                      style: s,
                      avatarInitials: 'AB',
                      onMenuPressed: () {},
                      onPrimaryPressed: () {},
                      onSecondaryPressed: () {},
                    ),
                    gap,
                    LooviCardStacked(style: s, layout: LooviCardStackedLayout.slot, slot: _slot(context)),
                    gap,
                  ],
                ],
              );
            }),
          ),
        ),
      ],
    );
