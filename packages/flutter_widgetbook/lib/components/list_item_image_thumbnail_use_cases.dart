import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// ListItemImageThumbnail (seed node 3694:16209). No bundled photos: the
/// story shows the placeholder (the app passes an ImageProvider).
WidgetbookComponent looviListItemImageThumbnailComponent() => WidgetbookComponent(
      name: 'ListItemImageThumbnail',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) => SeedStory(
            component: 'ListItemImageThumbnail',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Align(alignment: Alignment.centerLeft, child: LooviListItemImageThumbnail()),
                LooviListItem(
                  headline: 'Vistoria do veículo',
                  supportingText: 'Envie as fotos do veículo pelo app para concluir a vistoria.',
                  leading: const LooviListItemImageThumbnail(),
                  trailingIcon: LooviIcons.chevronRightOutline,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
