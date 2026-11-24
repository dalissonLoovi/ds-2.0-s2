
import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../foundation/loovi_tap_target.dart';
import '../../generated/loovi_icon_names.g.dart';

/// Seed `DatePickerSelectItem.unit` — date unit this trigger selects.
enum LooviDatePickerSelectItemUnit { day, month, year }

/// Seed `DatePickerSelectItem` (Figma 3982:5083) — compact select trigger
/// for one date unit, used inside [LooviDatePickerSelect]. Trigger only: the
/// options list is composed outside (seed `triggerOnly`).
///
/// Paint (mode app-cliente):
/// - root: height `spacing/500` (40, grows with the text scaler), padding
///   horizontal `spacing/200`, vertical `spacing/100` (frame 10, not
///   tokenized), gap `spacing/050`, radius `border/radius/100`; no fill, no
///   stroke at rest.
/// - value `body/medium/regular` `text/primary`; trailing icon 20
///   (`spacing/250`) `text/secondary`; `chevron-down-outline`, or
///   `chevron-up-outline` when [expanded].
/// - expanded / keyboard focus → stroke `interactive/focus`
///   `border/width/012` (inside).
/// - pressed → fill `interactive/pressed` (seed `hover` = `interactive/hover`
///   does not exist on the app).
/// - disabled → value and icon `text/placeholder`, no stroke.
///
/// Touch target: the 40 paint sits centered in a 48 dp hit area.
///
/// Semantics: button, `expanded` mirrors [expanded], name = unit + value
/// (e.g. "Dia 21").
class LooviDatePickerSelectItem extends StatefulWidget {
  const LooviDatePickerSelectItem({
    super.key,
    this.unit = LooviDatePickerSelectItemUnit.day,
    this.value = '21',
    this.expanded = false,
    this.enabled = true,
    this.onTap,
    this.unitLabel,
    this.focusNode,
    this.autofocus = false,
  });

  /// Seed `unit`.
  final LooviDatePickerSelectItemUnit unit;

  /// Seed `value` (TEXT) — visible selected unit value.
  final String value;

  /// Seed `expanded`. Disabled never paints expanded (intentional sparse).
  final bool expanded;

  /// `false` = seed `state=disabled`.
  final bool enabled;

  final VoidCallback? onTap;

  /// Accessible unit name. Defaults to Dia / Mês / Ano.
  final String? unitLabel;

  final FocusNode? focusNode;
  final bool autofocus;

  /// Default pt-BR unit name used in semantics.
  static String defaultUnitLabel(LooviDatePickerSelectItemUnit unit) => switch (unit) {
        LooviDatePickerSelectItemUnit.day => 'Dia',
        LooviDatePickerSelectItemUnit.month => 'Mês',
        LooviDatePickerSelectItemUnit.year => 'Ano',
      };

  @override
  State<LooviDatePickerSelectItem> createState() => _LooviDatePickerSelectItemState();
}

class _LooviDatePickerSelectItemState extends State<LooviDatePickerSelectItem> {
  bool _pressed = false;
  bool _focus = false;

  bool get _enabled => widget.enabled && widget.onTap != null;

  void _setPressed(bool v) {
    if (_enabled && _pressed != v) setState(() => _pressed = v);
  }

  @override
  void didUpdateWidget(LooviDatePickerSelectItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_enabled) {
      _pressed = false;
      _focus = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final disabled = !widget.enabled;
    final expanded = widget.expanded && !disabled;
    final stroke = !disabled && (expanded || _focus);
    final contentColor = disabled ? t.text.placeholder : t.text.primary;
    final iconColor = disabled ? t.text.placeholder : t.text.secondary;
    final transparent = t.color.backgroundSurface0.withValues(alpha: 0);

    final paint = DecoratedBox(
      decoration: BoxDecoration(
        color: _pressed ? t.interactive.pressed : null,
        borderRadius: BorderRadius.circular(t.radius.s100),
        border: Border.all(color: stroke ? t.interactive.focus : transparent, width: t.borderWidth.s012),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: t.spacing.s500),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: t.spacing.s200, vertical: t.spacing.s100),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.value, style: t.typography.bodyMediumRegular.copyWith(color: contentColor)),
              SizedBox(width: t.spacing.s050),
              LooviIcon(
                expanded ? LooviIcons.chevronUpOutline : LooviIcons.chevronDownOutline,
                size: t.spacing.s250,
                color: iconColor,
              ),
            ],
          ),
        ),
      ),
    );

    final min = LooviTapTarget.minSize(context);
    final unitLabel = widget.unitLabel ?? LooviDatePickerSelectItem.defaultUnitLabel(widget.unit);

    return Semantics(
      container: true,
      button: true,
      enabled: _enabled,
      expanded: expanded,
      focusable: _enabled,
      focused: _enabled ? _focus : null,
      label: '$unitLabel ${widget.value}',
      onTap: _enabled ? widget.onTap : null,
      excludeSemantics: true,
      child: FocusableActionDetector(
        enabled: _enabled,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onShowFocusHighlight: (v) => setState(() => _focus = v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
            widget.onTap?.call();
            return null;
          }),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          excludeFromSemantics: true,
          onTap: _enabled ? widget.onTap : null,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: min, minHeight: min),
            child: Center(widthFactor: 1, heightFactor: 1, child: paint),
          ),
        ),
      ),
    );
  }
}
