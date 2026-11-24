import 'dart:ui' show SemanticsRole;

import 'package:flutter/services.dart';
import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../tab_item/loovi_tab_item.dart';

export '../tab_item/loovi_tab_item.dart';

/// Seed `Tabs*.alignment` — horizontal distribution of the tabs.
enum LooviTabsAlignment { left, center }

/// Seed `TabsPrimary.appearance`.
enum LooviTabsPrimaryAppearance {
  /// Seed `default`. `default` is a Dart keyword → `standard`.
  standard,

  /// Seed `inverse` (mobile only in Figma) — inverse/dark surfaces.
  inverse,
}

/// Seed `TabsPrimary` (Figma 3532:6900) — primary tab list for related
/// sections of the same page. Composes [LooviTabItem] variant=primary.
///
/// Seed `itemCount` (2–5) = `tabs.length`. Controlled: [selectedIndex] +
/// [onChanged] (null = all tabs disabled).
///
/// Wrapper (mobile):
/// * default — padding-x `spacing/200`, gap `spacing/100` (Figma binds the
///   gap to the REMOTE legacy `Spacing/100`), no fill.
/// * inverse — track fill `color/background-surface/inverse-2`, radius
///   `border/radius/200`, padding `spacing/050`, gap `spacing/0` (Figma binds
///   all of these to REMOTE legacy variables `Color/Background Surface/Inverse 2`,
///   `Spacing/050|0`, `Border/Radius/200` — local tokens used here).
///
/// Tabs hug their label (Figma frames are a fixed 116 wide, not tokenized).
/// When the tabs don't fit, the list scrolls horizontally and the selected /
/// focused tab is scrolled into view.
///
/// Accessibility: `SemanticsRole.tabBar` + `SemanticsRole.tab` children with
/// selected state; ArrowLeft/ArrowRight (wrapping) and Home/End move focus and
/// select (automatic activation), Enter/Space activate. Touch: the whole
/// ≥ 48 dp band (`spacing/600`) is tappable — taps between/around tabs go to
/// the nearest tab; the painted tabs keep the Figma size (44).
class LooviTabsPrimary extends StatelessWidget {
  const LooviTabsPrimary({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    this.alignment = LooviTabsAlignment.left,
    this.appearance = LooviTabsPrimaryAppearance.standard,
    this.platform = LooviTabItemPlatform.mobile,
    this.semanticLabel,
  });

  /// Seed `itemCount` = `tabs.length` (2–5).
  final List<LooviTab> tabs;

  /// Index of the selected tab (seed nested `TabItem.state=selected`).
  final int selectedIndex;

  /// Called with the index the user activated (tap, keyboard).
  final ValueChanged<int>? onChanged;

  /// Seed `alignment`.
  final LooviTabsAlignment alignment;

  /// Seed `appearance` (synced to the nested TabItem appearance).
  final LooviTabsPrimaryAppearance appearance;

  /// Seed `platform` (both values paint mobile — see [LooviTabItemPlatform]).
  final LooviTabItemPlatform platform;

  /// Optional accessible name of the tab list.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => _LooviTabList(
        kind: appearance == LooviTabsPrimaryAppearance.inverse ? _TabListKind.primaryInverse : _TabListKind.primary,
        tabs: tabs,
        selectedIndex: selectedIndex,
        onChanged: onChanged,
        alignment: alignment,
        platform: platform,
        semanticLabel: semanticLabel,
      );
}

/// Seed `TabsSecondary` (Figma 3532:7346) — secondary (underline) tab list
/// for nested navigation inside a page, section or panel. Composes
/// [LooviTabItem] variant=secondary. No appearance axis (by design).
///
/// Wrapper (mobile): padding-x `spacing/200`, gap `spacing/0`, no fill; tabs
/// bottom-aligned so the `spacing/025` indicators sit on the band's bottom
/// edge. Same API, keyboard, scroll and 48 dp band as [LooviTabsPrimary]
/// (painted tabs are 38 tall).
class LooviTabsSecondary extends StatelessWidget {
  const LooviTabsSecondary({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    this.alignment = LooviTabsAlignment.left,
    this.platform = LooviTabItemPlatform.mobile,
    this.semanticLabel,
  });

  /// Seed `itemCount` = `tabs.length` (2–5).
  final List<LooviTab> tabs;
  final int selectedIndex;
  final ValueChanged<int>? onChanged;

  /// Seed `alignment`.
  final LooviTabsAlignment alignment;

  /// Seed `platform` (both values paint mobile).
  final LooviTabItemPlatform platform;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => _LooviTabList(
        kind: _TabListKind.secondary,
        tabs: tabs,
        selectedIndex: selectedIndex,
        onChanged: onChanged,
        alignment: alignment,
        platform: platform,
        semanticLabel: semanticLabel,
      );
}

