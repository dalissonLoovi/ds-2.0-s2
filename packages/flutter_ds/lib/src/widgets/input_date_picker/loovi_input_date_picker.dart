import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../generated/loovi_icon_names.g.dart';
import '../bottom_sheet/loovi_bottom_sheet.dart';
import '../button/loovi_button.dart';
import '../date_picker_select/loovi_date_picker_select.dart';
import '../date_picker_select_item/loovi_date_picker_select_item.dart';
import '../input/loovi_input.dart';
import '../input_select/loovi_select_field.dart';

/// Default field text: `21 abr 2025` (Figma demo), pt-BR short month.
String looviFormatDate(DateTime date) {
  const short = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez'];
  return '${date.day.toString().padLeft(2, '0')} ${short[date.month - 1]} ${date.year}';
}

/// Seed `InputDatePicker` (Figma 3985:1386) — outlined date-field trigger.
///
/// Same frame and paint as [LooviInput] / InputSelect (see
/// `LooviInputFieldColors`): min height `spacing/700`, radius
/// `component/input/field/radius` (app-cliente → `border/radius/full`),
/// padding `spacing/300` × `spacing/050`, gap `spacing/100`, value
/// `body/large/regular`, floating label `body/small/regular` with cutout,
/// supporting `body/small/regular`. Trailing `calendar-outline` 20
/// (`spacing/250`) always present — `text/secondary` / `text/brand` (open) /
/// `text/placeholder` (disabled); inverse `text/on-color` /
/// `text/on-color-disabled`; on error it stays `text/primary` (inverse
/// `text/on-color`) and `alert-circle-outline` (`feedback/danger`) is added
/// before it. Disabled (default appearance): no fill, `color/border/1`.
///
/// Opening: tap/Enter opens [showLooviDatePicker] (bottom sheet with
/// [LooviDatePickerSelect] + options per unit + confirm). Pass [onTap] to
/// compose an external calendar instead (then drive [expanded]). While open
/// the field paints `state=focus`. No hover on the app.
///
/// Semantics: button (aria-haspopup=dialog equivalent: hint), `expanded`,
/// label = [label], value = formatted date, invalid on error.
class LooviInputDatePicker extends StatefulWidget {
  const LooviInputDatePicker({
    super.key,
    this.label = 'Data',
    this.value,
    this.onChanged,
    this.firstDate,
    this.lastDate,
    this.format = LooviDatePickerSelectFormat.dayMonthYear,
    this.dateFormatter = looviFormatDate,
    this.placeholder,
    this.supportingText,
    this.showSupportingText = true,
    this.errorText,
    this.error = false,
    this.enabled = true,
    this.appearance = LooviInputAppearance.standard,
    this.leadingIcon = false,
    this.leading = LooviIcons.searchOutline,
    this.trailing = LooviIcons.calendarOutline,
    this.sheetTitle,
    this.confirmLabel = 'Confirmar',
    this.onTap,
    this.expanded = false,
    this.focusNode,
    this.autofocus = false,
  });

  /// Seed `label` (demo "Data").
  final String label;

  /// Selected date (controlled). Shown via [dateFormatter] (seed `value`).
  final DateTime? value;

  /// Called with the confirmed date. Null + no [onTap] = disabled.
  final ValueChanged<DateTime>? onChanged;

  /// Range for the picker (defaults: 1900-01-01 … 2100-12-31).
  final DateTime? firstDate;
  final DateTime? lastDate;

  /// Units offered by the picker sheet.
  final LooviDatePickerSelectFormat format;

  /// Field text for [value].
  final String Function(DateTime) dateFormatter;

  /// Seed `placeholder` (e.g. "Selecione a data").
  final String? placeholder;

  /// Seed `supportingText` / `showSupportingText`.
  final String? supportingText;
  final bool showSupportingText;

  /// Error message (`state=error`); replaces [supportingText].
  final String? errorText;
  final bool error;

  /// `false` = seed `state=disabled`.
  final bool enabled;

  /// Seed `appearance`.
  final LooviInputAppearance appearance;

  /// Seed `leadingIcon` / `leading`.
  final bool leadingIcon;
  final String leading;

  /// Seed `trailing` (INSTANCE_SWAP, default `calendar-outline`).
  final String trailing;

  /// Sheet title (defaults to [label]) and confirm button label.
  final String? sheetTitle;
  final String confirmLabel;

  /// Custom open action (external Calendar). Replaces the built-in sheet.
  final VoidCallback? onTap;

  /// Open state when [onTap] is used.
  final bool expanded;

  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<LooviInputDatePicker> createState() => _LooviInputDatePickerState();
}

class _LooviInputDatePickerState extends State<LooviInputDatePicker> {
  bool _open = false;

  bool get _interactive => widget.enabled && (widget.onTap != null || widget.onChanged != null);

  Future<void> _openPicker() async {
    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }
    if (_open) return;
    setState(() => _open = true);
    final picked = await showLooviDatePicker(
      context,
      initialDate: widget.value,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      format: widget.format,
      title: widget.sheetTitle ?? widget.label,
      confirmLabel: widget.confirmLabel,
    );
    if (!mounted) return;
    setState(() => _open = false);
    if (picked != null) widget.onChanged?.call(picked);
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return LooviSelectTriggerField(
      label: widget.label,
      displayValue: widget.value == null ? null : widget.dateFormatter(widget.value!),
      placeholder: widget.placeholder,
      supportingText: widget.supportingText,
      showSupportingText: widget.showSupportingText,
      errorText: widget.errorText,
      error: widget.error,
      enabled: _interactive,
      appearance: widget.appearance,
      leadingIcon: widget.leadingIcon,
      leading: widget.leading,
      trailing: widget.trailing,
      trailingSize: t.spacing.s250,
      expanded: widget.onTap != null ? widget.expanded : _open,
      onTap: _openPicker,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
    );
  }
}

