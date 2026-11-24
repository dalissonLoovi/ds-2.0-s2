import 'dart:math' as math;
import 'dart:ui' show SemanticsRole;

import 'package:flutter/services.dart';
import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../list_action_dropdown_item/loovi_list_action_dropdown_item.dart';
import '../list_item/loovi_list_item.dart' show LooviListItemDivider;

/// Seed ListActionDropdown (Figma 3694:1501) — menu surface for grouped list
/// actions opened by an external trigger (e.g. a "more" icon on a row).
///
/// Use it as the menu panel only: rows are [LooviListActionDropdownItem];
/// groups are separated by DividerHorizontal full-width
/// ([LooviListItemDivider]). Open it anchored to its trigger with
/// [showLooviListActionDropdown].
///
/// Paint tokens (mode app-cliente):
/// - surface `color/background-surface/0`, corners product-theme
///   `component/list-action/container/radius` (app-cliente → radius/500);
/// - `effects/elevation/2` (DROP_SHADOW `color/elevation/5`, 0 /
///   `spacing/200` / `spacing/300`);
/// - padding `spacing/100` (v) / `spacing/0` (h), gap `spacing/0`;
/// - [showScroll] thumb `spacing/050` × `spacing/800`, `border/radius/full`,
///   `color/palette/graph` (visual affordance only);
/// - items and divider own their tokens.
///
/// Content scrolls when the panel is height-constrained (e.g. by the route).
///
/// Semantics: role menu (items take role menuItem); dividers are decorative.
/// Keyboard: ArrowDown / ArrowUp move focus between items, Enter / Space
/// activate, Escape closes the route opened by [showLooviListActionDropdown].
/// The trigger owns the expanded state.
class LooviListActionDropdown extends StatelessWidget {
  /// Slot constructor: custom [LooviListActionDropdownItem] /
  /// [LooviListItemDivider] composition (seed `slot`).
  const LooviListActionDropdown({
    super.key,
    required List<Widget> this.children,
    this.showScroll = false,
    this.semanticLabel,
  })  : groups = null,
        showDivider = true;

  /// Default composition: item [groups] separated by a divider when
  /// [showDivider] is true (seed `showDivider`, default true).
  const LooviListActionDropdown.grouped({
    super.key,
    required List<List<Widget>> this.groups,
    this.showDivider = true,
    this.showScroll = false,
    this.semanticLabel,
  }) : children = null;

  /// Seed `slot`.
  final List<Widget>? children;

  /// Item groups for [LooviListActionDropdown.grouped].
  final List<List<Widget>>? groups;

  /// Seed `showDivider` — divider between [groups].
  final bool showDivider;

  /// Seed `showScroll` — right-edge scroll thumb (visual only).
  final bool showScroll;

  /// Accessible name of the menu (e.g. "Ações do veículo").
  final String? semanticLabel;

  List<Widget> get _items {
    if (children != null) return children!;
    final out = <Widget>[];
    final g = groups!;
    for (var i = 0; i < g.length; i++) {
      if (i > 0 && showDivider) out.add(const LooviListItemDivider());
      out.addAll(g[i]);
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final radius = BorderRadius.circular(t.component.listAction.containerRadius);

    Widget content = SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _items,
      ),
    );

