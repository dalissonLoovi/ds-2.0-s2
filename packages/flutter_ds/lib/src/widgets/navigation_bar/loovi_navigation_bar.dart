import 'dart:math' as math;
import 'dart:ui' show SemanticsRole;

import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../generated/loovi_icon_names.g.dart';
import 'loovi_navigation_bar_item.dart';

export 'loovi_navigation_bar_item.dart';

/// Seed `NavigationBar.itemCount`.
enum LooviNavigationBarItemCount {
  /// Seed `3` — three destinations.
  three,

  /// Seed `4` — four destinations.
  four,

  /// Seed `5` — four destinations + centered primary action (not 5 tabs).
  five;

  /// Number of [LooviNavigationBarItem] destinations this count expects.
  int get destinations => switch (this) {
        LooviNavigationBarItemCount.three => 3,
        LooviNavigationBarItemCount.four => 4,
        LooviNavigationBarItemCount.five => 4,
      };
}

/// Seed `NavigationBar.appearance`.
enum LooviNavigationBarAppearance {
  /// Seed `default` (`color/background-surface/0`). `default` is a Dart
  /// keyword → `standard`.
  standard,

  /// Seed `inverse` (`color/background-surface/inverse-3`).
  inverse;

  LooviNavigationBarItemAppearance get item => switch (this) {
        LooviNavigationBarAppearance.standard => LooviNavigationBarItemAppearance.standard,
        LooviNavigationBarAppearance.inverse => LooviNavigationBarItemAppearance.inverse,
      };
}

/// Seed `NavigationBar.layout`.
enum LooviNavigationBarLayout {
  /// Edge-to-edge, `border/radius/0`, no elevation.
  flush,

  /// Pill: `border/radius/full` + soft drop shadow. Horizontal inset around
  /// the pill is screen composition (not part of this widget).
  floating,
}

/// Seed `NavigationBar` (Figma 3653:14851) — mobile bottom navigation for
/// primary app destinations. Composes [LooviNavigationBarItem]s; item
/// appearance follows the bar.
///
/// * [itemCount] 3|4 → only destinations; 5 → `items[0..1]` + centered
///   primary action ([primaryLabel], [onPrimaryAction]) + `items[2..3]`.
/// * Bar height `spacing/800` (grows with the system text scale, never
///   clipped). With [LooviNavigationBarItemCount.five] the primary action
///   overhangs the bar upwards (Figma: slot height = bar, content bottom
///   aligned); the overhang is part of this widget's layout so the whole
///   action stays tappable.
/// * Bottom safe area: flush paints the surface through the inset and pads
///   the content; floating lifts the pill above the inset.
class LooviNavigationBar extends StatelessWidget {
  const LooviNavigationBar({
    super.key,
    required this.items,
    this.selectedIndex,
    this.onSelected,
    this.itemCount = LooviNavigationBarItemCount.four,
    this.appearance = LooviNavigationBarAppearance.standard,
    this.layout = LooviNavigationBarLayout.flush,
    this.primaryLabel = 'Acionar',
    this.primaryIcon = LooviIcons.plusOutline,
    this.onPrimaryAction,
    this.semanticLabel = 'Navegação principal',
  });

  /// Destinations (3, 4, or 4 when [itemCount] is five).
  final List<LooviNavigationBarItem> items;

  /// Index in [items] of the current destination (`selected=true`).
  final int? selectedIndex;

  /// Called with the tapped destination index.
  final ValueChanged<int>? onSelected;

  /// Seed `itemCount`.
  final LooviNavigationBarItemCount itemCount;

  /// Seed `appearance`.
  final LooviNavigationBarAppearance appearance;

  /// Seed `layout`.
  final LooviNavigationBarLayout layout;

  /// Seed `primaryLabel` (itemCount=5 only) — caption under the action and
  /// its accessible name.
  final String primaryLabel;

  /// Primary action icon (seed default `plus-outline`).
  final String primaryIcon;

  /// Primary action callback (itemCount=5 only).
  final VoidCallback? onPrimaryAction;

  /// Accessible name of the navigation landmark.
  final String semanticLabel;

  /// Painted bar height for the current text scale: `spacing/800`, or more
  /// when the scaled label needs it.
  static double barHeight(BuildContext context) {
    final t = LooviTokens.of(context);
    return math.max(t.spacing.s800, t.spacing.s100 * 3 + t.spacing.s300 + _labelLineHeight(context));
  }

  static double _labelLineHeight(BuildContext context) {
    final style = LooviTokens.of(context).typography.captionMediumMedium;
    final size = style.fontSize ?? 0;
    return MediaQuery.textScalerOf(context).scale(size) * (style.height ?? 1);
  }

