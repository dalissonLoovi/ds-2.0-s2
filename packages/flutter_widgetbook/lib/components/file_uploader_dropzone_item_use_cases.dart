import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// FileUploaderDropzoneItem (seed node 3581:5628) — Playground + States.
/// The surface only asks the app to open its picker (onPick); no
/// drag-and-drop on mobile (`dragHover` is a knob for parity).
WidgetbookComponent looviFileUploaderDropzoneItemComponent() => WidgetbookComponent(
      name: 'FileUploaderDropzoneItem',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            return SeedStory(
              component: 'FileUploaderDropzoneItem',
              child: LooviFileUploaderDropzoneItem(
                onPick: () {},
                helperText: k.string(
                  label: 'helperText',
                  initialValue: 'Toque para selecionar o arquivo.',
                ),
                disabled: k.boolean(label: 'state=disabled'),
                dragHover: k.boolean(label: 'state=drag-hover'),
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'States',
          builder: (context) => const SeedStory(
            component: 'FileUploaderDropzoneItem',
            showDescription: false,
            child: _DropzoneStates(),
          ),
        ),
      ],
    );

/// default · drag-hover · focus (forced) · disabled. Same layout as the golden
/// `file_uploader_dropzone_item_states.png`.
class _DropzoneStates extends StatefulWidget {
  const _DropzoneStates();

  @override
  State<_DropzoneStates> createState() => _DropzoneStatesState();
}

class _DropzoneStatesState extends State<_DropzoneStates> {
  final _focus = WidgetStatesController({WidgetState.focused});

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget gap() => SizedBox(height: t.spacing.s200);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      LooviFileUploaderDropzoneItem(onPick: () {}),
      gap(),
      LooviFileUploaderDropzoneItem(onPick: () {}, dragHover: true),
      gap(),
      LooviFileUploaderDropzoneItem(onPick: () {}, statesController: _focus),
      gap(),
      LooviFileUploaderDropzoneItem(onPick: () {}, disabled: true),
    ]);
  }
}
