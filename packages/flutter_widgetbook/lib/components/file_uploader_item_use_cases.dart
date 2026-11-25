import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// FileUploaderItem (seed node 3581:5641) — Playground + Matrix.
/// Seed `state=focus` is runtime (keyboard focus on the remove action); the
/// Matrix forces it.
WidgetbookComponent looviFileUploaderItemComponent() => WidgetbookComponent(
      name: 'FileUploaderItem',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            return SeedStory(
              component: 'FileUploaderItem',
              child: LooviFileUploaderItem(
                fileName: k.string(label: 'fileName', initialValue: 'documento-veiculo.png'),
                size: k.object.dropdown<LooviFileUploaderItemSize>(
                  label: 'size',
                  options: LooviFileUploaderItemSize.values,
                  initialOption: LooviFileUploaderItemSize.lg,
                  labelBuilder: (v) => v.name,
                ),
                state: k.object.dropdown<LooviFileUploaderItemState>(
                  label: 'state',
                  options: LooviFileUploaderItemState.values,
                  labelBuilder: (v) => v.name,
                ),
                shortDescription: k.string(label: 'shortDescription', initialValue: 'O arquivo excede o limite de tamanho.'),
                longDescription: k.string(
                  label: 'longDescription',
                  initialValue: 'Envie uma imagem de até 500 KB nos formatos .jpg ou .png.',
                ),
                onRemove: () {},
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Matrix',
          builder: (context) => const SeedStory(
            component: 'FileUploaderItem',
            showDescription: false,
            child: _FileUploaderItemMatrix(),
          ),
        ),
      ],
    );

/// Every state × size (lg, md, sm) + forced focus on remove. Same layout as
/// the golden `file_uploader_item_matrix.png`.
class _FileUploaderItemMatrix extends StatefulWidget {
  const _FileUploaderItemMatrix();

  @override
  State<_FileUploaderItemMatrix> createState() => _FileUploaderItemMatrixState();
}

class _FileUploaderItemMatrixState extends State<_FileUploaderItemMatrix> {
  final _focus = WidgetStatesController({WidgetState.focused});

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget item(LooviFileUploaderItemSize size, LooviFileUploaderItemState state, {bool focus = false}) => Padding(
          padding: EdgeInsets.only(bottom: t.spacing.s100),
          child: LooviFileUploaderItem(
            fileName: 'documento-veiculo.png',
            size: size,
            state: state,
            shortDescription: 'O arquivo excede o limite de tamanho.',
            longDescription: 'Envie uma imagem de até 500 KB nos formatos .jpg ou .png.',
            onRemove: () {},
            removeStatesController: focus ? _focus : null,
          ),
        );
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      for (final size in LooviFileUploaderItemSize.values.reversed) ...[
        for (final state in LooviFileUploaderItemState.values) item(size, state),
        item(size, LooviFileUploaderItemState.uploaded, focus: true),
      ],
    ]);
  }
}
