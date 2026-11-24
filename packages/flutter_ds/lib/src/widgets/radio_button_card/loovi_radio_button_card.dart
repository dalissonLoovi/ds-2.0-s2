import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_tap_target.dart';
import '../radio_button/loovi_radio_button.dart';

/// RadioButtonCard S2 (Figma `4498:68`, mode app-cliente) — full-width card
/// row for a mutually exclusive choice: radio + label + optional description.
/// The whole card is the hit target (always ≥ 48 dp tall).
///
/// Seed `checked` = `value == groupValue`. Seed `state` is runtime: `focus`
/// = keyboard focus-visible (shell stroke), `disabled` = [disabled] or
/// `onChanged == null`. `state=hover` is not used on the app (mobile).
///
/// Paint (mode app-cliente):
/// - shell: unchecked `color/background-surface/0` + `color/border/1` ·
///   checked `color/background-surface/1` + `color/border-feedback/primary` ·
///   focus stroke `interactive/focus` · disabled stroke `color/border/2`
///   (fill follows checked). Stroke `border/width/012`, radius
///   `border/radius/400`, padding `spacing/200`, gap `spacing/100`.
/// - radioControl: [LooviRadioButtonControl] (20, top-aligned) — checked is
///   the thick ring only, never a center dot (seed RadioButton rule
///   `checkedIndicator`), disabled on/off distinct as in RadioButton.
/// - labelContent gap `spacing/050`; label `body/medium/medium`
///   `text/primary`; description `body/small/regular` `text/secondary`;
///   both `text/placeholder` when disabled.
///
/// Group related cards under a container with an accessible group name.
class LooviRadioButtonCard<T> extends StatefulWidget {
  const LooviRadioButtonCard({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
    this.description,
    this.showDescription = true,
    this.disabled = false,
    this.focusNode,
    this.autofocus = false,
    this.forceFocusRing = false,
  });

  /// Value this option represents.
  final T value;

  /// Currently selected value of the group. Seed `checked=true` when equal.
  final T? groupValue;

  /// Called with [value] when an unselected card is activated. Null = disabled.
  final ValueChanged<T>? onChanged;

  /// Seed `label`.
  final String label;

  /// Seed `description`.
  final String? description;

  /// Seed `showDescription`.
  final bool showDescription;

  /// Seed `state=disabled`.
  final bool disabled;

  final FocusNode? focusNode;
  final bool autofocus;

  /// Paints the focus stroke regardless of real focus (seed `state=focus`).
  /// For the catalog and goldens only.
  final bool forceFocusRing;

  bool get checked => value == groupValue;

  @override
  State<LooviRadioButtonCard<T>> createState() => _LooviRadioButtonCardState<T>();
}

class _LooviRadioButtonCardState<T> extends State<LooviRadioButtonCard<T>> {
  bool _focusVisible = false;

  bool get _enabled => !widget.disabled && widget.onChanged != null;

  void _select() {
    if (!_enabled || widget.checked) return;
    widget.onChanged!(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final enabled = _enabled;
    final checked = widget.checked;
    final focused = enabled && (widget.forceFocusRing || _focusVisible);
    final hasDescription = widget.showDescription && (widget.description?.isNotEmpty ?? false);

    final Color stroke;
    if (!enabled) {
      stroke = t.color.border2;
    } else if (focused) {
      stroke = t.interactive.focus;
    } else {
      stroke = checked ? t.color.borderFeedbackPrimary : t.color.border1;
    }
    final fill = checked ? t.color.backgroundSurface1 : t.color.backgroundSurface0;

    final card = Container(
      constraints: BoxConstraints(minHeight: LooviTapTarget.minSize(context)),
      padding: EdgeInsets.all(t.spacing.s200),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(t.radius.s400),
        border: Border.all(color: stroke, width: t.borderWidth.s012),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LooviRadioButtonControl(checked: checked, disabled: !enabled, focused: focused, paintFocusRing: false),
          SizedBox(width: t.spacing.s100),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: t.typography.bodyMediumMedium.copyWith(color: enabled ? t.text.primary : t.text.placeholder),
                ),
                if (hasDescription) ...[
                  SizedBox(height: t.spacing.s050),
                  Text(
                    widget.description!,
                    style: t.typography.bodySmallRegular.copyWith(color: enabled ? t.text.secondary : t.text.placeholder),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    return Semantics(
      container: true,
      enabled: enabled,
      checked: checked,
      inMutuallyExclusiveGroup: true,
      label: widget.label,
      hint: hasDescription ? widget.description : null,
      onTap: enabled && !checked ? _select : null,
      child: ExcludeSemantics(
        child: FocusableActionDetector(
          enabled: enabled,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          mouseCursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
          onShowFocusHighlight: (v) => setState(() => _focusVisible = v),
          actions: {ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) => _select())},
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: enabled ? _select : null,
            child: card,
          ),
        ),
      ),
    );
  }
}
