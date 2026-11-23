import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../generated/loovi_icon_names.g.dart';

/// Seed `NavigationBarItem.appearance`. Must match the bar appearance.
enum LooviNavigationBarItemAppearance {
  /// Seed `default` (light surfaces). `default` is a Dart keyword → `standard`.
  standard,

  /// Seed `inverse` (inverse / dark surfaces).
  inverse,
}

/// Seed `NavigationBarItem.badge`.
enum LooviNavigationBarItemBadge {
  /// No badge.
  none,

  /// Numeric count (nested Badge size=lg content=count|overflow).
  count,

  /// Activity dot (nested Badge size=sm content=dot).
  dot,
}

/// Data of one destination of [LooviNavigationBar] (seed `NavigationBarItem`).
///
/// [icon] is painted when not selected (outline contract), [selectedIcon]
/// when selected (filled contract; falls back to [icon]).
@immutable
class LooviNavigationBarItem {
  const LooviNavigationBarItem({
    required this.icon,
    required this.label,
    this.selectedIcon,
    this.badge = LooviNavigationBarItemBadge.none,
    this.count = 1,
    this.overflowLabel = '99+',
    this.maxCount = 99,
    this.showLabel = true,
    this.semanticLabel,
  });

  /// DS contract name for the unselected state, e.g. [LooviIcons.homeOutline].
  final String icon;

  /// DS contract name for the selected state, e.g. [LooviIcons.homeFilled].
  final String? selectedIcon;

  /// Seed `label` (caption/medium/medium). Also the accessible name.
  final String label;

  /// Seed `badge`.
  final LooviNavigationBarItemBadge badge;

  /// Seed `count` (nested Badge TEXT) when [badge] = count.
  final int count;

  /// Seed `overflowLabel` (nested Badge TEXT) shown when [count] > [maxCount].
  final String overflowLabel;

  /// Display limit before [overflowLabel] is used.
  final int maxCount;

  /// Seed `showLabel`. `false` = icon-only item (label stays the a11y name).
  final bool showLabel;

  /// Overrides the accessible name (default: label + badge description).
  final String? semanticLabel;
}

/// Seed `NavigationBarItem` (Figma 3327:2878; set on canvas 3653:15180) —
/// visual + interactive building block painted inside [LooviNavigationBar].
///
/// Anatomy (frame): root padding top `spacing/100`, horizontal `spacing/050`;
/// `iconContainer` radius `border/radius/400`; `stateLayer` padding vertical
/// `spacing/100`; icon 24 (`spacing/300`); label caption/medium/medium.
///
/// Colors (intentional model, seed `rules.colors`):
/// * default: unselected icon + label `text/secondary` · selected icon
///   `color/actions/primary`, selected LABEL `text/primary` (actions/primary is
///   4.41:1 at caption size — below AA) · pressed `text/primary` (selected or
///   not).
/// * inverse: unselected `text/on-color-disabled` · selected
///   `color/actions/tertiary` (icon and label) · pressed `text/on-color-disabled`.
/// * badge count: `color/palette/tangerine-1` + count `text/primary` (6.7:1 —
///   never `text/secondary`, 3.3:1).
///
/// Focus (keyboard only): `iconContainer` stroke `border/width/012`
/// `interactive/focus` + inner `effects/effect/focus` band. No hover (mobile).
///
/// Seed `state` is runtime: pressed/focus come from interaction, or from
/// [statesController] (stories/goldens).
class LooviNavigationBarItemView extends StatefulWidget {
  const LooviNavigationBarItemView({
    super.key,
    required this.item,
    this.selected = false,
    this.appearance = LooviNavigationBarItemAppearance.standard,
    this.onTap,
    this.statesController,
    this.focusNode,
    this.autofocus = false,
  });

  final LooviNavigationBarItem item;

  /// Seed `selected`.
  final bool selected;

  /// Seed `appearance`.
  final LooviNavigationBarItemAppearance appearance;

  final VoidCallback? onTap;

  /// Optional external states (pressed / focused) — used to pin a visual
  /// state in the catalog. Interaction still updates it.
  final WidgetStatesController? statesController;

  final FocusNode? focusNode;
  final bool autofocus;

  /// Minimum painted height (seed `spacing/800`; `spacing/600` icon-only).
  static double minHeight(LooviTokens t, {required bool showLabel}) => showLabel ? t.spacing.s800 : t.spacing.s600;

  @override
  State<LooviNavigationBarItemView> createState() => _LooviNavigationBarItemViewState();
}

class _LooviNavigationBarItemViewState extends State<LooviNavigationBarItemView> {
  WidgetStatesController? _internal;
  WidgetStatesController get _states => widget.statesController ?? (_internal ??= WidgetStatesController());

  @override
  void initState() {
    super.initState();
    _states.addListener(_onStates);
  }

