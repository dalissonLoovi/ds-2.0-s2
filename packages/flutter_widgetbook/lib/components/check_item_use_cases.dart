import 'package:loovi_ds/loovi_ds.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

const _copy = 'Não use óculos, chapéu ou acessórios que atrapalhem o reconhecimento.';
const _strong = 'óculos, chapéu ou acessórios';

/// ModalCheckItem — Figma 4372:19371 (mode app-cliente). Decorative icon; not a checkbox.
WidgetbookComponent looviModalCheckItemComponent() => WidgetbookComponent(
      name: 'ModalCheckItem',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final emphasis = context.knobs.string(label: 'emphasis', initialValue: _strong);
            return SeedStory(
              component: 'ModalCheckItem',
              child: LooviModalCheckItem(
                description: context.knobs.string(label: 'description', initialValue: _copy),
                emphasis: [emphasis],
              ),
            );
          },
        ),
      ],
    );

/// BottomSheetCheckItem — Figma 4389:80 (mode app-cliente). Decorative icon; not a checkbox.
WidgetbookComponent looviBottomSheetCheckItemComponent() => WidgetbookComponent(
      name: 'BottomSheetCheckItem',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final emphasis = context.knobs.string(label: 'emphasis', initialValue: _strong);
            return SeedStory(
              component: 'BottomSheetCheckItem',
              child: LooviBottomSheetCheckItem(
                description: context.knobs.string(label: 'description', initialValue: _copy),
                emphasis: [emphasis],
              ),
            );
          },
        ),
      ],
    );
