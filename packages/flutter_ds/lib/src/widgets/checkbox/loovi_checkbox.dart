import 'dart:math' as math;

import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../foundation/loovi_tap_target.dart';
import '../../generated/loovi_icon_names.g.dart';

/// Seed `checked` axis of Checkbox (`false | true | mixed`).
enum LooviCheckboxChecked {
  /// Seed `checked=false`.
  unchecked('false'),

  /// Seed `checked=true` — icon `check-outline`.
  checked('true'),

  /// Seed `checked=mixed` (indeterminate / partial selection) — icon `minus-outline`.
  mixed('mixed');

  const LooviCheckboxChecked(this.seedValue);

  /// Value as written in the seed / Figma variant.
  final String seedValue;

  /// Next value on activation: unchecked → checked, checked → unchecked,
  /// mixed → checked (same as a native indeterminate checkbox).
  LooviCheckboxChecked get toggled => this == LooviCheckboxChecked.checked ? LooviCheckboxChecked.unchecked : LooviCheckboxChecked.checked;
}

/// Checkbox S2 (Figma `3667:3812`, mode app-cliente).
///
/// Seed `state` is runtime: `focus` = keyboard focus-visible (focus ring),
/// `disabled` = [disabled] or `onChanged == null`. No hover on the app; the
/// Figma set publishes no pressed state.
///
/// The control paints at the Figma size (20 × 20); the touch target grows to
/// 48 dp around it. The label/description row is part of the target.
class LooviCheckbox extends StatefulWidget {
  const LooviCheckbox({
    super.key,
    required this.checked,
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

  /// Seed `checked`.
  final LooviCheckboxChecked checked;

  /// Called with [LooviCheckboxChecked.toggled]. Null = disabled.
  final ValueChanged<LooviCheckboxChecked>? onChanged;

  /// Seed `label` — primary option text.
  final String? label;

  /// Seed `description` — optional supporting text.
  final String? description;

  /// Seed `showLabel`.
  final bool showLabel;

  /// Seed `showDescription`.
  final bool showDescription;

  /// Seed `showContent` — hides the whole labelContent (control only).
  final bool showContent;

  /// Seed `state=disabled`.
  final bool disabled;

  /// Accessible name when no visible label (control only). Required by the
  /// seed accessibility rule for unlabeled checkboxes.
  final String? semanticLabel;

  final FocusNode? focusNode;
  final bool autofocus;

  /// Paints the focus ring regardless of real focus (seed `state=focus`).
  /// For the catalog and goldens only; at runtime focus comes from keyboard.
  final bool forceFocusRing;

  @override
  State<LooviCheckbox> createState() => _LooviCheckboxState();
}

class _LooviCheckboxState extends State<LooviCheckbox> {
  bool _focusVisible = false;

  bool get _enabled => !widget.disabled && widget.onChanged != null;

  void _toggle() {
    if (!_enabled) return;
    widget.onChanged!(widget.checked.toggled);
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final enabled = _enabled;
    final hasLabel = widget.showContent && widget.showLabel && (widget.label?.isNotEmpty ?? false);
    final hasDescription = widget.showContent && widget.showDescription && (widget.description?.isNotEmpty ?? false);
    final hasContent = hasLabel || hasDescription;

    final control = LooviCheckboxControl(
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
          SizedBox(width: t.spacing.s100),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasLabel)
                  Text(widget.label!, style: t.typography.bodyMediumMedium.copyWith(color: textColor ?? t.text.primary)),
                if (hasLabel && hasDescription) SizedBox(height: t.spacing.s050),
                if (hasDescription)
                  Text(widget.description!, style: t.typography.bodyMediumRegular.copyWith(color: textColor ?? t.text.secondary)),
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
      checked: widget.checked == LooviCheckboxChecked.checked,
      mixed: widget.checked == LooviCheckboxChecked.mixed,
      label: hasLabel ? widget.label : widget.semanticLabel,
      hint: hasDescription ? widget.description : null,
      onTap: enabled ? _toggle : null,
      child: ExcludeSemantics(
        child: FocusableActionDetector(
          enabled: enabled,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          mouseCursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
          onShowFocusHighlight: (v) => setState(() => _focusVisible = v),
          actions: {ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) => _toggle())},
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: enabled ? _toggle : null,
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

/// Paint-only checkboxControl (20 × 20) — no gestures, no semantics.
/// Used by [LooviCheckbox]; reusable as a nested control (e.g. ListItem).
class LooviCheckboxControl extends StatelessWidget {
  const LooviCheckboxControl({super.key, required this.checked, this.disabled = false, this.focused = false});

  final LooviCheckboxChecked checked;
  final bool disabled;
  final bool focused;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final on = checked != LooviCheckboxChecked.unchecked;

    final Color fill;
    final Color stroke;
    if (disabled) {
      fill = t.color.backgroundSurface1;
      stroke = t.color.border2;
    } else if (on) {
      fill = t.color.actionsPrimary;
      stroke = t.color.borderFeedbackPrimary;
    } else {
      fill = t.color.backgroundSurface0;
      stroke = t.color.border1;
    }
    final iconColor = disabled ? t.text.primary : t.text.onColor;

    final size = t.spacing.s250; // frame 20, not tokenized
    return CustomPaint(
      foregroundPainter: focused
          ? LooviFocusRingPainter(
              color: t.interactive.focus,
              gap: t.spacing.s025,
              strokeWidth: t.borderWidth.s012,
              radius: t.radius.s200,
            )
          : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: fill,
          border: Border.all(color: stroke, width: t.borderWidth.s012),
          borderRadius: BorderRadius.circular(t.radius.s100),
        ),
        alignment: Alignment.center,
        child: on
            ? LooviIcon(
                checked == LooviCheckboxChecked.mixed ? LooviIcons.minusOutline : LooviIcons.checkOutline,
                size: t.spacing.s200,
                color: iconColor,
              )
            : null,
      ),
    );
  }
}

/// Focus ring drawn outside the child bounds, like the Figma `focusRing`
/// layer: rect = child inflated by [gap], stroke aligned OUTSIDE.
class LooviFocusRingPainter extends CustomPainter {
  const LooviFocusRingPainter({required this.color, required this.gap, required this.strokeWidth, required this.radius});

  final Color color;
  final double gap;
  final double strokeWidth;

  /// Corner radius of the ring rect (before the outside stroke).
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final half = strokeWidth / 2;
    final rect = (Offset.zero & size).inflate(gap + half);
    final r = Radius.circular(math.min(radius + half, rect.shortestSide / 2));
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, r),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(LooviFocusRingPainter old) =>
      old.color != color || old.gap != gap || old.strokeWidth != strokeWidth || old.radius != radius;
}
