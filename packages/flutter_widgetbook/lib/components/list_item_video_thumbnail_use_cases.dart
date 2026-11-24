// Direct src import until the wave export lands in lib/loovi_ds.dart.
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// ListItemVideoThumbnail (seed node 3694:16211). No bundled photos: the
/// story shows the placeholder poster (the app passes an ImageProvider).
WidgetbookComponent looviListItemVideoThumbnailComponent() => WidgetbookComponent(
      name: 'ListItemVideoThumbnail',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final playable = context.knobs.boolean(label: 'onPlay (botão próprio)');
            return SeedStory(
              component: 'ListItemVideoThumbnail',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: LooviListItemVideoThumbnail(onPlay: playable ? () {} : null),
                  ),
                  LooviListItem(
                    headline: 'Como acionar a assistência',
                    supportingText: 'Vídeo · 2 min',
                    leading: const LooviListItemVideoThumbnail(),
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
