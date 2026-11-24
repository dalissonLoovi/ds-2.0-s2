import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// ListItemLeadingMonogram (seed node 3694:16194) — standalone + in a row.
WidgetbookComponent looviListItemLeadingMonogramComponent() => WidgetbookComponent(
      name: 'ListItemLeadingMonogram',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final initial = context.knobs.string(label: 'initial', initialValue: 'A');
            return SeedStory(
              component: 'ListItemLeadingMonogram',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(alignment: Alignment.centerLeft, child: LooviListItemLeadingMonogram(initial)),
                  LooviListItem(
                    condition: LooviListItemCondition.twoLine,
                    headline: 'Ana Souza',
                    supportingText: 'Titular',
                    leading: LooviListItemLeadingMonogram(initial),
                    trailingIcon: LooviIcons.chevronRightOutline,
                    onTap: () {},
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
