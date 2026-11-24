// Direct src imports until the wave export lands in lib/loovi_ds.dart.

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// CarouselPaginationItem (seed node 4152:495, internal to Carousel):
/// Playground + Matrix (itemCount x itemView, 14 published; same as the golden
/// `carousel_pagination_item_matrix.png`).
WidgetbookComponent looviCarouselPaginationItemComponent() => WidgetbookComponent(
  name: 'CarouselPaginationItem',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        final count = k.int.slider(label: 'itemCount', initialValue: 4, min: 2, max: 5);
        final view = k.int.slider(label: 'itemView (clamped to itemCount)', initialValue: 1, min: 1, max: 5);
        return SeedStory(
          component: 'CarouselPaginationItem',
          child: LooviCarouselPaginationItem(itemCount: count, itemView: view.clamp(1, count)),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Matrix',
      builder: (context) => const SeedStory(
        component: 'CarouselPaginationItem',
        showDescription: false,
        child: _Matrix(),
      ),
    ),
  ],
);

class _Matrix extends StatelessWidget {
  const _Matrix();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var count = 2; count <= 5; count++)
          Row(
            children: [
              for (var view = 1; view <= 5; view++)
                Expanded(
                  child: view <= count
                      ? LooviCarouselPaginationItem(itemCount: count, itemView: view)
                      : const SizedBox.shrink(),
                ),
            ],
          ),
      ],
    );
  }
}
