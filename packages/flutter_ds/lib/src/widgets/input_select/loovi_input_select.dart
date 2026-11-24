import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../generated/loovi_icon_names.g.dart';
import '../bottom_sheet/loovi_bottom_sheet.dart';
import '../input/loovi_input.dart';
import 'loovi_select_field.dart';

/// One option of [LooviInputSelect]: the [value] handed to `onChanged` and the
/// visible [label] (seed `value` TEXT when selected).
@immutable
class LooviInputSelectOption<T> {
  const LooviInputSelectOption({required this.value, required this.label});

  final T value;
  final String label;
}

/// Seed `InputSelect` (Figma 3898:2755) — outlined select trigger with a
/// floating label. Not a free-text Input: no caret, no typing.
///
/// Same frame as [LooviInput] (paint from `LooviInputFieldColors`):
/// - field: min height `spacing/700` (56), radius
///   `component/input/field/radius` (app-cliente → `border/radius/full`),
///   padding `spacing/300` × `spacing/050`, gap `spacing/100`; fill
///   `color/background-surface/0` (inverse: transparent); stroke
///   `color/border/1` | `color/border/2` (inverse) `border/width/012`, focus
///   `interactive/focus` / error `color/border-feedback/danger`
///   `border/width/025`.
/// - value `body/large/regular` `text/primary` (inverse `text/on-color`);
///   placeholder `text/placeholder` (inverse `text/on-color-disabled`); label
///   `text/secondary` (inverse `text/on-color`, focus `text/brand`, error
///   `text/danger`); floating label `body/small/regular` on a cutout
///   `color/background-surface/0` (inverse `color/background-surface/inverse-3`).
/// - leading icon 20 (`spacing/250`) `text/secondary` / brand / placeholder /
///   `feedback/danger`; trailing chevron 20 (`spacing/250`, same as Input; Figma aligned 2026-11-24) —
///   `chevron-down-outline`, `chevron-up-outline` while open; on error the
///   chevron stays `text/primary` (inverse `text/on-color`) and
///   `alert-circle-outline` (`feedback/danger`) is added before it.
/// - supporting row `body/small/regular`, padding `spacing/200`, top
///   `spacing/050`; `text/secondary` / `text/danger`.
///
/// Opening: tap/Enter opens a [LooviBottomSheet] (title = [sheetTitle] or
/// [label]) listing [options] as 1-line ListItems with `check-outline` on
/// the selected one; while it is open the field paints `state=focus`.
/// Pass [onTap] to compose your own menu instead (then drive [expanded]).
/// No hover on the app.
///
/// Semantics: button with `expanded`, label = [label], value = selected
/// option, invalid on error.
class LooviInputSelect<T> extends StatefulWidget {
  const LooviInputSelect({
    super.key,
    this.label = 'Label',
    this.options = const [],
    this.value,
    this.onChanged,
    this.placeholder,
    this.supportingText,
    this.showSupportingText = true,
    this.errorText,
    this.error = false,
    this.enabled = true,
    this.appearance = LooviInputAppearance.standard,
    this.leadingIcon = false,
    this.leading = LooviIcons.searchOutline,
    this.trailing = LooviIcons.chevronDownOutline,
    this.sheetTitle,
    this.onTap,
    this.expanded = false,
    this.focusNode,
    this.autofocus = false,
  });

  /// Seed `label`.
  final String label;

  /// Choices shown in the sheet.
  final List<LooviInputSelectOption<T>> options;

  /// Selected value (controlled). Its option label is the seed `value` text.
  final T? value;

  /// Called with the picked value. Null + no [onTap] = read-only (disabled).
  final ValueChanged<T>? onChanged;

  /// Seed `placeholder` (floats the label when there is no value).
  final String? placeholder;

  /// Seed `supportingText`.
  final String? supportingText;

  /// Seed `showSupportingText`.
  final bool showSupportingText;

  /// Error message — puts the field in `state=error` and replaces
  /// [supportingText].
  final String? errorText;

  /// Seed `state=error` without its own message.
  final bool error;

  /// `false` = seed `state=disabled`.
  final bool enabled;

  /// Seed `appearance`.
  final LooviInputAppearance appearance;

  /// Seed `leadingIcon` (variant axis).
  final bool leadingIcon;

  /// Seed `leading` (INSTANCE_SWAP, default `search-outline`).
  final String leading;

  /// Seed `trailing` (INSTANCE_SWAP, default `chevron-down-outline`; the
  /// default flips to `chevron-up-outline` while open).
  final String trailing;

  /// Sheet header title. Defaults to [label].
  final String? sheetTitle;

  /// Custom open action (e.g. a screen-level menu). Replaces the built-in
  /// sheet; the caller drives [expanded].
  final VoidCallback? onTap;

  /// Open state when [onTap] is used (the built-in sheet manages its own).
  final bool expanded;

  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<LooviInputSelect<T>> createState() => _LooviInputSelectState<T>();
}

class _LooviInputSelectState<T> extends State<LooviInputSelect<T>> {
  bool _open = false;

  bool get _interactive => widget.enabled && (widget.onTap != null || widget.onChanged != null);

  int? get _selectedIndex {
    final i = widget.options.indexWhere((o) => o.value == widget.value);
    return (widget.value == null || i < 0) ? null : i;
  }

  Future<void> _openSheet() async {
    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }
    if (_open) return;
    setState(() => _open = true);
    final picked = await showLooviBottomSheet<LooviInputSelectOption<T>>(
      context,
      title: widget.sheetTitle ?? widget.label,
      builder: (sheetContext) => LooviSelectOptionList(
        labels: [for (final o in widget.options) o.label],
        selectedIndex: _selectedIndex,
        onSelected: (i) => Navigator.of(sheetContext).pop(widget.options[i]),
      ),
    );
    if (!mounted) return;
    setState(() => _open = false);
    if (picked != null) widget.onChanged?.call(picked.value);
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final expanded = widget.onTap != null ? widget.expanded : _open;
    final i = _selectedIndex;
    final trailing = (expanded && widget.trailing == LooviIcons.chevronDownOutline)
        ? LooviIcons.chevronUpOutline
        : widget.trailing;

    return LooviSelectTriggerField(
      label: widget.label,
      displayValue: i == null ? null : widget.options[i].label,
      placeholder: widget.placeholder,
      supportingText: widget.supportingText,
      showSupportingText: widget.showSupportingText,
      errorText: widget.errorText,
      error: widget.error,
      enabled: _interactive,
      appearance: widget.appearance,
      leadingIcon: widget.leadingIcon,
      leading: widget.leading,
      trailing: trailing,
      trailingSize: t.spacing.s250,
      expanded: expanded,
      onTap: _openSheet,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
    );
  }
}
