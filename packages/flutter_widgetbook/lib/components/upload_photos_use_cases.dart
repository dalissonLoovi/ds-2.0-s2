import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// UploadPhotos (seed node 3581:7597) — Playground + Statuses. The app
/// captures the photo in onSelectPhoto / onRetakePhoto.
WidgetbookComponent looviUploadPhotosComponent() => WidgetbookComponent(
      name: 'UploadPhotos',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            return SeedStory(
              component: 'UploadPhotos',
              child: LooviUploadPhotos(
                label: k.string(label: 'label', initialValue: 'Frente do veículo'),
                status: k.object.dropdown<LooviUploadPhotosStatus>(
                  label: 'status',
                  options: LooviUploadPhotosStatus.values,
                  labelBuilder: (v) => v == LooviUploadPhotosStatus.inReview ? 'in-review' : v.name,
                ),
                description: k.string(label: 'description', initialValue: 'Foto nítida, sem reflexo.'),
                showDescription: k.boolean(label: 'showDescription'),
                onSelectPhoto: () {},
                onRetakePhoto: () {},
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Statuses',
          builder: (context) => const SeedStory(
            component: 'UploadPhotos',
            showDescription: false,
            child: _UploadPhotosStatuses(),
          ),
        ),
      ],
    );

/// Every status, then pending with description. Same layout as the golden
/// `upload_photos_statuses.png`.
class _UploadPhotosStatuses extends StatelessWidget {
  const _UploadPhotosStatuses();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      for (final s in LooviUploadPhotosStatus.values) ...[
        LooviUploadPhotos(label: 'Frente do veículo', status: s, onSelectPhoto: () {}, onRetakePhoto: () {}),
        SizedBox(height: t.spacing.s200),
      ],
      LooviUploadPhotos(
        label: 'Chassi',
        description: 'Foto nítida, sem reflexo, com o número legível.',
        showDescription: true,
        onSelectPhoto: () {},
      ),
    ]);
  }
}
