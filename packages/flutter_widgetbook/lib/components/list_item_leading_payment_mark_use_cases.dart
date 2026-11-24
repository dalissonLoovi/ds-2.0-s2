// Direct src import until the wave export lands in lib/loovi_ds.dart.
import 'package:loovi_ds/loovi_ds.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// ListItemLeadingPaymentMark (seed node 4990:38559) — internal leading slot
/// of ListItem `leading=payment-mark`, shown inside a ListItem row.
WidgetbookComponent looviListItemLeadingPaymentMarkComponent() => WidgetbookComponent(
      name: 'ListItemLeadingPaymentMark',
      useCases: [
        WidgetbookUseCase(
          name: 'In ListItem',
          builder: (context) {
            final k = context.knobs;
            final brand = k.object.dropdown<LooviPaymentMethodMarkBrand>(
              label: 'brand',
              options: LooviPaymentMethodMarkBrand.values,
              initialOption: LooviPaymentMethodMarkBrand.visa,
              labelBuilder: (v) => v.slug,
            );
            return SeedStory(
              component: 'ListItemLeadingPaymentMark',
              child: LooviListItem(
                headline: brand.displayName,
                supportingText: 'Final 1234',
                leading: LooviListItemLeadingPaymentMark(
                  brand: brand,
                  type: k.object.dropdown<LooviPaymentMethodMarkType>(
                    label: 'type',
                    options: LooviPaymentMethodMarkType.values,
                    initialOption: LooviPaymentMethodMarkType.icon,
                    labelBuilder: (v) => v.name,
                  ),
                  showBackground: k.boolean(label: 'showBackground'),
                ),
              ),
            );
          },
        ),
      ],
    );
