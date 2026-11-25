import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

const _files = [
  LooviFileUploaderFile(fileName: 'cnh-frente.png', id: 1),
  LooviFileUploaderFile(fileName: 'cnh-verso.png', id: 2, state: LooviFileUploaderItemState.loading),
  LooviFileUploaderFile(
    fileName: 'comprovante.heic',
    id: 3,
    state: LooviFileUploaderItemState.dangerShort,
    shortDescription: 'Formato não suportado.',
  ),
];

/// FileUploader (seed node 3581:4454) — Playground + Matrix. The app opens
/// its picker in `onPick` and feeds `files` back with each state.
WidgetbookComponent looviFileUploaderComponent() => WidgetbookComponent(
      name: 'FileUploader',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            return SeedStory(
              component: 'FileUploader',
              child: LooviFileUploader(
                label: k.string(label: 'label', initialValue: 'Enviar arquivos'),
                description: k.string(label: 'description', initialValue: 'Tamanho máximo de 500 KB. Formatos .jpg e .png.'),
                variant: k.object.dropdown<LooviFileUploaderVariant>(
                  label: 'variant',
                  options: LooviFileUploaderVariant.values,
                  labelBuilder: (v) => v == LooviFileUploaderVariant.standard ? 'default' : 'drag-and-drop',
                ),
                size: k.object.dropdown<LooviFileUploaderSize>(
                  label: 'size',
                  options: LooviFileUploaderSize.values,
                  initialOption: LooviFileUploaderSize.lg,
                  labelBuilder: (v) => v.name,
                ),
                state: k.object.dropdown<LooviFileUploaderState>(
                  label: 'state',
                  options: LooviFileUploaderState.values,
                  labelBuilder: (v) => v == LooviFileUploaderState.standard ? 'default' : v.name,
                ),
                showFiles: k.boolean(label: 'showFiles', initialValue: true),
                files: _files,
                onPick: () {},
                onRemove: (_) {},
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Matrix',
          builder: (context) => const SeedStory(
            component: 'FileUploader',
            showDescription: false,
            child: _FileUploaderMatrix(),
          ),
        ),
      ],
    );

/// variant × state at lg, then default at sm. Same layout as the golden
/// `file_uploader_matrix.png` (story files include loading / error rows).
class _FileUploaderMatrix extends StatelessWidget {
  const _FileUploaderMatrix();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget uploader(LooviFileUploaderVariant v, LooviFileUploaderState s, {LooviFileUploaderSize size = LooviFileUploaderSize.lg}) =>
        Padding(
          padding: EdgeInsets.only(bottom: t.spacing.s200),
          child: LooviFileUploader(
            label: 'Enviar arquivos',
            description: 'Tamanho máximo de 500 KB. Formatos .jpg e .png.',
            variant: v,
            state: s,
            size: size,
            files: _files,
            onPick: () {},
            onRemove: (_) {},
          ),
        );
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      for (final v in LooviFileUploaderVariant.values)
        for (final s in LooviFileUploaderState.values) uploader(v, s),
      uploader(LooviFileUploaderVariant.standard, LooviFileUploaderState.standard, size: LooviFileUploaderSize.sm),
    ]);
  }
}
