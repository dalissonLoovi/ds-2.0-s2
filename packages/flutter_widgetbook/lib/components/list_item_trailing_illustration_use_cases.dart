// Direct src import until the wave export lands in lib/loovi_ds.dart.
import 'package:loovi_ds/loovi_ds.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// ListItemTrailingIllustration (seed node 5038:79) — Playground.
WidgetbookComponent looviListItemTrailingIllustrationComponent() => WidgetbookComponent(
      name: 'ListItemTrailingIllustration',
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
              component: 'ListItemTrailingIllustration',
              child: LooviListItem(
                headline: 'Proteção ativa',
                supportingText: 'Seu veículo está coberto pelo plano.',
                trailing: LooviListItemTrailingIllustration(illustration: illustration),
                onTap: () {},
              ),
            );
          },
        ),
      ],
    );
