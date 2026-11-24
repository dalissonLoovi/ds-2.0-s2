// Direct src imports until lib/loovi_ds.dart exports InputDatePicker / DatePickerSelect (wave 3 integration).

import 'package:loovi_ds/loovi_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgetbook/widgetbook.dart';

import 'input_use_cases.dart' show inputSurface;
import 'seed_header.dart';

String _formatName(LooviDatePickerSelectFormat f) => switch (f) {
      LooviDatePickerSelectFormat.dayMonthYear => 'day-month-year',
      LooviDatePickerSelectFormat.dayMonth => 'day-month',
      LooviDatePickerSelectFormat.monthYear => 'month-year',
      LooviDatePickerSelectFormat.year => 'year',
    };

/// Seed `InputDatePicker` (3985:1386) — Playground (knobs) + States.
WidgetbookComponent looviInputDatePickerComponent() => WidgetbookComponent(
      name: 'InputDatePicker',
      useCases: [
        WidgetbookUseCase(
          name: 'Playground',
          builder: (context) {
            final appearance = context.knobs.object.dropdown<LooviInputAppearance>(
              label: 'appearance',
              options: LooviInputAppearance.values,
              labelBuilder: (v) => v == LooviInputAppearance.standard ? 'default' : v.name,
            );
            final field = _DatePlayground(
              label: context.knobs.string(label: 'label', initialValue: 'Data'),
              placeholder: context.knobs.stringOrNull(label: 'placeholder', initialValue: 'Selecione a data'),
              supportingText: context.knobs.string(label: 'supportingText', initialValue: 'Data da vistoria.'),
              showSupportingText: context.knobs.boolean(label: 'showSupportingText'),
              error: context.knobs.boolean(label: 'state=error'),
              enabled: !context.knobs.boolean(label: 'state=disabled'),
              appearance: appearance,
              leadingIcon: context.knobs.boolean(label: 'leadingIcon'),
              format: context.knobs.object.dropdown<LooviDatePickerSelectFormat>(
                label: 'picker format',
                options: LooviDatePickerSelectFormat.values,
                labelBuilder: _formatName,
              ),
            );
            return SeedStory(component: 'InputDatePicker', child: inputSurface(context, appearance, field));
          },
        ),
        WidgetbookUseCase(
          name: 'States',
          builder: (context) => const SeedStory(component: 'InputDatePicker', showDescription: false, child: _DateStates()),
        ),
      ],
    );

class _DatePlayground extends StatefulWidget {
  const _DatePlayground({
    required this.label,
    required this.placeholder,
    required this.supportingText,
    required this.showSupportingText,
    required this.error,
    required this.enabled,
    required this.appearance,
    required this.leadingIcon,
    required this.format,
  });

  final String label;
  final String? placeholder;
  final String supportingText;
  final bool showSupportingText;
  final bool error;
  final bool enabled;
  final LooviInputAppearance appearance;
  final bool leadingIcon;
  final LooviDatePickerSelectFormat format;

  @override
  State<_DatePlayground> createState() => _DatePlaygroundState();
}

class _DatePlaygroundState extends State<_DatePlayground> {
  DateTime? _value;

  @override
  Widget build(BuildContext context) => LooviInputDatePicker(
        label: widget.label,
        placeholder: widget.placeholder,
        supportingText: widget.supportingText,
        showSupportingText: widget.showSupportingText,
        error: widget.error,
        enabled: widget.enabled,
        appearance: widget.appearance,
        leadingIcon: widget.leadingIcon,
        format: widget.format,
        value: _value,
        onChanged: (d) => setState(() => _value = d),
      );
}

class _DateStates extends StatelessWidget {
  const _DateStates();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final gap = SizedBox(height: t.spacing.s200);
    final date = DateTime(2025, 4, 21);
    void noop(DateTime _) {}
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LooviInputDatePicker(label: 'content=label', onChanged: noop),
        gap,
        LooviInputDatePicker(label: 'content=placeholder', placeholder: 'Selecione a data', onChanged: noop),
        gap,
        LooviInputDatePicker(label: 'content=value', value: date, leadingIcon: true, onChanged: noop),
        gap,
        LooviInputDatePicker(label: 'state=focus (open)', value: date, expanded: true, onTap: () {}),
        gap,
        LooviInputDatePicker(label: 'state=error', value: date, errorText: 'Data inválida', onChanged: noop),
        gap,
        LooviInputDatePicker(label: 'state=disabled', value: date, enabled: false),
        gap,
        inputSurface(
          context,
          LooviInputAppearance.inverse,
          LooviInputDatePicker(label: 'appearance=inverse', value: date, appearance: LooviInputAppearance.inverse, onChanged: noop),
        ),
      ],
    );
  }
}
