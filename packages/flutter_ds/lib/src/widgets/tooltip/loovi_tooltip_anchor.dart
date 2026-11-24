import 'package:flutter/services.dart';
import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

/// Seed `Tooltip.placement` / `TooltipRich.placement`.
///
/// As drawn in Figma the value names the edge and alignment of the ARROW:
/// `top*` has the arrow on the top edge (constraint vertical=MIN), so the
/// bubble opens BELOW the trigger; `bottom*` has it on the bottom edge and
/// opens ABOVE. `left` / `right` put the arrow `spacing/200` from that edge,
/// `center` centers it. The tip always points at the trigger's center.
enum LooviTooltipPlacement { topCenter, topLeft, topRight, bottomCenter, bottomLeft, bottomRight }

extension LooviTooltipPlacementGeometry on LooviTooltipPlacement {
  /// Arrow on the top edge (bubble below the trigger).
  bool get arrowOnTop => index <= LooviTooltipPlacement.topRight.index;

  /// -1 = left, 0 = center, 1 = right.
  int get arrowAlign => switch (this) {
        LooviTooltipPlacement.topLeft || LooviTooltipPlacement.bottomLeft => -1,
        LooviTooltipPlacement.topCenter || LooviTooltipPlacement.bottomCenter => 0,
        LooviTooltipPlacement.topRight || LooviTooltipPlacement.bottomRight => 1,
      };
}

/// Shared tooltip surface (Tooltip + TooltipRich): `color/background-surface/
/// inverse-3` fill, radius `border/radius/300`, `color/elevation/6` drop shadow
/// (blur and offset-y `spacing/100`, x and spread `spacing/0`) and a decorative
/// arrow `spacing/200` × `spacing/150` (radius 0) that sticks out
/// `spacing/100` (Figma geometry: 8 of its 12 px outside the surface; frame
/// value, no variable). The arrow area is part of the layout box.
///
/// Internal building block: use [LooviTooltip] / [LooviTooltipRich].
class LooviTooltipSurface extends StatelessWidget {
  const LooviTooltipSurface({super.key, required this.placement, required this.padding, required this.child});

  final LooviTooltipPlacement placement;

  /// Inner padding of the surface (excludes the arrow area).
  final EdgeInsets padding;
  final Widget child;

  /// Arrow tip distance from the bubble edge on `left` / `right`.
  static double arrowTipInset(LooviTokens t) => t.spacing.s200 + t.spacing.s200 / 2;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final shape = LooviTooltipShape(
      placement: placement,
      radius: t.radius.s300,
      arrowWidth: t.spacing.s200,
      arrowHeight: t.spacing.s150,
      protrusion: t.spacing.s100,
      inset: t.spacing.s200,
    );
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: t.color.backgroundSurfaceInverse3,
        shape: shape,
        shadows: [
          BoxShadow(
            color: t.color.elevation6,
            offset: Offset(t.spacing.s0, t.spacing.s100),
            blurRadius: t.spacing.s100,
            spreadRadius: t.spacing.s0,
          ),
        ],
      ),
      child: Padding(padding: shape.dimensions.resolve(TextDirection.ltr) + padding, child: child),
    );
  }
}

/// Rounded surface + triangular arrow as one outline (one fill, one shadow).
class LooviTooltipShape extends ShapeBorder {
  const LooviTooltipShape({
    required this.placement,
    required this.radius,
    required this.arrowWidth,
    required this.arrowHeight,
    required this.protrusion,
    required this.inset,
  });

  final LooviTooltipPlacement placement;
  final double radius;
  final double arrowWidth;
  final double arrowHeight;
  final double protrusion;
  final double inset;

  @override
  EdgeInsetsGeometry get dimensions =>
      placement.arrowOnTop ? EdgeInsets.only(top: protrusion) : EdgeInsets.only(bottom: protrusion);

  /// Surface rect inside [rect] (arrow area removed).
  Rect bodyRect(Rect rect) => placement.arrowOnTop
      ? Rect.fromLTRB(rect.left, rect.top + protrusion, rect.right, rect.bottom)
      : Rect.fromLTRB(rect.left, rect.top, rect.right, rect.bottom - protrusion);

  /// Arrow tip x inside [rect].
  double arrowTipX(Rect rect) => switch (placement.arrowAlign) {
        -1 => rect.left + inset + arrowWidth / 2,
        1 => rect.right - inset - arrowWidth / 2,
        _ => rect.center.dx,
      };

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final body = Path()..addRRect(RRect.fromRectAndRadius(bodyRect(rect), Radius.circular(radius)));
    final cx = arrowTipX(rect);
    final tipY = placement.arrowOnTop ? rect.top : rect.bottom;
    final baseY = placement.arrowOnTop ? rect.top + arrowHeight : rect.bottom - arrowHeight;
    final arrow = Path()
      ..moveTo(cx - arrowWidth / 2, baseY)
      ..lineTo(cx, tipY)
      ..lineTo(cx + arrowWidth / 2, baseY)
      ..close();
    return Path.combine(PathOperation.union, body, arrow);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => getOuterPath(rect, textDirection: textDirection);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;

