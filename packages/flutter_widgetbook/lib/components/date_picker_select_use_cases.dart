// Direct src imports until lib/loovi_ds.dart exports DatePickerSelect / Item (wave 3 integration).

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'seed_header.dart';

String _formatName(LooviDatePickerSelectFormat f) => switch (f) {
      LooviDatePickerSelectFormat.dayMonthYear => 'day-month-year',
      LooviDatePickerSelectFormat.dayMonth => 'day-month',
      LooviDatePickerSelectFormat.monthYear => 'month-year',
      LooviDatePickerSelectFormat.year => 'year',
    };

/// Seed `DatePickerSelect` (4004:2227) — Playground (knobs) + Formats.
WidgetbookComponent looviDatePickerSelectComponent() => WidgetbookComponent(
      name: 'DatePickerSelect',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) => SeedStory(
            component: 'DatePickerSelect',
            child: _StripPlayground(
              format: context.knobs.object.dropdown<LooviDatePickerSelectFormat>(
                label: 'format',
                options: LooviDatePickerSelectFormat.values,
                labelBuilder: _formatName,
              ),
              enabled: !context.knobs.boolean(label: 'state=disabled'),
              dayValue: context.knobs.string(label: 'dayValue', initialValue: '21'),
              monthValue: context.knobs.string(label: 'monthValue', initialValue: 'Abril'),
              yearValue: context.knobs.string(label: 'yearValue', initialValue: '2025'),
            ),
          ),
        ),
        WidgetbookUseCase(
          name: 'Formats',
          builder: (context) {
            final t = LooviTokens.of(context);
            return SeedStory(
              component: 'DatePickerSelect',
              showDescription: false,
              child: Column(
                children: [
                  for (final f in LooviDatePickerSelectFormat.values) ...[
                    Text('format=${_formatName(f)}', style: t.typography.captionLargeRegular.copyWith(color: t.text.secondary)),
                    LooviDatePickerSelect(format: f, onUnitTap: (_) {}),
                    SizedBox(height: t.spacing.s200),
                  ],
                  Text('state=disabled', style: t.typography.captionLargeRegular.copyWith(color: t.text.secondary)),
                  const LooviDatePickerSelect(enabled: false),
                ],
              ),
            );
          },
        ),
      ],
    );

/// Strip whose tapped block toggles `expanded` (the options list is composed
/// outside — see InputDatePicker for the full sheet).
class _StripPlayground extends StatefulWidget {
  const _StripPlayground({
    required this.format,
    required this.enabled,
    required this.dayValue,
    required this.monthValue,
    required this.yearValue,
  });

  final LooviDatePickerSelectFormat format;
  final bool enabled;
  final String dayValue;
  final String monthValue;
  final String yearValue;

  @override
  State<_StripPlayground> createState() => _StripPlaygroundState();
}

class _StripPlaygroundState extends State<_StripPlayground> {
  LooviDatePickerSelectItemUnit? _open;

  @override
  Widget build(BuildContext context) => LooviDatePickerSelect(
        format: widget.format,
        enabled: widget.enabled,
        dayValue: widget.dayValue,
        monthValue: widget.monthValue,
        yearValue: widget.yearValue,
        expandedUnit: _open,
        onUnitTap: (u) => setState(() => _open = _open == u ? null : u),
      );
}
