import 'package:flutter/semantics.dart' show SemanticsValidationResult;
import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../generated/loovi_icon_names.g.dart';
import '../input/loovi_input.dart';
import '../list_item/loovi_list_item.dart';

/// Outlined trigger field shared by InputSelect and InputDatePicker (seed
/// `reactFieldFrame`): same frame as [LooviInput] — paint resolved by
/// [LooviInputFieldColors], floating label by [LooviInputFloatingLabel] — but
/// read-only: no caret, no typing; the whole field is one button.
///
/// Internal to the field family; not exported by the package barrel.
class LooviSelectTriggerField extends StatefulWidget {
  const LooviSelectTriggerField({
    super.key,
    required this.label,
    required this.displayValue,
    required this.placeholder,
    required this.supportingText,
    required this.showSupportingText,
    required this.errorText,
    required this.error,
    required this.enabled,
    required this.appearance,
    required this.leadingIcon,
    required this.leading,
    required this.trailing,
    required this.trailingSize,
    required this.expanded,
    required this.onTap,
    this.focusNode,
    this.autofocus = false,
    this.semanticHint,
  });

  final String label;

  /// Text shown when the field has a value (`content=value`). Null/empty =
  /// placeholder or resting label.
  final String? displayValue;
  final String? placeholder;
  final String? supportingText;
  final bool showSupportingText;
  final String? errorText;
  final bool error;
  final bool enabled;
  final LooviInputAppearance appearance;
  final bool leadingIcon;
  final String leading;

  /// Always-visible trailing icon (chevron / calendar).
  final String trailing;

  /// Painted size of [trailing] (Figma: chevron and calendar 20).
  final double trailingSize;

  /// Menu / picker open → paints `state=focus` (seed: open state lives on
  /// the screen; the field shows focus while it is open).
  final bool expanded;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final bool autofocus;

  /// Extra accessible hint (e.g. "Abre a lista de opções").
  final String? semanticHint;

  bool get hasError => error || errorText != null;

  @override
  State<LooviSelectTriggerField> createState() => _LooviSelectTriggerFieldState();
}

class _LooviSelectTriggerFieldState extends State<LooviSelectTriggerField> {
  bool _focusHighlight = false;

