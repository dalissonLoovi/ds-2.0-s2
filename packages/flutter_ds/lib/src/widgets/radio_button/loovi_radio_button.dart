import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_tap_target.dart';
import '../checkbox/loovi_checkbox.dart' show LooviFocusRingPainter;

/// RadioButton S2 (Figma `3653:5279`, mode app-cliente).
///
/// Seed `checked` = `value == groupValue`. Seed `state` is runtime:
/// `focus` = keyboard focus-visible (ring), `disabled` = [disabled] or
/// `onChanged == null`. `state=hover` is not used on the app (mobile).
///
/// The control paints at the Figma size (20 × 20); the touch target grows to
/// 48 dp around it. The label/description row is part of the target.
/// Group related options under a container with an accessible group name.
class LooviRadioButton<T> extends StatefulWidget {
  const LooviRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
    this.description,
    this.showLabel = true,
    this.showDescription = true,
    this.showContent = true,
    this.disabled = false,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
    this.forceFocusRing = false,
  });

  /// Value this option represents.
  final T value;

  /// Currently selected value of the group. Seed `checked=true` when equal.
  final T? groupValue;

  /// Called with [value] when an unselected option is activated. Null = disabled.
  final ValueChanged<T>? onChanged;

  /// Seed `label`.
  final String? label;

  /// Seed `description`.
  final String? description;

  /// Seed `showLabel`.
  final bool showLabel;

  /// Seed `showDescription`.
  final bool showDescription;

  /// Seed `showContent` — hides labelContent (control only).
  final bool showContent;

  /// Seed `state=disabled`.
  final bool disabled;

  /// Accessible name when no visible label.
  final String? semanticLabel;

  final FocusNode? focusNode;
  final bool autofocus;

  /// Paints the focus ring regardless of real focus (seed `state=focus`).
  /// For the catalog and goldens only.
  final bool forceFocusRing;

  bool get checked => value == groupValue;

  @override
  State<LooviRadioButton<T>> createState() => _LooviRadioButtonState<T>();
}

class _LooviRadioButtonState<T> extends State<LooviRadioButton<T>> {
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
    final hasLabel = widget.showContent && widget.showLabel && (widget.label?.isNotEmpty ?? false);
    final hasDescription = widget.showContent && widget.showDescription && (widget.description?.isNotEmpty ?? false);
    final hasContent = hasLabel || hasDescription;

    final control = LooviRadioButtonControl(
      checked: widget.checked,
      disabled: !enabled,
      focused: widget.forceFocusRing || (_focusVisible && enabled),
    );

    Widget painted = control;
    if (hasContent) {
      final textColor = enabled ? null : t.text.placeholder;
      painted = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          control,
          SizedBox(width: t.spacing.s200),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasLabel)
                  Text(widget.label!, style: t.typography.bodyMediumMedium.copyWith(color: textColor ?? t.text.primary)),
                if (hasLabel && hasDescription) SizedBox(height: t.spacing.s050),
                if (hasDescription)
                  Text(widget.description!, style: t.typography.bodySmallRegular.copyWith(color: textColor ?? t.text.secondary)),
              ],
            ),
          ),
        ],
      );
    }

    final min = LooviTapTarget.minSize(context); // 48 dp touch target
    return Semantics(
      container: true,
      enabled: enabled,
      checked: widget.checked,
      inMutuallyExclusiveGroup: true,
      label: hasLabel ? widget.label : widget.semanticLabel,
      hint: hasDescription ? widget.description : null,
      onTap: enabled && !widget.checked ? _select : null,
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
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: min, minHeight: min),
              child: Align(
                alignment: hasContent ? AlignmentDirectional.centerStart : Alignment.center,
                widthFactor: 1,
                heightFactor: 1,
                child: painted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Paint-only radioControl (20 × 20) — no gestures, no semantics.
/// Reusable as a nested control (e.g. ListItem).
class LooviRadioButtonControl extends StatelessWidget {
  const LooviRadioButtonControl({super.key, required this.checked, this.disabled = false, this.focused = false});

  final bool checked;
  final bool disabled;
  final bool focused;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);

    // Figma radioControl per variant (3653:5279):
    //   default/off  fill surface/0 · stroke 2 border/1
    //   default/on   no fill        · stroke 4 actions/primary
    //   focus/off    fill surface/0 · stroke 2 border/2  (+ ring)
    //   focus/on     no fill        · stroke 4 actions/primary (+ ring)
    //   disabled/on  no fill        · stroke 4 text/placeholder
    //   disabled/off no fill        · stroke 2 border/2  (seed rule `disabled`:
    //                                 on and off must be visually distinct)
    // Checked = thick ring only, never a center dot — in every state,
    // disabled included (seed rule `checkedIndicator`).
    final Color? fill;
    final Color stroke;
    final double width;
    if (disabled) {
      fill = null;
      stroke = checked ? t.text.placeholder : t.color.border2;
      width = checked ? t.borderWidth.s050 : t.borderWidth.s025;
    } else if (checked) {
      fill = null;
      stroke = t.color.actionsPrimary;
      width = t.borderWidth.s050;
    } else {
      fill = t.color.backgroundSurface0;
      stroke = focused ? t.color.border2 : t.color.border1;
      width = t.borderWidth.s025;
    }

    final size = t.spacing.s250;
    return CustomPaint(
      foregroundPainter: focused
          ? LooviFocusRingPainter(
              color: t.interactive.focus,
              gap: t.spacing.s025,
              strokeWidth: t.borderWidth.s025,
              radius: t.radius.full,
            )
          : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: fill,
          shape: BoxShape.circle,
          border: Border.all(color: stroke, width: width),
        ),
      ),
    );
  }
}
