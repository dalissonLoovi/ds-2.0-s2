import 'package:loovi_ds/loovi_ds.dart';
// ignore: implementation_imports — direct import until loovi_ds.dart exports the widget.
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

String _variantName(LooviDividerHorizontalVariant v) => switch (v) {
  LooviDividerHorizontalVariant.fullWidth => 'full-width',
  LooviDividerHorizontalVariant.inset => 'inset',
  LooviDividerHorizontalVariant.middleInset => 'middle-inset',
  LooviDividerHorizontalVariant.withSubhead => 'with-subhead',
};

/// DividerHorizontal (seed node 3653:22914): Playground + Variants.
WidgetbookComponent looviDividerHorizontalComponent() => WidgetbookComponent(
  name: 'DividerHorizontal',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final k = context.knobs;
        return SeedStory(
          component: 'DividerHorizontal',
          child: LooviDividerHorizontal(
            variant: k.object.dropdown<LooviDividerHorizontalVariant>(
              label: 'variant',
              options: LooviDividerHorizontalVariant.values,
              labelBuilder: _variantName,
            ),
            label: k.string(label: 'label (with-subhead)', initialValue: 'Meus veículos'),
            decorative: k.boolean(label: 'decorative', initialValue: true),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Variants',
      builder: (context) {
        final t = LooviTokens.of(context);
        return SeedStory(
          component: 'DividerHorizontal',
          showDescription: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final v in LooviDividerHorizontalVariant.values) ...[
                LooviDividerHorizontal(variant: v, label: 'Meus veículos'),
                SizedBox(height: t.spacing.s400),
              ],
            ],
          ),
        );
      },
    ),
  ],
);
