import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_blend.dart';
import '../../foundation/loovi_icon.dart';
import '../../foundation/loovi_tap_target.dart';
import '../../generated/loovi_icon_names.g.dart';

/// Seed `ChipClickable.size`.
enum LooviChipClickableSize { sm, md }

/// Seed `ChipClickable.intent`. Feedback vocabulary + `outline`, `soft`, `brand`.
enum LooviChipClickableIntent { info, system, success, warning, danger, outline, soft, brand }

/// Seed `ChipClickable.emphasis`. Only affects the status intents (info,
/// system, success, warning, danger); `outline`, `soft` and `brand` ignore it.
/// Default is [secondary] (soft) since 2026-11-23; [primary] is opt-in.
enum LooviChipClickableEmphasis { primary, secondary }

/// Seed `ChipClickable.width`.
enum LooviChipClickableWidth { hug, fill }

/// ChipClickable (Figma 3653:23577) — compact interactive chip for filters,
/// compact options, removable selections and low-emphasis actions.
///
/// Seed `state` maps to runtime: `pressed` from touch, `selected` and
/// `disabled` are props; `hover` is not used on the app (mobile).
///
/// Paint (mode app-cliente):
/// - base fill, emphasis=primary: info|system|success|warning →
///   `color/background-feedback-primary/{intent}`; danger → `interactive/error-surface`.
/// - base fill, emphasis=secondary: info|system|success|warning|danger →
///   `color/background-feedback-secondary/{intent}`.
/// - soft → `color/background-surface/0`
///   + `color/border/2` stroke; brand → `color/background-surface/brand-strong`
///   (`text/on-color`, 4.52:1);
///   outline → stroke `color/border/2` only.
/// - pressed / selected: `interactive/pressed|selected` composited over the
///   base with Plus Darker (LINEAR_BURN). Outline replaces its transparent
///   base with the interactive fill.
/// - disabled: `interactive/disabled-surface` + `text/placeholder`, avatar 20 %.
/// - label `body/small/medium`, `text/primary` (`text/on-color` on brand).
/// - leading icon / avatar: sm 20 (`spacing/250`, chip 28 tall) · md icon 24
///   (`spacing/300`), avatar 32 (`spacing/400`).
/// - delete action: `x-outline` painted 16 (`spacing/200`); its hit area
///   grows invisibly to 48 × 48 around the icon (clipped to the chip's 48 dp
///   touch box — ≥ 24 × 24, WCAG 2.5.8) without changing the chip size.
///   Accessible name "Remover {label}".
class LooviChipClickable extends StatefulWidget {
  const LooviChipClickable({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = LooviChipClickableSize.md,
    this.intent = LooviChipClickableIntent.outline,
    this.emphasis = LooviChipClickableEmphasis.secondary,
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

  /// Seed `emphasis`: `secondary` (light feedback fill, default) or
  /// `primary` (saturated feedback fill, opt-in). Status intents only;
  /// pressed/selected keep the Plus Darker overlay over either base.
  final LooviChipClickableEmphasis emphasis;
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
  /// Figma avatar size (sm 20, md 32). Null = hidden.
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

class _LooviChipClickableState extends State<LooviChipClickable> {
  late final WidgetStatesController _states = WidgetStatesController();
  final GlobalKey _deleteKey = GlobalKey(debugLabel: 'LooviChipClickable.delete');
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
    final secondary = widget.emphasis == LooviChipClickableEmphasis.secondary;
    switch (widget.intent) {
      case LooviChipClickableIntent.info:
        return secondary ? t.color.backgroundFeedbackSecondaryInfo : t.color.backgroundFeedbackPrimaryInfo;
      case LooviChipClickableIntent.system:
        return secondary ? t.color.backgroundFeedbackSecondarySystem : t.color.backgroundFeedbackPrimarySystem;
      case LooviChipClickableIntent.success:
        return secondary ? t.color.backgroundFeedbackSecondarySuccess : t.color.backgroundFeedbackPrimarySuccess;
      case LooviChipClickableIntent.warning:
        return secondary ? t.color.backgroundFeedbackSecondaryWarning : t.color.backgroundFeedbackPrimaryWarning;
      case LooviChipClickableIntent.danger:
        return secondary ? t.color.backgroundFeedbackSecondaryDanger : t.interactive.errorSurface;
      case LooviChipClickableIntent.soft:
        return t.color.backgroundSurface0;
      case LooviChipClickableIntent.brand:
        return t.color.backgroundSurfaceBrandStrong;
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
    return looviPlusDarker(base, overlay);
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

    // Avatar: sm 20 (spacing/250), md 32 (spacing/400).
    final avatarSize = _isSm ? t.spacing.s250 : t.spacing.s400;
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
                key: _deleteKey,
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
          // The delete action's hit area grows to min × min inside this box.
          child: _DeleteHitArea(
            deleteKey: deleteAction != null && widget.onDelete != null ? _deleteKey : null,
            minTarget: min,
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
      ),
    );
  }
}

/// Routes taps inside a [minTarget] × [minTarget] square centered on the
/// delete icon (identified by [deleteKey]) to the delete action, without
/// changing layout: the icon keeps its 16 px paint and the chip its size. The
/// square is clipped to this box (the chip's 48 dp touch area), so the delete
/// target is ≥ 24 × 24 on every size (sm ≈ 44 × 48, md 48 × 48).
class _DeleteHitArea extends SingleChildRenderObjectWidget {
  const _DeleteHitArea({required this.deleteKey, required this.minTarget, required super.child});

  final GlobalKey? deleteKey;
  final double minTarget;

  @override
  _RenderDeleteHitArea createRenderObject(BuildContext context) =>
      _RenderDeleteHitArea(deleteKey: deleteKey, minTarget: minTarget);

  @override
  void updateRenderObject(BuildContext context, _RenderDeleteHitArea renderObject) {
    renderObject
      ..deleteKey = deleteKey
      ..minTarget = minTarget;
  }
}

class _RenderDeleteHitArea extends RenderProxyBox {
  _RenderDeleteHitArea({required this.deleteKey, required this.minTarget});

  GlobalKey? deleteKey;
  double minTarget;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (!size.contains(position)) return false;
    final target = deleteKey?.currentContext?.findRenderObject();
    if (target is RenderBox && target.attached && target.hasSize) {
      final rect = MatrixUtils.transformRect(target.getTransformTo(this), Offset.zero & target.size);
      final area = Rect.fromCenter(
        center: rect.center,
        width: math.max(rect.width, minTarget),
        height: math.max(rect.height, minTarget),
      );
      if (area.contains(position)) {
        // Deliver the hit at the icon center so the delete GestureDetector
        // receives it; ancestors of this box are still added by their own
        // hitTest, as for a direct tap on the icon.
        final hit = result.addWithPaintTransform(
          transform: target.getTransformTo(this),
          position: rect.center,
          hitTest: (BoxHitTestResult r, Offset local) => target.hitTest(r, position: target.size.center(Offset.zero)),
        );
        if (hit) {
          result.add(BoxHitTestEntry(this, position));
          return true;
        }
      }
    }
    return super.hitTest(result, position: position);
  }
}
