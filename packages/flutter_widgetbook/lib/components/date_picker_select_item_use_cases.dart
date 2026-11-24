// Direct src import until lib/loovi_ds.dart exports DatePickerSelectItem (wave 3 integration).

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

/// Seed `DatePickerSelectItem` (3982:5083) — Playground (knobs) + States.
WidgetbookComponent looviDatePickerSelectItemComponent() => WidgetbookComponent(
      name: 'DatePickerSelectItem',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) => SeedStory(
            component: 'DatePickerSelectItem',
            child: Center(
              child: LooviDatePickerSelectItem(
                unit: context.knobs.object.dropdown<LooviDatePickerSelectItemUnit>(
                  label: 'unit',
                  options: LooviDatePickerSelectItemUnit.values,
                  labelBuilder: (v) => v.name,
                ),
                value: context.knobs.string(label: 'value', initialValue: '21'),
                expanded: context.knobs.boolean(label: 'expanded'),
                enabled: !context.knobs.boolean(label: 'state=disabled'),
                onTap: () {},
              ),
            ),
          ),
        ),
        WidgetbookUseCase(
          name: 'States',
          builder: (context) {
            final t = LooviTokens.of(context);
            final gap = SizedBox(width: t.spacing.s100);
            return SeedStory(
              component: 'DatePickerSelectItem',
              showDescription: false,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  LooviDatePickerSelectItem(value: '21', onTap: () {}),
                  gap,
                  LooviDatePickerSelectItem(
                    unit: LooviDatePickerSelectItemUnit.month,
                    value: 'Abril',
                    expanded: true,
                    onTap: () {},
                  ),
                  gap,
                  const LooviDatePickerSelectItem(unit: LooviDatePickerSelectItemUnit.year, value: '2025', enabled: false),
                ],
              ),
            );
          },
        ),
      ],
    );
