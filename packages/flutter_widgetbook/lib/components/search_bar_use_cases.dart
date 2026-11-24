// Direct src import until lib/loovi_ds.dart exports wave 3 (integration).

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// Seed `SearchBar` (3881:6002) — Playground (knobs) + Variants.
WidgetbookComponent looviSearchBarComponent() => WidgetbookComponent(
      name: 'SearchBar',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            final t = LooviTokens.of(context);
            final hasQuery = k.boolean(label: 'content=value');
            return SeedStory(
              component: 'SearchBar',
              child: ColoredBox(
                color: t.color.backgroundSurface2,
                child: Padding(
                  padding: EdgeInsets.all(t.spacing.s200),
                  child: LooviSearchBar(
                    placeholder: k.string(label: 'placeholder', initialValue: 'Pesquisar'),
                    query: hasQuery ? k.string(label: 'query', initialValue: 'Seguro auto') : null,
                    disabled: k.boolean(label: 'state=disabled'),
                    showLeadingAction: k.boolean(label: 'showLeadingAction', initialValue: true),
                    showFirstTrailingAction: k.boolean(label: 'showFirstTrailingAction', initialValue: true),
                    showSecondTrailingAction: k.boolean(label: 'showSecondTrailingAction'),
                    showProfileAction: k.boolean(label: 'showProfileAction'),
                    profileInitials: 'RS',
                    onPressed: () {},
                    onLeadingAction: () {},
                    onSecondTrailingAction: () {},
                    onProfileAction: () {},
                  ),
                ),
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Variants',
          builder: (context) {
            final t = LooviTokens.of(context);
            final gap = SizedBox(height: t.spacing.s200);
            void noop() {}
            return SeedStory(
              component: 'SearchBar',
              showDescription: false,
              child: ColoredBox(
                color: t.color.backgroundSurface2,
                child: Padding(
                  padding: EdgeInsets.all(t.spacing.s200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LooviSearchBar(onPressed: noop),
                      gap,
                      LooviSearchBar(query: 'Seguro auto', showSecondTrailingAction: true, onPressed: noop),
                      gap,
                      LooviSearchBar(showProfileAction: true, profileInitials: 'RS', onPressed: noop),
                      gap,
                      LooviSearchBar(disabled: true, query: 'Seguro auto', onPressed: noop),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