/// Presents the date picker sheet: [LooviBottomSheet] with a
/// [LooviDatePickerSelect] strip; tapping a block expands it and lists its
/// options below the strip (1-line ListItems, selected = `check-outline`);
/// "Confirmar" (Button solid lg full width) returns the date. Dismiss → null.
///
/// Days are clamped to the month length and the result to
/// [firstDate]…[lastDate]. Units missing from [format] keep the initial
/// value (day → 1 for `month-year` / `year`, month → January for `year`).
Future<DateTime?> showLooviDatePicker(
  BuildContext context, {
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  LooviDatePickerSelectFormat format = LooviDatePickerSelectFormat.dayMonthYear,
  String title = 'Data',
  String confirmLabel = 'Confirmar',
  List<String> monthNames = LooviDatePickerSelect.monthNames,
}) {
  final first = firstDate ?? DateTime(1900);
  final last = lastDate ?? DateTime(2100, 12, 31);
  final start = _clampDate(initialDate ?? DateTime.now(), first, last);
  return showLooviBottomSheet<DateTime>(
    context,
    title: title,
    builder: (sheetContext) => _DatePickerSheetBody(
      initial: start,
      first: first,
      last: last,
      format: format,
      confirmLabel: confirmLabel,
      monthNames: monthNames,
      onConfirm: (d) => Navigator.of(sheetContext).pop(d),
    ),
  );
}

DateTime _clampDate(DateTime d, DateTime first, DateTime last) {
  final day = DateTime(d.year, d.month, d.day);
  if (day.isBefore(first)) return DateTime(first.year, first.month, first.day);
  if (day.isAfter(last)) return DateTime(last.year, last.month, last.day);
  return day;
}

int _daysIn(int year, int month) => DateTime(year, month + 1, 0).day;

class _DatePickerSheetBody extends StatefulWidget {
  const _DatePickerSheetBody({
    required this.initial,
    required this.first,
    required this.last,
    required this.format,
    required this.confirmLabel,
    required this.monthNames,
    required this.onConfirm,
  });

  final DateTime initial;
  final DateTime first;
  final DateTime last;
  final LooviDatePickerSelectFormat format;
  final String confirmLabel;
  final List<String> monthNames;
  final ValueChanged<DateTime> onConfirm;

  @override
  State<_DatePickerSheetBody> createState() => _DatePickerSheetBodyState();
}

class _DatePickerSheetBodyState extends State<_DatePickerSheetBody> {
  late int _day = widget.format.hasDay ? widget.initial.day : 1;
  late int _month = widget.format.hasMonth ? widget.initial.month : 1;
  late int _year = widget.initial.year;
  LooviDatePickerSelectItemUnit? _expanded;

  DateTime get _date {
    final day = _day.clamp(1, _daysIn(_year, _month));
    return _clampDate(DateTime(_year, _month, day), widget.first, widget.last);
  }

  void _toggle(LooviDatePickerSelectItemUnit unit) => setState(() => _expanded = _expanded == unit ? null : unit);

  List<int> _optionValues(LooviDatePickerSelectItemUnit unit) => switch (unit) {
        LooviDatePickerSelectItemUnit.day => [for (var d = 1; d <= _daysIn(_year, _month); d++) d],
        LooviDatePickerSelectItemUnit.month => [for (var m = 1; m <= 12; m++) m],
        LooviDatePickerSelectItemUnit.year => [for (var y = widget.first.year; y <= widget.last.year; y++) y],
      };

  String _label(LooviDatePickerSelectItemUnit unit, int v) => switch (unit) {
        LooviDatePickerSelectItemUnit.day => v.toString().padLeft(2, '0'),
        LooviDatePickerSelectItemUnit.month => widget.monthNames[v - 1],
        LooviDatePickerSelectItemUnit.year => '$v',
      };

  void _select(LooviDatePickerSelectItemUnit unit, int v) {
    setState(() {
      switch (unit) {
        case LooviDatePickerSelectItemUnit.day:
          _day = v;
        case LooviDatePickerSelectItemUnit.month:
          _month = v;
        case LooviDatePickerSelectItemUnit.year:
          _year = v;
      }
      final d = _date;
      _day = widget.format.hasDay ? d.day : _day;
      _month = widget.format.hasMonth ? d.month : _month;
      _year = d.year;
      _expanded = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final d = _date;
    final expanded = _expanded;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LooviDatePickerSelect(
          format: widget.format,
          dayValue: _label(LooviDatePickerSelectItemUnit.day, d.day),
          monthValue: _label(LooviDatePickerSelectItemUnit.month, d.month),
          yearValue: _label(LooviDatePickerSelectItemUnit.year, d.year),
          expandedUnit: expanded,
          onUnitTap: _toggle,
        ),
        if (expanded != null) ...[
          SizedBox(height: t.spacing.s200),
          Builder(builder: (context) {
            final values = _optionValues(expanded);
            final current = switch (expanded) {
              LooviDatePickerSelectItemUnit.day => d.day,
              LooviDatePickerSelectItemUnit.month => d.month,
              LooviDatePickerSelectItemUnit.year => d.year,
            };
            return LooviSelectOptionList(
              key: ValueKey(expanded),
              labels: [for (final v in values) _label(expanded, v)],
              selectedIndex: values.indexOf(current),
              onSelected: (i) => _select(expanded, values[i]),
            );
          }),
        ],
        SizedBox(height: t.spacing.s300),
        LooviButton(
          label: widget.confirmLabel,
          size: LooviButtonSize.lg,
          fullWidth: true,
          onPressed: () => widget.onConfirm(d),
        ),
      ],
    );
  }
}