  void _activate() {
    if (widget.enabled) widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final scaler = MediaQuery.textScalerOf(context);
    final inverse = widget.appearance == LooviInputAppearance.inverse;
    final hasError = widget.hasError;
    final focused = widget.enabled && (widget.expanded || _focusHighlight);
    final c = LooviInputFieldColors.resolve(
      t,
      appearance: widget.appearance,
      focused: focused,
      error: hasError,
      enabled: widget.enabled,
    );

    final hasValue = (widget.displayValue ?? '').isNotEmpty;
    final hasPlaceholder = (widget.placeholder ?? '').isNotEmpty;
    final floated = focused || hasValue || hasPlaceholder;

    final valueStyle = t.typography.bodyLargeRegular;
    final labelStyle = t.typography.bodySmallRegular.copyWith(color: c.label);
    final labelHalf = scaler.scale(labelStyle.fontSize!) * labelStyle.height! / 2;
    final iconSize = t.spacing.s250;
    final gap = t.spacing.s100;

    // Trailing chevron/calendar: same ramp as the leading icon, except on
    // error where it stays neutral (Figma: text/primary | text/on-color) and
    // the alert carries the status.
    final enabledTrailing = hasError ? (inverse ? t.text.onColor : t.text.primary) : c.leadingIcon;
    final trailingColor = widget.enabled ? enabledTrailing : c.leadingIcon;

    final String text;
    final Color textColor;
    if (hasValue) {
      text = widget.displayValue!;
      textColor = c.value;
    } else if (floated) {
      text = widget.placeholder ?? '';
      textColor = c.placeholder;
    } else {
      text = widget.label;
      textColor = c.label;
    }

    final supporting = widget.errorText ?? widget.supportingText;
    final showSupporting = widget.showSupportingText && (supporting ?? '').isNotEmpty;

    final field = DecoratedBox(
      decoration: BoxDecoration(
        color: c.fill,
        border: Border.all(color: c.border, width: c.borderWidth),
        borderRadius: BorderRadius.circular(t.component.input.fieldRadius),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: t.spacing.s700, minWidth: double.infinity),
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: t.spacing.s300,
            end: t.spacing.s300,
            top: t.spacing.s050,
            bottom: t.spacing.s050,
          ),
          child: Row(
            children: [
              if (widget.leadingIcon) ...[
                LooviIcon(widget.leading, size: iconSize, color: c.leadingIcon),
                SizedBox(width: gap),
              ],
              Expanded(
                child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: valueStyle.copyWith(color: textColor)),
              ),
              if (hasError) ...[
                SizedBox(width: gap),
                LooviIcon(LooviIcons.alertCircleOutline, size: iconSize, color: c.errorIcon),
              ],
              SizedBox(width: gap),
              LooviIcon(widget.trailing, size: widget.trailingSize, color: trailingColor),
            ],
          ),
        ),
      ),
    );

    final labelStart = t.spacing.s300 + (widget.leadingIcon ? iconSize + gap : 0) - t.spacing.s050;

    final interactive = FocusableActionDetector(
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onShowFocusHighlight: (v) => setState(() => _focusHighlight = v),
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
          _activate();
          return null;
        }),
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        excludeFromSemantics: true,
        onTap: widget.enabled ? _activate : null,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(padding: EdgeInsets.only(top: labelHalf), child: field),
            if (floated && widget.label.isNotEmpty)
              PositionedDirectional(
                top: c.borderWidth / 2,
                start: labelStart,
                end: t.spacing.s300,
                child: LooviInputFloatingLabel(text: widget.label, style: labelStyle, cutout: c.cutout),
              ),
          ],
        ),
      ),
    );

    final hint = [if (showSupporting) supporting!, ?widget.semanticHint].join('. ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          container: true,
          button: true,
          enabled: widget.enabled,
          expanded: widget.expanded,
          focusable: widget.enabled,
          focused: widget.enabled ? _focusHighlight : null,
          label: widget.label,
          value: hasValue ? widget.displayValue : null,
          hint: hint.isEmpty ? null : hint,
          validationResult: hasError ? SemanticsValidationResult.invalid : SemanticsValidationResult.none,
          onTap: widget.enabled ? _activate : null,
          excludeSemantics: true,
          child: interactive,
        ),
        if (showSupporting)
          ExcludeSemantics(
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: t.spacing.s200, end: t.spacing.s200, top: t.spacing.s050),
              child: Text(supporting!, style: t.typography.bodySmallRegular.copyWith(color: c.supporting)),
            ),
          ),
      ],
    );
  }
}

/// One selectable row of an options list (stand-in for the floating
/// ListActionDropdown the seed composes at screen level, which is not in the
/// Flutter package yet): [LooviListItem] `1-line` with `check-outline` on the
/// selected row, exposed as a selected button.
class LooviSelectOptionRow extends StatelessWidget {
  const LooviSelectOptionRow({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Semantics(
        selected: selected,
        inMutuallyExclusiveGroup: true,
        child: LooviListItem(
          headline: label,
          condition: LooviListItemCondition.oneLine,
          trailingIcon: selected ? LooviIcons.checkOutline : null,
          onTap: onTap,
        ),
      ),
    );
  }
}

/// Vertical list of [LooviSelectOptionRow]; scrolls the selected row into
/// view on first build (long lists such as years).
class LooviSelectOptionList extends StatefulWidget {
  const LooviSelectOptionList({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int? selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  State<LooviSelectOptionList> createState() => _LooviSelectOptionListState();
}

class _LooviSelectOptionListState extends State<LooviSelectOptionList> {
  final _selectedKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _selectedKey.currentContext;
      if (ctx != null && ctx.mounted) Scrollable.ensureVisible(ctx, alignment: 0.5);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < widget.labels.length; i++)
            LooviSelectOptionRow(
              key: i == widget.selectedIndex ? _selectedKey : null,
              label: widget.labels[i],
              selected: i == widget.selectedIndex,
              onTap: () => widget.onSelected(i),
            ),
        ],
      ),
    );
  }
}
