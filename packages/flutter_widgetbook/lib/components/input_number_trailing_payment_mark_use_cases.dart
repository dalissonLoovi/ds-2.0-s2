// Direct src import until lib/loovi_ds.dart exports wave 3 (integration).

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// Seed `InputNumberTrailingPaymentMark` (4995:38558) — internal slot of
/// InputNumber. The Payment Method Marks artwork is not in the package yet:
/// the story shows the token placeholder per brand.
WidgetbookComponent looviInputNumberTrailingPaymentMarkComponent() => WidgetbookComponent(
      name: 'InputNumberTrailingPaymentMark',
      useCases: [
        WidgetbookUseCase(
          name: 'Brands (placeholder)',
          builder: (context) {
            final t = LooviTokens.of(context);
            return SeedStory(
              component: 'InputNumberTrailingPaymentMark',
              child: Wrap(
                spacing: t.spacing.s200,
                children: [
                  for (final b in LooviInputNumberTrailingPaymentMarkBrand.values)
                    LooviInputNumberTrailingPaymentMark(brand: b),
                  const LooviInputNumberTrailingPaymentMark(),
                ],
              ),
            );
          },
        ),
      ],
    );