/// Seed `TabsSegmented` (Figma 4738:825) — pill track for mutually exclusive
/// in-page choices (e.g. Cartão | Pix). Composes [LooviTabItem]
/// variant=segmented, equal-width segments that fill the track.
///
/// Track: `color/background-surface/0` + `color/border/2` stroke
/// (`border/width/012`), `border/radius/full`, padding `spacing/050`, gap
/// `spacing/0`. The track fills the available width (Figma demo frames are
/// fixed 342–600, not tokenized), so seed `alignment` has no visible effect
/// (segments are FILL in Figma too); it is kept for parity.
///
/// Painted track is 36 tall; the tappable band is ≥ 48 dp (`spacing/600`)
/// with the track centered in it. Keyboard/semantics as [LooviTabsPrimary].
class LooviTabsSegmented extends StatelessWidget {
  const LooviTabsSegmented({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    this.alignment = LooviTabsAlignment.left,
    this.platform = LooviTabItemPlatform.mobile,
    this.semanticLabel,
  });

  /// Seed `itemCount` = `tabs.length` (2–5).
  final List<LooviTab> tabs;
  final int selectedIndex;
  final ValueChanged<int>? onChanged;

  /// Seed `alignment` (no visual effect — segments fill the track).
  final LooviTabsAlignment alignment;

  /// Seed `platform` (both values paint mobile).
  final LooviTabItemPlatform platform;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => _LooviTabList(
        kind: _TabListKind.segmented,
        tabs: tabs,
        selectedIndex: selectedIndex,
        onChanged: onChanged,
        alignment: alignment,
        platform: platform,
        semanticLabel: semanticLabel,
      );
}

enum _TabListKind { primary, primaryInverse, secondary, segmented }

class _LooviTabList extends StatefulWidget {
  const _LooviTabList({
    required this.kind,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    required this.alignment,
    required this.platform,
    required this.semanticLabel,
  });

  final _TabListKind kind;
  final List<LooviTab> tabs;
  final int selectedIndex;
  final ValueChanged<int>? onChanged;
  final LooviTabsAlignment alignment;
  final LooviTabItemPlatform platform;
  final String? semanticLabel;

  @override
  State<_LooviTabList> createState() => _LooviTabListState();
}

class _LooviTabListState extends State<_LooviTabList> {
  final GlobalKey _bandKey = GlobalKey(debugLabel: 'LooviTabs.band');
  final List<FocusNode> _nodes = [];
  final List<GlobalKey> _keys = [];

