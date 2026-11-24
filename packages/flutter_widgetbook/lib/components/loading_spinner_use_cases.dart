import 'package:loovi_ds/loovi_ds.dart';
// ignore: implementation_imports — direct import until loovi_ds.dart exports the widget.
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// LoadingSpinner (seed node 3062:745): Playground + Sizes.
WidgetbookComponent looviLoadingSpinnerComponent() => WidgetbookComponent(
  name: 'LoadingSpinner',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        return SeedStory(
          component: 'LoadingSpinner',
          child: Align(
            alignment: Alignment.centerLeft,
            child: LooviLoadingSpinner(
              size: k.object.dropdown<LooviLoadingSpinnerSize>(
                label: 'size',
                options: LooviLoadingSpinnerSize.values,
                initialOption: LooviLoadingSpinnerSize.md,
                labelBuilder: (v) => v.name,
              ),
              decorative: k.boolean(label: 'decorative'),
              semanticLabel: k.string(label: 'label', initialValue: 'Carregando'),
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Sizes',
      builder: (context) {
        final t = LooviTokens.of(context);
        return SeedStory(
          component: 'LoadingSpinner',
          showDescription: false,
          child: Row(
            children: [
              for (final s in LooviLoadingSpinnerSize.values) ...[
                LooviLoadingSpinner(size: s),
                SizedBox(width: t.spacing.s300),
              ],
            ],
          ),
        );
      },
    ),
  ],
);