    if (showScroll) {
      content = Stack(
        children: [
          content,
          PositionedDirectional(
            top: t.spacing.s0,
            end: t.spacing.s100,
            child: ExcludeSemantics(
              child: Container(
                width: t.spacing.s050,
                height: t.spacing.s800,
                decoration: BoxDecoration(
                  color: t.color.paletteGraph,
                  borderRadius: BorderRadius.circular(t.radius.full),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Semantics(
      container: true,
      role: SemanticsRole.menu,
      label: semanticLabel,
      explicitChildNodes: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: t.color.backgroundSurface0,
          borderRadius: radius,
          boxShadow: LooviEffects.box(t.effects.elevation2),
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: t.spacing.s100, horizontal: t.spacing.s0),
            child: Shortcuts(
              shortcuts: const <ShortcutActivator, Intent>{
                SingleActivator(LogicalKeyboardKey.arrowDown): NextFocusIntent(),
                SingleActivator(LogicalKeyboardKey.arrowUp): PreviousFocusIntent(),
              },
              child: FocusTraversalGroup(
                child: LooviListActionDropdownScope(child: content),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Opens a [LooviListActionDropdown] anchored to the widget of [context]
/// (the trigger): below it, start-aligned, flipped above when there is not
/// enough room, kept `spacing/200` from the screen edges.
///
/// Dismissed by tapping outside, Escape or system back. Items close the menu
/// themselves (`Navigator.pop(context, value)` in `onSelect`); the future
/// completes with that value (null when dismissed).
///
/// [width] defaults to hugging the content, never narrower than the trigger
/// (the Figma panel is 240 dp, a frame width without token).
Future<T?> showLooviListActionDropdown<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  double? width,
  String barrierLabel = 'Fechar menu',
}) {
  final navigator = Navigator.of(context);
  final trigger = context.findRenderObject()! as RenderBox;
  final overlay = navigator.overlay!.context.findRenderObject()! as RenderBox;
  final anchor = Rect.fromPoints(
    trigger.localToGlobal(Offset.zero, ancestor: overlay),
    trigger.localToGlobal(trigger.size.bottomRight(Offset.zero), ancestor: overlay),
  );
  return navigator.push(
    _LooviListActionDropdownRoute<T>(
      anchor: anchor,
      builder: builder,
      width: width,
      barrierLabel: barrierLabel,
      capturedThemes: InheritedTheme.capture(from: context, to: navigator.context),
    ),
  );
}

class _LooviListActionDropdownRoute<T> extends PopupRoute<T> {
  _LooviListActionDropdownRoute({
    required this.anchor,
    required this.builder,
    required this.width,
    required this.barrierLabel,
    required this.capturedThemes,
  });

  final Rect anchor;
  final WidgetBuilder builder;
  final double? width;
  final CapturedThemes capturedThemes;

  @override
  final String barrierLabel;

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 150);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    final t = LooviTokens.of(context);
    final margin = t.spacing.s200;
    final gap = t.spacing.s050;
    Widget panel = Builder(builder: builder);
    panel = width != null
        ? SizedBox(width: width, child: panel)
        : IntrinsicWidth(child: ConstrainedBox(constraints: BoxConstraints(minWidth: anchor.width), child: panel));
    return capturedThemes.wrap(
      MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: CustomSingleChildLayout(
          delegate: _AnchorLayout(anchor: anchor, margin: margin, gap: gap, padding: MediaQuery.paddingOf(context)),
          child: FocusScope(autofocus: true, child: panel),
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return FadeTransition(opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut), child: child);
  }
}

class _AnchorLayout extends SingleChildLayoutDelegate {
  _AnchorLayout({required this.anchor, required this.margin, required this.gap, required this.padding});

  final Rect anchor;
  final double margin;
  final double gap;
  final EdgeInsets padding;

  double _below(Size size) => size.height - padding.bottom - margin - anchor.bottom - gap;
  double _above() => anchor.top - gap - padding.top - margin;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final size = constraints.biggest;
    final maxH = math.max(_below(size), _above());
    return BoxConstraints(maxWidth: math.max(0, size.width - 2 * margin), maxHeight: math.max(0, maxH));
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final fitsBelow = childSize.height <= _below(size) || _below(size) >= _above();
    final y = fitsBelow ? anchor.bottom + gap : anchor.top - gap - childSize.height;
    final x = anchor.left.clamp(margin, math.max(margin, size.width - margin - childSize.width)).toDouble();
    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_AnchorLayout old) =>
      anchor != old.anchor || margin != old.margin || gap != old.gap || padding != old.padding;
}