  @override
  void initState() {
    super.initState();
    _syncNodes();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reveal(widget.selectedIndex, animate: false));
  }

  @override
  void didUpdateWidget(_LooviTabList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncNodes();
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _reveal(widget.selectedIndex));
    }
  }

  void _syncNodes() {
    while (_nodes.length < widget.tabs.length) {
      final i = _nodes.length;
      _nodes.add(FocusNode(debugLabel: 'LooviTab $i'));
      _keys.add(GlobalKey(debugLabel: 'LooviTab $i'));
    }
    while (_nodes.length > widget.tabs.length) {
      _nodes.removeLast().dispose();
      _keys.removeLast();
    }
  }

  @override
  void dispose() {
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  bool _enabledAt(int i) => widget.onChanged != null && !widget.tabs[i].disabled;

  void _select(int i) {
    if (!_enabledAt(i)) return;
    if (i != widget.selectedIndex) widget.onChanged!(i);
  }

  void _reveal(int i, {bool animate = true}) {
    if (!mounted || i < 0 || i >= _keys.length) return;
    final ctx = _keys[i].currentContext;
    if (ctx == null || Scrollable.maybeOf(ctx) == null) return;
    final reduced = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    Scrollable.ensureVisible(
      ctx,
      alignment: 0.5,
      duration: animate && !reduced ? const Duration(milliseconds: 200) : Duration.zero,
      curve: Curves.easeOut,
    );
  }

  /// Arrow/Home/End navigation (WAI-ARIA tabs, automatic activation).
  KeyEventResult _onKey(FocusNode _, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return KeyEventResult.ignored;
    final count = widget.tabs.length;
    final current = _nodes.indexWhere((n) => n.hasFocus);
    if (current < 0) return KeyEventResult.ignored;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    int? target;
    int step(int from, int dir) {
      for (var k = 1; k <= count; k++) {
        final i = (from + dir * k) % count;
        final j = i < 0 ? i + count : i;
        if (_enabledAt(j)) return j;
      }
      return from;
    }

    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowRight) {
      target = step(current, rtl ? -1 : 1);
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      target = step(current, rtl ? 1 : -1);
    } else if (key == LogicalKeyboardKey.home) {
      target = _enabledAt(0) ? 0 : step(0, 1);
    } else if (key == LogicalKeyboardKey.end) {
      target = _enabledAt(count - 1) ? count - 1 : step(count - 1, -1);
    }
    if (target == null) return KeyEventResult.ignored;
    _nodes[target].requestFocus();
    _select(target);
    _reveal(target);
    return KeyEventResult.handled;
  }

  /// Band tap outside the painted tabs → nearest tab (horizontally).
  void _onBandTap(TapUpDetails d) {
    final band = _bandKey.currentContext?.findRenderObject();
    if (band is! RenderBox) return;
    final t = LooviTokens.of(context);
    var best = -1;
    var bestDist = double.infinity;
    for (var i = 0; i < _keys.length; i++) {
      final box = _keys[i].currentContext?.findRenderObject();
      if (box is! RenderBox || !box.attached) continue;
      final topLeft = band.globalToLocal(box.localToGlobal(Offset.zero));
      final left = topLeft.dx;
      final right = left + box.size.width;
      final dx = d.localPosition.dx;
      final dist = dx < left ? left - dx : (dx > right ? dx - right : 0.0);
      if (dist < bestDist) {
        bestDist = dist;
        best = i;
      }
    }
    // Tolerance: the band padding (spacing/200) — beyond it the tap is not on
    // the tab list.
    if (best >= 0 && bestDist <= t.spacing.s200) _select(best);
  }

  LooviTabItemVariant get _variant => switch (widget.kind) {
        _TabListKind.primary || _TabListKind.primaryInverse => LooviTabItemVariant.primary,
        _TabListKind.secondary => LooviTabItemVariant.secondary,
        _TabListKind.segmented => LooviTabItemVariant.segmented,
      };

  Widget _item(int i) => LooviTabItem(
        key: _keys[i],
        tab: widget.tabs[i],
        variant: _variant,
        platform: widget.platform,
        appearance: widget.kind == _TabListKind.primaryInverse
            ? LooviTabItemAppearance.inverse
            : LooviTabItemAppearance.standard,
        selected: i == widget.selectedIndex,
        focusNode: _nodes[i],
        onTap: _enabledAt(i) ? () => _select(i) : null,
      );

  Widget _tabBar(Widget row) => Semantics(
        container: true,
        explicitChildNodes: true,
        role: SemanticsRole.tabBar,
        label: widget.semanticLabel,
        child: row,
      );

  @override
  Widget build(BuildContext context) {
    assert(
      widget.tabs.length >= 2 && widget.tabs.length <= 5,
      'Tabs: itemCount do seed é 2–5 (recebeu ${widget.tabs.length}).',
    );
    assert(widget.selectedIndex >= 0 && widget.selectedIndex < widget.tabs.length);
    final t = LooviTokens.of(context);
    final minBand = t.spacing.s600;

    final Widget band;
    switch (widget.kind) {
      case _TabListKind.segmented:
        band = ConstrainedBox(
          constraints: BoxConstraints(minHeight: minBand),
          child: Align(
            heightFactor: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: t.color.backgroundSurface0,
                borderRadius: BorderRadius.circular(t.radius.full),
                border: Border.all(color: t.color.border2, width: t.borderWidth.s012),
              ),
              child: Padding(
                padding: EdgeInsets.all(t.spacing.s050),
                child: _tabBar(Row(
                  children: [
                    for (var i = 0; i < widget.tabs.length; i++) Expanded(child: _item(i)),
                  ],
                )),
              ),
            ),
          ),
        );
      case _TabListKind.primary:
      case _TabListKind.primaryInverse:
      case _TabListKind.secondary:
        final inverse = widget.kind == _TabListKind.primaryInverse;
        final secondary = widget.kind == _TabListKind.secondary;
        final gap = switch (widget.kind) {
          _TabListKind.primary => t.spacing.s100,
          _ => t.spacing.s0,
        };
        final padX = inverse ? t.spacing.s0 : t.spacing.s200;
        final row = Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: secondary ? CrossAxisAlignment.end : CrossAxisAlignment.center,
          children: [
            for (var i = 0; i < widget.tabs.length; i++) ...[
              if (i > 0 && gap > 0) SizedBox(width: gap),
              _item(i),
            ],
          ],
        );
        // Inverse: the track padding (spacing/050) is part of the band.
        final rowMinHeight = inverse ? minBand - 2 * t.spacing.s050 : minBand;
        Widget scroller = LayoutBuilder(
          builder: (context, c) {
            final minWidth = c.hasBoundedWidth ? c.maxWidth : 0.0;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: minWidth, minHeight: rowMinHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: padX),
                  child: Align(
                    widthFactor: 1,
                    heightFactor: 1,
                    alignment: switch ((widget.alignment, secondary)) {
                      (LooviTabsAlignment.left, false) => AlignmentDirectional.centerStart,
                      (LooviTabsAlignment.center, false) => AlignmentDirectional.center,
                      (LooviTabsAlignment.left, true) => AlignmentDirectional.bottomStart,
                      (LooviTabsAlignment.center, true) => AlignmentDirectional.bottomCenter,
                    },
                    child: _tabBar(row),
                  ),
                ),
              ),
            );
          },
        );
        if (inverse) {
          scroller = DecoratedBox(
            decoration: BoxDecoration(
              color: t.color.backgroundSurfaceInverse2,
              borderRadius: BorderRadius.circular(t.radius.s200),
            ),
            child: Padding(padding: EdgeInsets.all(t.spacing.s050), child: scroller),
          );
        }
        band = scroller;
    }

    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: _onKey,
      child: GestureDetector(
        key: _bandKey,
        behavior: HitTestBehavior.opaque,
        excludeFromSemantics: true,
        onTapUp: widget.onChanged == null ? null : _onBandTap,
        child: band,
      ),
    );
  }
}
