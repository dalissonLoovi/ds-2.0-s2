// Direct src import until the wave export lands in lib/loovi_ds.dart.
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// ListItemLeadingIllustration (seed node 5038:10) — Playground + catalog.
WidgetbookComponent looviListItemLeadingIllustrationComponent() => WidgetbookComponent(
      name: 'ListItemLeadingIllustration',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final illustration = context.knobs.object.dropdown<LooviListItemIllustration>(
              label: 'illustration',
              options: LooviListItemIllustration.values,
              labelBuilder: (v) => v.name,
            );
            return SeedStory(
              component: 'ListItemLeadingIllustration',
              child: LooviListItem(
                condition: LooviListItemCondition.oneLine,
                headline: 'Onix 2022',
                leading: LooviListItemLeadingIllustration(illustration: illustration),
                trailingIcon: LooviIcons.chevronRightOutline,
                onTap: () {},
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Catalog',
          builder: (context) => SeedStory(
            component: 'ListItemLeadingIllustration',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final i in LooviListItemIllustration.values)
                  LooviListItem(
                    condition: LooviListItemCondition.oneLine,
                    headline: i.name,
                    leading: LooviListItemLeadingIllustration(illustration: i),
                    showDivider: true,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
