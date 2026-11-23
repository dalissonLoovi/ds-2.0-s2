import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../foundation/loovi_tap_target.dart';
import '../../generated/loovi_icon_names.g.dart';

/// Seed `ChipClickable.size`.
enum LooviChipClickableSize { sm, md }

/// Seed `ChipClickable.intent`. Feedback vocabulary + `outline`, `soft`, `brand`.
enum LooviChipClickableIntent { info, system, success, warning, danger, outline, soft, brand }

/// Seed `ChipClickable.width`.
enum LooviChipClickableWidth { hug, fill }

/// ChipClickable (Figma 3653:23577) — compact interactive chip for filters,
/// compact options, removable selections and low-emphasis actions.
///
/// Seed `state` maps to runtime: `pressed` from touch, `selected` and
/// `disabled` are props; `hover` is not used on the app (mobile).
///
/// Paint (mode app-cliente):
/// - base fill: info|system|success|warning → `color/background-feedback-primary/{intent}`;
///   danger → `interactive/error-surface`; soft → `color/background-surface/0`
///   + `color/border/2` stroke; brand → `color/background-surface/brand`;
///   outline → stroke `color/border/2` only.
/// - pressed / selected: `interactive/pressed|selected` composited over the
///   base with Plus Darker (LINEAR_BURN). Outline replaces its transparent
///   base with the interactive fill.
/// - disabled: `interactive/disabled-surface` + `text/placeholder`, avatar 20 %.
/// - label `body/small/medium`, `text/primary` (`text/on-color` on brand).
class LooviChipClickable extends StatefulWidget {
  const LooviChipClickable({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = LooviChipClickableSize.md,
    this.intent = LooviChipClickableIntent.outline,
    this.width = LooviChipClickableWidth.hug,
    this.selected = false,
    this.disabled = false,
    this.showLeadingIcon = false,
    this.leadingIcon = LooviIcons.plusOutline,
    this.avatar,
    this.showDeleteAction = false,
    this.onDelete,
    this.deleteSemanticLabel,
    this.focusNode,
    this.autofocus = false,
  });

  /// Visible label (seed `label`, TEXT prop).
  final String label;

  /// Tap callback. Null = disabled (same as [disabled] = true).
  final VoidCallback? onPressed;

  final LooviChipClickableSize size;
  final LooviChipClickableIntent intent;
  final LooviChipClickableWidth width;

  /// Seed `state=selected`. Exposed as a selected toggle in semantics.
  final bool selected;

  /// Seed `state=disabled`.
  final bool disabled;

  /// Seed `showLeadingIcon`.
  final bool showLeadingIcon;

  /// Seed `leadingIcon` (INSTANCE_SWAP): sm 20×20, md 24×24.
  final String leadingIcon;

  /// Seed `showAvatar` slot: any image widget, clipped to a circle at the
  /// Figma avatar size (sm 22, md 32). Null = hidden.
  final Widget? avatar;

  /// Seed `showDeleteAction` (x-outline, 16×16).
  final bool showDeleteAction;

  /// Called by the delete action. Without it the delete icon is decorative.
  final VoidCallback? onDelete;

  /// Accessible name of the delete action. Defaults to `Remover {label}`.
  final String? deleteSemanticLabel;

  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<LooviChipClickable> createState() => _LooviChipClickableState();
}

/// Plus Darker / LINEAR_BURN of two opaque colors: `dst + src - 1` per channel.
/// Flutter has no LINEAR_BURN BlendMode; with opaque token colors the result
/// is exact, so it is resolved here instead of via a compositing layer.
Color _plusDarker(Color dst, Color src) => Color.from(
      alpha: dst.a,
      red: (dst.r + src.r - 1).clamp(0, 1).toDouble(),
      green: (dst.g + src.g - 1).clamp(0, 1).toDouble(),
      blue: (dst.b + src.b - 1).clamp(0, 1).toDouble(),
    );

class _LooviChipClickableState extends State<LooviChipClickable> {
  late final WidgetStatesController _states = WidgetStatesController();
  bool _focusHighlight = false;

  bool get _enabled => widget.onPressed != null && !widget.disabled;
  bool get _isSm => widget.size == LooviChipClickableSize.sm;

  @override
  void initState() {
    super.initState();
    _states.addListener(_onStates);
    _syncStates();
  }

  @override
  void didUpdateWidget(LooviChipClickable oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncStates();
  }

  void _syncStates() {
    _states.update(WidgetState.disabled, !_enabled);
    _states.update(WidgetState.selected, widget.selected);
    if (!_enabled) _states.update(WidgetState.pressed, false);
  }

