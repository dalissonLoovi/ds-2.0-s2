import 'package:loovi_ds/loovi_ds.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// FileUploaderList (seed node 3581:3887) — Playground. The Figma
/// `showFileItem02…07` booleans become a row-count knob (the app maps its
/// files to N items).
WidgetbookComponent looviFileUploaderListComponent() => WidgetbookComponent(
      name: 'FileUploaderList',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            final count = k.int.slider(label: 'rows (showFileItem02…07)', initialValue: 3, min: 1, max: 7);
            final size = k.object.dropdown<LooviFileUploaderItemSize>(
              label: 'item size',
              options: LooviFileUploaderItemSize.values,
              initialOption: LooviFileUploaderItemSize.lg,
              labelBuilder: (v) => v.name,
            );
            final withError = k.boolean(label: 'last row danger-short');
            return SeedStory(
              component: 'FileUploaderList',
              child: LooviFileUploaderList(children: [
                for (var i = 1; i <= count; i++)
                  LooviFileUploaderItem(
                    fileName: 'arquivo-0$i.png',
                    size: size,
                    state: withError && i == count
                        ? LooviFileUploaderItemState.dangerShort
                        : LooviFileUploaderItemState.uploaded,
                    shortDescription: 'Formato não suportado.',
                    onRemove: () {},
                  ),
              ]),
            );
          },
        ),
      ],
    );