  @override
  bool operator ==(Object other) =>
      other is LooviTooltipShape &&
      other.placement == placement &&
      other.radius == radius &&
      other.arrowWidth == arrowWidth &&
      other.arrowHeight == arrowHeight &&
      other.protrusion == protrusion &&
      other.inset == inset;

  @override
  int get hashCode => Object.hash(placement, radius, arrowWidth, arrowHeight, protrusion, inset);
}

/// Mobile tooltip anchor shared by [LooviTooltip] and [LooviTooltipRich]:
/// shows [overlayBuilder] in the app Overlay, pinned to [child].
///
/// - opens on tap (toggle) and long-press; [showOnKeyboardFocus] also opens
///   it when the trigger gets keyboard focus (no hover on mobile).
/// - dismissible without moving the pointer (WCAG 1.4.13): tap outside,
///   Escape, or [close] from the overlay. Stays open until dismissed.
/// - never moves focus on open; closing with Escape or an overlay action
///   returns focus to what had it when the overlay opened (the trigger).
/// - gap between trigger and arrow tip: `spacing/050`. The bubble hugs its
///   content up to the screen width minus `spacing/200` per side. It is not
///   clamped to the screen (that would detach the arrow): near an edge pick
///   the `*Left` / `*Right` placement, as in Figma.
///
/// Internal building block.
class LooviTooltipAnchor extends StatefulWidget {
  const LooviTooltipAnchor({
    super.key,
    required this.child,
    required this.placement,
    required this.overlayBuilder,
    this.showOnKeyboardFocus = true,
    this.onOpenChange,
  });

  final Widget child;
  final LooviTooltipPlacement placement;
  final Widget Function(BuildContext context, VoidCallback close) overlayBuilder;
  final bool showOnKeyboardFocus;
  final ValueChanged<bool>? onOpenChange;

  @override
  State<LooviTooltipAnchor> createState() => LooviTooltipAnchorState();
}

class LooviTooltipAnchorState extends State<LooviTooltipAnchor> {
  final OverlayPortalController _portal = OverlayPortalController();
  final LayerLink _link = LayerLink();
  FocusNode? _focusAtOpen;

  bool get isOpen => _portal.isShowing;

  void show() {
    if (_portal.isShowing) return;
    _focusAtOpen = FocusManager.instance.primaryFocus;
    HardwareKeyboard.instance.addHandler(_onKey);
    setState(_portal.show);
    widget.onOpenChange?.call(true);
  }

  /// Closes the overlay. [restoreFocus] (Escape, overlay actions) returns
  /// focus to what had it when the overlay opened.
  void hide({bool restoreFocus = false}) {
    if (!_portal.isShowing) return;
    HardwareKeyboard.instance.removeHandler(_onKey);
    setState(_portal.hide);
    final restore = _focusAtOpen;
    _focusAtOpen = null;
    if (restoreFocus && restore != null && restore.context != null && FocusManager.instance.primaryFocus != restore) {
      restore.requestFocus();
    }
    widget.onOpenChange?.call(false);
  }

  void toggle() => isOpen ? hide() : show();

  bool _onKey(KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
      hide(restoreFocus: true);
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.placement;
    final (Alignment target, Alignment follower) = switch ((p.arrowOnTop, p.arrowAlign)) {
      (true, -1) => (Alignment.bottomCenter, Alignment.topLeft),
      (true, 1) => (Alignment.bottomCenter, Alignment.topRight),
      (true, _) => (Alignment.bottomCenter, Alignment.topCenter),
      (false, -1) => (Alignment.topCenter, Alignment.bottomLeft),
      (false, 1) => (Alignment.topCenter, Alignment.bottomRight),
      (false, _) => (Alignment.topCenter, Alignment.bottomCenter),
    };

    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _portal,
        overlayChildBuilder: (context) {
          final t = LooviTokens.of(context);
          final inset = LooviTooltipSurface.arrowTipInset(t);
          final dx = switch (p.arrowAlign) { -1 => -inset, 1 => inset, _ => 0.0 };
          final dy = p.arrowOnTop ? t.spacing.s050 : -t.spacing.s050;
          final maxWidth = MediaQuery.sizeOf(context).width - 2 * t.spacing.s200;
          return Positioned(
            left: 0,
            top: 0,
            child: CompositedTransformFollower(
              link: _link,
              showWhenUnlinked: false,
              targetAnchor: target,
              followerAnchor: follower,
              offset: Offset(dx, dy),
              child: TapRegion(
                groupId: this,
                onTapOutside: (_) => hide(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  // Hug the content up to the screen width minus the margins.
                  child: IntrinsicWidth(child: widget.overlayBuilder(context, () => hide(restoreFocus: true))),
                ),
              ),
            ),
          );
        },
        child: TapRegion(
          groupId: this,
          child: Focus(
            canRequestFocus: false,
            skipTraversal: true,
            onFocusChange: (focused) {
              if (!widget.showOnKeyboardFocus) return;
              final keyboard = FocusManager.instance.highlightMode == FocusHighlightMode.traditional;
              if (focused && keyboard) show();
              if (!focused && keyboard) hide();
            },
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: toggle,
              onLongPress: show,
              excludeFromSemantics: true,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