  void _onStates() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _states.removeListener(_onStates);
    _states.dispose();
    super.dispose();
  }

  void _setPressed(bool v) {
    if (_enabled) _states.update(WidgetState.pressed, v);
  }

  Color? _base(LooviTokens t) {
    switch (widget.intent) {
      case LooviChipClickableIntent.info:
        return t.color.backgroundFeedbackPrimaryInfo;
      case LooviChipClickableIntent.system:
        return t.color.backgroundFeedbackPrimarySystem;
      case LooviChipClickableIntent.success:
        return t.color.backgroundFeedbackPrimarySuccess;
      case LooviChipClickableIntent.warning:
        return t.color.backgroundFeedbackPrimaryWarning;
      case LooviChipClickableIntent.danger:
        return t.interactive.errorSurface;
      case LooviChipClickableIntent.soft:
        return t.color.backgroundSurface0;
      case LooviChipClickableIntent.brand:
        return t.color.backgroundSurfaceBrand;
      case LooviChipClickableIntent.outline:
        return null;
    }
  }

  Color? _fill(LooviTokens t, Set<WidgetState> s) {
    if (s.contains(WidgetState.disabled)) return t.interactive.disabledSurface;
    final base = _base(t);
    final Color? overlay = s.contains(WidgetState.pressed)
        ? t.interactive.pressed
        : s.contains(WidgetState.selected)
            ? t.interactive.selected
            : null;
    if (overlay == null) return base;
    if (base == null) return overlay; // outline: interaction fill replaces transparent
    return _plusDarker(base, overlay);
  }

  Color _content(LooviTokens t, Set<WidgetState> s) {
    if (s.contains(WidgetState.disabled)) return t.text.placeholder;
    if (widget.intent == LooviChipClickableIntent.brand) return t.text.onColor;
    return t.text.primary;
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final s = _states.value;
    final disabled = s.contains(WidgetState.disabled);
    final content = _content(t, s);
    final fill = widget.width == LooviChipClickableWidth.fill;
    final stroked = !disabled &&
        (widget.intent == LooviChipClickableIntent.outline || widget.intent == LooviChipClickableIntent.soft);

    // content frame: pl spacing/100; md fixed 32 (spacing/400) tall.
    Widget contentFrame = Padding(
      padding: EdgeInsets.only(left: t.spacing.s100),
      // The label is announced by the chip's own Semantics node.
      child: ExcludeSemantics(
        child: Text(
          widget.label,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: t.typography.bodySmallMedium.copyWith(color: content),
        ),
      ),
    );
    if (!_isSm) {
      contentFrame = ConstrainedBox(
        constraints: BoxConstraints(minHeight: t.spacing.s400),
        child: Align(widthFactor: 1, heightFactor: 1, alignment: Alignment.centerLeft, child: contentFrame),
      );
    }

    // Avatar: sm 22 (no token — spacing/250 + spacing/025), md 32 (spacing/400).
    final avatarSize = _isSm ? t.spacing.s250 + t.spacing.s025 : t.spacing.s400;
    final chipRoot = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showLeadingIcon)
          LooviIcon(widget.leadingIcon, size: _isSm ? t.spacing.s250 : t.spacing.s300, color: content),
        if (widget.avatar != null)
          Opacity(
            opacity: disabled ? 0.2 : 1,
            child: ClipOval(
              child: SizedBox.square(dimension: avatarSize, child: FittedBox(fit: BoxFit.cover, child: widget.avatar)),
            ),
          ),
        Flexible(child: contentFrame),
      ],
    );

    Widget? deleteAction;
    if (widget.showDeleteAction) {
      final icon = LooviIcon(LooviIcons.xOutline, size: t.spacing.s200, color: content);
      deleteAction = widget.onDelete == null
          ? icon
          : Semantics(
              button: true,
              enabled: _enabled,
              label: widget.deleteSemanticLabel ?? 'Remover ${widget.label}',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _enabled ? widget.onDelete : null,
                child: icon,
              ),
            );
    }

    final row = Row(
      mainAxisSize: fill ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: chipRoot),
        if (deleteAction != null) ...[SizedBox(width: t.spacing.s100), deleteAction],
      ],
    );

    final radius = BorderRadius.circular(t.radius.full);
    final paint = DecoratedBox(
      decoration: BoxDecoration(
        color: _fill(t, s),
        borderRadius: radius,
        border: stroked ? Border.all(color: t.color.border2, width: t.borderWidth.s012) : null,
      ),
      position: DecorationPosition.background,
      child: Padding(
        // pl spacing/050 · pr sm spacing/150 | md spacing/200 · py spacing/050
        padding: EdgeInsets.fromLTRB(
          t.spacing.s050,
          t.spacing.s050,
          _isSm ? t.spacing.s150 : t.spacing.s200,
          t.spacing.s050,
        ),
        child: row,
      ),
    );

    // Keyboard focus ring (not drawn in Figma): interactive/focus, border/width/025.
    final painted = _focusHighlight
        ? DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: t.interactive.focus, width: t.borderWidth.s025),
            ),
            child: paint,
          )
        : paint;

    final min = LooviTapTarget.minSize(context);
    return Semantics(
      container: true,
      button: true,
      enabled: _enabled,
      selected: widget.selected,
      label: widget.label,
      onTap: _enabled ? widget.onPressed : null,
      child: FocusableActionDetector(
        enabled: _enabled,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onShowFocusHighlight: (v) => setState(() => _focusHighlight = v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
            widget.onPressed?.call();
            return null;
          }),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _enabled ? widget.onPressed : null,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          // Touch target >= 48 (spacing/600); paint keeps the Figma size.
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: min, minHeight: min),
            child: Center(
              widthFactor: 1,
              heightFactor: 1,
              child: painted,
            ),
          ),
        ),
      ),
    );
  }
}
