// Direct src import until lib/loovi_ds.dart exports wave 3 (integration).

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// Seed `InputNumberTrailingPaymentMark` (4995:38558) — internal slot of
/// InputNumber: the preferred brands paint the [DS] Payment Method Marks
/// artwork (type=icon); the last one is the empty token placeholder.
WidgetbookComponent looviInputNumberTrailingPaymentMarkComponent() => WidgetbookComponent(
      name: 'InputNumberTrailingPaymentMark',
      useCases: [
        WidgetbookUseCase(
          name: 'Brands',
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
