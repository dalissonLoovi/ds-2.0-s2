import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../generated/loovi_icon_names.g.dart';
import '../checkbox/loovi_checkbox.dart' show LooviFocusRingPainter;

/// Seed `size` axis of Switch.
enum LooviSwitchSize {
  /// Track 56 × 32, thumb 24. Standard layouts; may show the thumb icon.
  md,

  /// Track 40 × 20, thumb 16. Compact layouts; no icon layer.
  sm,
}

/// Switch S2 (Figma set `3653:4741` on page Switch `3444:295`, mode app-cliente).
///
/// Seed `state` is runtime: `focus` = keyboard focus-visible (ring),
/// `disabled` = [disabled] or `onChanged == null`. No hover.
///
/// The seed has no visible label: the accessible name comes from the
/// surrounding form field or [semanticLabel]. The track paints at the Figma
/// size; the touch target grows to 48 dp around it.
class LooviSwitch extends StatefulWidget {
  const LooviSwitch({
    super.key,
    required this.checked,
    required this.onChanged,
    this.size = LooviSwitchSize.md,
    this.showIcon = false,
    this.disabled = false,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
    this.forceFocusRing = false,
  });

  /// Seed `checked` (on/off).
  final bool checked;

  /// Called with `!checked`. Null = disabled.
  final ValueChanged<bool>? onChanged;

  /// Seed `size`.
  final LooviSwitchSize size;

  /// Seed `showIcon` — x-outline (off) / check-outline (on) in the thumb.
  /// Applies to [LooviSwitchSize.md] only.
  final bool showIcon;

  /// Seed `state=disabled`.
  final bool disabled;

  /// Accessible name (aria-label equivalent).
  final String? semanticLabel;

  final FocusNode? focusNode;
  final bool autofocus;

  /// Paints the focus ring regardless of real focus (seed `state=focus`).
  /// For the catalog and goldens only.
  final bool forceFocusRing;

  @override
  State<LooviSwitch> createState() => _LooviSwitchState();
}

class _LooviSwitchState extends State<LooviSwitch> {
  bool _focusVisible = false;

  bool get _enabled => !widget.disabled && widget.onChanged != null;

  void _toggle() {
    if (!_enabled) return;
    widget.onChanged!(!widget.checked);
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final enabled = _enabled;
    final min = t.spacing.s600; // 48 dp touch target
    return Semantics(
      container: true,
      enabled: enabled,
      toggled: widget.checked,
      label: widget.semanticLabel,
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
              child: Center(
                widthFactor: 1,
                heightFactor: 1,
                child: LooviSwitchControl(
                  checked: widget.checked,
                  size: widget.size,
                  showIcon: widget.showIcon,
                  disabled: !enabled,
                  focused: widget.forceFocusRing || (_focusVisible && enabled),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Paint-only switch (track + thumb + optional icon + focus ring).
/// Reusable as a nested control (e.g. ListItem trailing=switch).
class LooviSwitchControl extends StatelessWidget {
  const LooviSwitchControl({
    super.key,
    required this.checked,
    this.size = LooviSwitchSize.md,
    this.showIcon = false,
    this.disabled = false,
    this.focused = false,
  });

  final bool checked;
  final LooviSwitchSize size;
  final bool showIcon;
  final bool disabled;
  final bool focused;

  static const Duration _duration = Duration(milliseconds: 150);

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final md = size == LooviSwitchSize.md;

    // Geometry (Figma 3653:4741): md 56×32 / thumb 24 / inset 4;
    // sm 40×20 / thumb 16 / inset 2.
    final trackW = md ? t.spacing.s700 : t.spacing.s500;
    final trackH = md ? t.spacing.s400 : t.spacing.s250;
    final thumb = md ? t.spacing.s300 : t.spacing.s200;
    final inset = md ? t.spacing.s050 : t.spacing.s025;

    final trackColor = disabled
        ? t.interactive.disabledSurface
        : checked
            ? t.color.actionsPrimary
            : t.color.backgroundSurface3;
    final thumbColor = disabled ? t.color.backgroundSurface1 : t.color.backgroundSurface0;

    // Thumb shadow only when off: x 2, y 0, blur md 2 / sm 4, black 4 %.
    // Not tokenized in Figma → color/elevation/7 (same 4 % alpha).
    final shadow = checked
        ? const <BoxShadow>[]
        : [
            BoxShadow(
              color: t.color.elevation7,
              offset: Offset(t.spacing.s025, 0),
              blurRadius: md ? t.spacing.s025 : t.spacing.s050,
            ),
          ];

    Widget? icon;
    if (md && showIcon) {
      final Color c;
      if (checked) {
        c = disabled ? t.text.placeholder : t.color.actionsPrimary;
      } else {
        c = disabled ? t.text.placeholder : t.text.secondary;
      }
      icon = LooviIcon(checked ? LooviIcons.checkOutline : LooviIcons.xOutline, size: t.spacing.s150, color: c);
    }

    return CustomPaint(
      foregroundPainter: focused
          ? LooviFocusRingPainter(
              color: t.interactive.focus,
              gap: t.spacing.s025,
              strokeWidth: t.borderWidth.s025,
              radius: t.radius.full,
            )
          : null,
      child: SizedBox(
        width: trackW,
        height: trackH,
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedContainer(
                duration: _duration,
                decoration: BoxDecoration(color: trackColor, borderRadius: BorderRadius.circular(t.radius.full)),
              ),
            ),
            AnimatedPositioned(
              duration: _duration,
              curve: Curves.easeOut,
              top: inset,
              left: checked ? trackW - thumb - inset : inset,
              width: thumb,
              height: thumb,
              child: AnimatedContainer(
                duration: _duration,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: thumbColor, shape: BoxShape.circle, boxShadow: shadow),
                child: icon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