  @override
  void didUpdateWidget(LooviNavigationBarItemView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.statesController != widget.statesController) {
      (oldWidget.statesController ?? _internal)?.removeListener(_onStates);
      _states.addListener(_onStates);
    }
  }

  @override
  void dispose() {
    _states.removeListener(_onStates);
    _internal?.dispose();
    super.dispose();
  }

  void _onStates() => setState(() {});

  void _set(WidgetState s, bool v) => _states.update(s, v);

  String _semanticLabel() {
    final item = widget.item;
    if (item.semanticLabel != null) return item.semanticLabel!;
    return switch (item.badge) {
      LooviNavigationBarItemBadge.none => item.label,
      LooviNavigationBarItemBadge.dot => '${item.label}, nova atividade',
      LooviNavigationBarItemBadge.count =>
        '${item.label}, ${item.count > item.maxCount ? item.overflowLabel : item.count} ${item.count == 1 ? 'notificação' : 'notificações'}',
    };
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final item = widget.item;
    final states = _states.value;
    final pressed = states.contains(WidgetState.pressed);
    final focused = states.contains(WidgetState.focused);
    final inverse = widget.appearance == LooviNavigationBarItemAppearance.inverse;

    final Color iconInk = switch ((inverse, pressed, widget.selected)) {
      (false, true, _) => t.text.primary,
      (false, false, true) => t.color.actionsPrimary,
      (false, false, false) => t.text.secondary,
      (true, true, _) => t.text.onColorDisabled,
      (true, false, true) => t.color.actionsTertiary,
      (true, false, false) => t.text.onColorDisabled,
    };
    // Selected label on default: text/primary (AA at caption size); the icon
    // keeps the color/actions/primary accent.
    final Color labelInk = !inverse && widget.selected ? t.text.primary : iconInk;

    final iconName = widget.selected ? (item.selectedIcon ?? item.icon) : item.icon;
    final iconSize = t.spacing.s300;

    Widget icon = LooviIcon(iconName, size: iconSize, color: iconInk);
    if (item.badge != LooviNavigationBarItemBadge.none) {
      // Badge anchor (frame, not tokenized): center ≈ icon right − spacing/025,
      // top − spacing/025 (count) / top (dot). Frame offsets: count center
      // +10/−1.5, dot center +9/+0.5 from icon center-x / icon top.
      final isCount = item.badge == LooviNavigationBarItemBadge.count;
      icon = Stack(
        clipBehavior: Clip.none,
        children: [
          icon,
          Positioned(
            left: iconSize - t.spacing.s025,
            top: isCount ? -t.spacing.s025 : 0,
            child: FractionalTranslation(
              translation: const Offset(-0.5, -0.5),
              child: isCount ? _CountBadge(item: item) : const _DotBadge(),
            ),
          ),
        ],
      );
    }

    final labelStyle = t.typography.captionMediumMedium.copyWith(color: labelInk);

    // iconContainer → stateLayer. The stateLayer's horizontal spacing/250 is
    // not applied to the label width (the label may use the full container
    // width before ellipsis) so 5-slot bars on 360 dp keep short labels whole.
    Widget container = Padding(
      padding: EdgeInsets.symmetric(vertical: t.spacing.s100),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          if (item.showLabel)
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              textAlign: TextAlign.center,
              style: labelStyle,
            ),
        ],
      ),
    );

    final radius = BorderRadius.circular(t.radius.s400);
    if (focused) {
      final band = t.effects.effectFocus.first;
      container = DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: t.interactive.focus, width: t.borderWidth.s012),
        ),
        child: DecoratedBox(
          position: DecorationPosition.foreground,
          // `effects/effect/focus` = INNER_SHADOW spread spacing/050.
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: band.color, width: band.spread),
          ),
          child: container,
        ),
      );
    }

    final enabled = widget.onTap != null;
    final content = ConstrainedBox(
      constraints: BoxConstraints(minHeight: LooviNavigationBarItemView.minHeight(t, showLabel: item.showLabel)),
      child: Padding(
        padding: EdgeInsets.only(left: t.spacing.s050, right: t.spacing.s050, top: t.spacing.s100),
        child: Align(
          alignment: Alignment.topCenter,
          heightFactor: 1,
          child: SizedBox(width: double.infinity, child: ExcludeSemantics(child: container)),
        ),
      ),
    );

    return Semantics(
      container: true,
      button: true,
      selected: widget.selected,
      inMutuallyExclusiveGroup: true,
      enabled: enabled,
      focusable: enabled,
      focused: enabled ? focused : null,
      label: _semanticLabel(),
      onTap: widget.onTap,
      child: FocusableActionDetector(
        enabled: enabled,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onShowFocusHighlight: (v) => _set(WidgetState.focused, v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
            widget.onTap?.call();
            return null;
          }),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          excludeFromSemantics: true,
          onTapDown: enabled ? (_) => _set(WidgetState.pressed, true) : null,
          onTapUp: enabled ? (_) => _set(WidgetState.pressed, false) : null,
          onTapCancel: enabled ? () => _set(WidgetState.pressed, false) : null,
          onTap: widget.onTap,
          child: content,
        ),
      ),
    );
  }
}

/// Nested Badge size=lg content=count|overflow: `color/palette/tangerine-1`,
/// radius full, caption/medium/regular `text/primary` (6.7:1 on tangerine-1;
/// `text/secondary` was 3.3:1 — seed `rules.colors`).
class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.item});
  final LooviNavigationBarItem item;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final text = item.count > item.maxCount ? item.overflowLabel : '${item.count}';
    return Container(
      constraints: BoxConstraints(minWidth: t.spacing.s200, minHeight: t.spacing.s200),
      padding: EdgeInsets.symmetric(horizontal: t.spacing.s050),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: t.color.paletteTangerine1,
        borderRadius: BorderRadius.circular(t.radius.full),
      ),
      child: Text(
        text,
        maxLines: 1,
        softWrap: false,
        textAlign: TextAlign.center,
        style: t.typography.captionMediumRegular.copyWith(color: t.text.primary),
      ),
    );
  }
}

/// Nested Badge size=sm content=dot: 16 box (`spacing/200`), dot drawn as the
/// `player-record-filled` glyph (⅔ of the box) in `color/palette/tangerine-1`.
class _DotBadge extends StatelessWidget {
  const _DotBadge();

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final box = t.spacing.s200;
    return SizedBox.square(
      dimension: box,
      child: Center(
        child: SizedBox.square(
          dimension: box * 2 / 3,
          child: DecoratedBox(
            decoration: BoxDecoration(color: t.color.paletteTangerine1, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}
