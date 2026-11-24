import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../date_picker_select_item/loovi_date_picker_select_item.dart';

/// Seed `DatePickerSelect.format` — which unit blocks are composed.
/// `day-month-year` → [dayMonthYear], `day-month` → [dayMonth],
/// `month-year` → [monthYear], `year` → [year].
enum LooviDatePickerSelectFormat {
  dayMonthYear,
  dayMonth,
  monthYear,
  year;

  bool get hasDay => this == dayMonthYear || this == dayMonth;
  bool get hasMonth => this != year;
  bool get hasYear => this != dayMonth;

  /// Units in visual order.
  List<LooviDatePickerSelectItemUnit> get units => [
        if (hasDay) LooviDatePickerSelectItemUnit.day,
        if (hasMonth) LooviDatePickerSelectItemUnit.month,
        if (hasYear) LooviDatePickerSelectItemUnit.year,
      ];
}

/// Seed `DatePickerSelect` (Figma 4004:2227) — horizontal strip of
/// [LooviDatePickerSelectItem] (day / month / year) to pick date units.
/// Not the calendar panel and not InputDatePicker.
///
/// Paint (mode app-cliente): row, gap `spacing/100`, centered; every block
/// inherits the DatePickerSelectItem tokens. `state` of the seed is runtime
/// (pressed / focus per block); [enabled] = false propagates `disabled` to
/// all blocks. At most one block is [expandedUnit]; its options list is
/// composed outside (seed `noNestedMenu`) — see `showLooviDatePicker`.
///
/// Semantics: a container group (named by [semanticLabel]) of unit buttons.
class LooviDatePickerSelect extends StatelessWidget {
  const LooviDatePickerSelect({
    super.key,
    this.format = LooviDatePickerSelectFormat.dayMonthYear,
    this.dayValue = '21',
    this.monthValue = 'Abril',
    this.yearValue = '2025',
    this.enabled = true,
    this.expandedUnit,
    this.onUnitTap,
    this.semanticLabel,
  });

  /// Seed `format`.
  final LooviDatePickerSelectFormat format;

  /// Seed `dayValue` / `monthValue` / `yearValue` (nested block `value`).
  final String dayValue;
  final String monthValue;
  final String yearValue;

  /// `false` = seed `state=disabled` on every block.
  final bool enabled;

  /// Block currently open (`expanded=true`); null = all closed.
  final LooviDatePickerSelectItemUnit? expandedUnit;

  /// Tap on a block. Null = blocks are not interactive.
  final ValueChanged<LooviDatePickerSelectItemUnit>? onUnitTap;

  /// Accessible name of the group (e.g. "Data de nascimento").
  final String? semanticLabel;

  /// pt-BR month names (Figma demo "Abril").
  static const List<String> monthNames = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', //
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
  ];

  String _value(LooviDatePickerSelectItemUnit unit) => switch (unit) {
        LooviDatePickerSelectItemUnit.day => dayValue,
        LooviDatePickerSelectItemUnit.month => monthValue,
        LooviDatePickerSelectItemUnit.year => yearValue,
      };

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final units = format.units;
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: t.spacing.s100,
        children: [
          for (final unit in units)
            LooviDatePickerSelectItem(
              unit: unit,
              value: _value(unit),
              enabled: enabled,
              expanded: expandedUnit == unit,
              onTap: onUnitTap == null ? null : () => onUnitTap!(unit),
            ),
        ],
      ),
    );
  }
}
