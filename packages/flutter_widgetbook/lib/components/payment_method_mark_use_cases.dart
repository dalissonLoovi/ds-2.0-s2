// Direct src import until the wave export lands in lib/loovi_ds.dart.
import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// PaymentMethodMark ([DS] Payment Method Marks, node 7:18) — Playground +
/// catalog of the 25 brands × published variants.
WidgetbookComponent looviPaymentMethodMarkComponent() => WidgetbookComponent(
      name: 'PaymentMethodMark',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final k = context.knobs;
            return SeedStory(
              component: 'PaymentMethodMark',
              child: Align(
                alignment: Alignment.centerLeft,
                child: LooviPaymentMethodMark(
                  brand: k.object.dropdown<LooviPaymentMethodMarkBrand>(
                    label: 'brand',
                    options: LooviPaymentMethodMarkBrand.values,
                    initialOption: LooviPaymentMethodMarkBrand.visa,
                    labelBuilder: (v) => v.slug,
                  ),
                  type: k.object.dropdown<LooviPaymentMethodMarkType>(
                    label: 'type (logo falls back to icon when unpublished)',
                    options: LooviPaymentMethodMarkType.values,
                    initialOption: LooviPaymentMethodMarkType.icon,
                    labelBuilder: (v) => v.name,
                  ),
                  showBackground: k.boolean(label: 'showBackground'),
                  decorative: k.boolean(label: 'decorative'),
                ),
              ),
            );
          },
        ),
        WidgetbookUseCase(
          name: 'Catalog',
          builder: (context) => SeedStory(
            component: 'PaymentMethodMark',
            showDescription: false,
            child: Builder(builder: (context) {
              final t = LooviTokens.of(context);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final b in LooviPaymentMethodMarkBrand.values)
                    Padding(
                      padding: EdgeInsets.only(bottom: t.spacing.s100),
                      child: Wrap(
                        spacing: t.spacing.s200,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          LooviPaymentMethodMark(brand: b),
                          LooviPaymentMethodMark(brand: b, showBackground: true),
                          if (b.hasLogo) LooviPaymentMethodMark(brand: b, type: LooviPaymentMethodMarkType.logo),
                          Text(b.displayName, style: t.typography.captionLargeRegular.copyWith(color: t.text.secondary)),
                        ],
                      ),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