  @override
  Widget build(BuildContext context) {
    assert(
      items.length == itemCount.destinations,
      'LooviNavigationBar: itemCount=${itemCount.name} espera ${itemCount.destinations} itens (recebeu ${items.length}).',
    );
    assert(selectedIndex == null || (selectedIndex! >= 0 && selectedIndex! < items.length));

    final t = LooviTokens.of(context);
    final inverse = appearance == LooviNavigationBarAppearance.inverse;
    final floating = layout == LooviNavigationBarLayout.floating;
    final hasPrimary = itemCount == LooviNavigationBarItemCount.five;
    final safeBottom = MediaQuery.paddingOf(context).bottom;

    final barH = barHeight(context);
    final slotH = t.spacing.s700 + t.spacing.s050 + _labelLineHeight(context) + t.spacing.s150;
    final overhang = hasPrimary ? math.max(0.0, slotH - barH) : 0.0;

    Widget destination(int i) => Expanded(
          child: SizedBox(
            height: barH,
            child: LooviNavigationBarItemView(
              item: items[i],
              selected: i == selectedIndex,
              appearance: appearance.item,
              onTap: onSelected == null ? null : () => onSelected!(i),
            ),
          ),
        );

    final children = <Widget>[
      for (var i = 0; i < items.length; i++) ...[
        if (hasPrimary && i == 2)
          Expanded(
            child: _PrimarySlot(
              label: primaryLabel,
              icon: primaryIcon,
              inverse: inverse,
              onPressed: onPrimaryAction,
            ),
          ),
        destination(i),
      ],
    ];

    final surface = BoxDecoration(
      color: inverse ? t.color.backgroundSurfaceInverse3 : t.color.backgroundSurface0,
      borderRadius: BorderRadius.circular(floating ? t.radius.full : t.radius.s0),
      // Floating shadow is manual in Figma (y=8 blur=24 a=0.16, not bound) →
      // closest tokens: color/elevation/4 + spacing/100 + spacing/300.
      boxShadow: floating
          ? [BoxShadow(color: t.color.elevation4, offset: Offset(0, t.spacing.s100), blurRadius: t.spacing.s300)]
          : null,
    );

    return Semantics(
      container: true,
      explicitChildNodes: true,
      role: SemanticsRole.navigation,
      label: semanticLabel,
      child: SizedBox(
        height: overhang + barH + safeBottom,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: floating ? safeBottom : 0,
              height: floating ? barH : barH + safeBottom,
              child: DecoratedBox(decoration: surface),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: safeBottom,
              height: barH + overhang,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: children),
            ),
          ],
        ),
      ),
    );
  }
}

/// `primaryIconButtonSlot` (itemCount=5): circular FAB (Button solid/lg with
/// NavigationBar-local overrides) above a caption/medium/medium label.
/// FAB `spacing/700` square, `border/radius/full`,
/// `component/button/container/background`, icon 24 `text/on-color`;
/// gap `spacing/050`; padding bottom `spacing/150`.
///
/// Keyboard: focusable like any Button; focus-visible draws the Button focus
/// stroke (`interactive/focus`, `border/width/025`) around the FAB.
class _PrimarySlot extends StatefulWidget {
  const _PrimarySlot({required this.label, required this.icon, required this.inverse, this.onPressed});

  final String label;
  final String icon;
  final bool inverse;
  final VoidCallback? onPressed;

  @override
  State<_PrimarySlot> createState() => _PrimarySlotState();
}

class _PrimarySlotState extends State<_PrimarySlot> {
  bool _focusHighlight = false;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final enabled = widget.onPressed != null;
    return Semantics(
      container: true,
      button: true,
      enabled: enabled,
      label: widget.label,
      onTap: widget.onPressed,
      child: FocusableActionDetector(
        enabled: enabled,
        onShowFocusHighlight: (v) => setState(() => _focusHighlight = v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
            widget.onPressed?.call();
            return null;
          }),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          excludeFromSemantics: true,
          onTap: widget.onPressed,
          child: ExcludeSemantics(
            child: Padding(
              padding: EdgeInsets.only(bottom: t.spacing.s150),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    key: const Key('loovi-navigation-bar-primary'),
                    width: t.spacing.s700,
                    height: t.spacing.s700,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: t.component.button.containerBackground,
                      borderRadius: BorderRadius.circular(t.radius.full),
                      border: _focusHighlight && enabled
                          ? Border.all(color: t.interactive.focus, width: t.borderWidth.s025)
                          : null,
                    ),
                    child: LooviIcon(widget.icon, size: t.spacing.s300, color: t.text.onColor),
                  ),
                  SizedBox(height: t.spacing.s050),
                  Text(
                    widget.label,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: t.typography.captionMediumMedium.copyWith(
                      color: widget.inverse ? t.text.onColorDisabled : t.text.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
