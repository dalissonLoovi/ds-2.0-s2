// Direct src imports until the wave export lands in lib/loovi_ds.dart.

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// ImageItem (seed node 3671:2329). No bundled photos: the stories show the
/// `background-surface/1` placeholder (the app passes an ImageProvider).
WidgetbookComponent looviImageItemComponent() => WidgetbookComponent(
  name: 'ImageItem',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        final verticalResize = k.boolean(label: 'verticalResize', initialValue: false);
        final showSupporting = k.boolean(label: 'photoText showSupportingText', initialValue: true);
        final item = LooviImageItem(
          aspectRatio: k.object.dropdown<LooviImageItemAspectRatio>(
            label: 'aspectRatio',
            options: LooviImageItemAspectRatio.values,
            initialOption: LooviImageItemAspectRatio.ratio3x2,
            labelBuilder: (v) => '${v.w}-${v.h}',
          ),
          orientation: k.object.dropdown<LooviImageItemOrientation>(
            label: 'orientation',
            options: LooviImageItemOrientation.values,
            initialOption: LooviImageItemOrientation.landscape,
            labelBuilder: (v) => v.name,
          ),
          verticalResize: verticalResize,
          showOrientationItem: k.boolean(label: 'showOrientationItem', initialValue: true),
          showPhotoTextItem: k.boolean(label: 'showPhotoTextItem', initialValue: false),
          photoTextLabel: k.string(label: 'photoText label', initialValue: 'Seguro auto'),
          photoTextSupportingText: showSupporting ? k.string(label: 'photoText supportingText', initialValue: 'Proteção completa') : null,
          semanticLabel: k.string(label: 'alt (semanticLabel)', initialValue: 'Foto do veículo'),
        );
        return SeedStory(
          component: 'ImageItem',
          child: verticalResize
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(height: 200, child: item),
                )
              : item,
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const SeedStory(component: 'ImageItem', showDescription: false, child: _ImageItemDefault()),
    ),
  ],
);

/// Same content as the golden `image_item.png`, plus a Carousel of ImageItems.
class _ImageItemDefault extends StatelessWidget {
  const _ImageItemDefault();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(child: LooviImageItem(aspectRatio: LooviImageItemAspectRatio.ratio3x2, showOrientationItem: true)),
            SizedBox(width: t.spacing.s200),
            const Expanded(
              child: LooviImageItem(
                aspectRatio: LooviImageItemAspectRatio.ratio3x2,
                orientation: LooviImageItemOrientation.portrait,
                showOrientationItem: true,
              ),
            ),
          ],
        ),
        SizedBox(height: t.spacing.s200),
        const LooviImageItem(
          aspectRatio: LooviImageItemAspectRatio.ratio16x9,
          showPhotoTextItem: true,
          photoTextLabel: 'Seguro auto',
          photoTextSupportingText: 'Proteção completa para o seu carro',
        ),
        SizedBox(height: t.spacing.s300),
        LooviCarousel(
          semanticLabel: 'Ofertas',
          children: [
            for (final label in ['Seguro auto', 'Assistência 24h', 'Rastreamento'])
              LooviImageItem(aspectRatio: LooviImageItemAspectRatio.ratio4x3, showPhotoTextItem: true, photoTextLabel: label),
          ],
        ),
      ],
    );
  }
}
