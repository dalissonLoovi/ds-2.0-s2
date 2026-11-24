import 'dart:ui' show SemanticsRole;

import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_blend.dart';
import '../../foundation/loovi_icon.dart';
import '../../generated/loovi_icon_names.g.dart';

/// Seed `TabItem.variant`.
enum LooviTabItemVariant {
  /// Filled tab (`TabsPrimary`).
  primary,

  /// Underline tab (`TabsSecondary`).
  secondary,

  /// Pill segment (`TabsSegmented`).
  segmented,
}

/// Seed `TabItem.platform`.
///
/// The app (mode app-cliente) is mobile: both values paint the **mobile**
/// density of the Figma set. `web` is kept for API parity with the seed /
/// React (`@ds/react`) but is not targeted here — the web frames differ
/// (primary web is 32 tall with its own selected treatment) and are not
/// ported.
enum LooviTabItemPlatform { web, mobile }

/// Seed `TabItem.appearance`. `inverse` is published only for
/// `variant=primary` (+ mobile); secondary/segmented ignore it.
enum LooviTabItemAppearance {
  /// Seed `default`. `default` is a Dart keyword → `standard`.
  standard,

  /// Seed `inverse` (inverse / dark surfaces).
  inverse,
}

/// Data of one tab in [LooviTabsPrimary] / [LooviTabsSecondary] /
/// [LooviTabsSegmented] (seed `TabItem` TEXT/BOOLEAN/INSTANCE_SWAP props).
@immutable
class LooviTab {
  const LooviTab({
    required this.label,
    this.showIcon = false,
    this.leadingIcon = LooviIcons.userOutline,
    this.showAttention = false,
    this.attentionIcon = LooviIcons.alertCircleFilled,
    this.attentionSemanticLabel = 'requer atenção',
    this.disabled = false,
    this.semanticLabel,
  });

  /// Seed `label` (TEXT). Also the accessible name.
  final String label;

  /// Seed `showIcon`.
  final bool showIcon;

  /// Seed `leadingIcon` (INSTANCE_SWAP, Figma default `user-outline`).
  final String leadingIcon;

  /// Seed `showAttention`.
  final bool showAttention;

  /// Seed `attentionIcon` (INSTANCE_SWAP, default `alert-circle-filled`).
  final String attentionIcon;

  /// Appended to the accessible name when [showAttention] is true (the
  /// attention icon is not decorative: it carries status).
  final String attentionSemanticLabel;

  /// Seed `state=disabled`.
  final bool disabled;

  /// Overrides the accessible name (default: label [+ attention]).
  final String? semanticLabel;
}

/// Seed `TabItem` (Figma 3532:6782) — one tab inside a tab list. Compose it
/// only through [LooviTabsPrimary], [LooviTabsSecondary] or
/// [LooviTabsSegmented]; they own selection, keyboard and the 48 dp hit band.
///
/// Seed `state`: `selected` and `disabled` are props; `hover` is not used on
/// the app (mobile); focus is not published in Figma — the keyboard focus
/// ring here is `interactive/focus` `border/width/025` (same as the chips).
///
/// Anatomy (mobile): label `body/medium/medium`; icons 16 (`spacing/200`);
/// gap icon↔label↔attention `spacing/100`.
///
/// * primary — padding `spacing/150`, radius `border/radius/200`.
///   * default: fill `color/background-surface/0`, label `text/secondary`,
///     icon `text/placeholder`.
///   * selected: fill `color/background-surface/2`, icon `text/brand`. LABEL
///     `text/primary` (Figma aligned 2026-11-24; actions/primary was 3.9:1 on
///     surface/2); same decision as NavigationBarItem.
///   * disabled: fill `interactive/disabled-surface`, label + icon
///     `text/placeholder` (Figma icon: remote `Color/Content/Ghost`).
///   * inverse default: fill `color/background-surface/inverse-2`, label
///     `text/on-color`, icon `text/on-color-disabled` (Figma icon: remote
///     `Color/Content/Disabled Inverse`).
///   * inverse selected: `interactive/selected` Plus Darker (LINEAR_BURN)
///     over `color/background-surface/inverse-3`; label + icon
///     `color/actions/tertiary` (11.9:1).
///   * inverse disabled: fill inverse-2, label + icon `text/placeholder-inverse`.
/// * secondary — padding top/x `spacing/150`, bottom `spacing/0`; gap
///   content↔indicator `spacing/050`; indicator `spacing/025` tall,
///   `border/radius/full`, `color/actions/primary`, as wide as the content.
///   default label `text/secondary` + icon `text/placeholder`; selected icon
///   `text/brand` + LABEL `text/primary` (Figma actions/primary = 4.41:1 on
///   surface/0); disabled `text/placeholder`. The indicator slot is always
///   reserved (transparent when not selected) so tabs don't jump 32 → 38.
/// * segmented — padding `spacing/050`, radius `border/radius/full`;
///   selected fill `color/actions/primary` + `text/on-color` (4.52:1);
///   default transparent + `text/secondary`; disabled `text/placeholder`.
///
/// Attention icon: status icon next to a text → `feedback/danger`
/// (seed `feedbackColorRule`); `text/placeholder(-inverse)` when disabled.
/// Figma leaves it unbound (instance fill `text/secondary`, no glyph ink).
class LooviTabItem extends StatefulWidget {
  const LooviTabItem({
    super.key,
    required this.tab,
    this.variant = LooviTabItemVariant.primary,
    this.platform = LooviTabItemPlatform.mobile,
    this.appearance = LooviTabItemAppearance.standard,
    this.selected = false,
    this.onTap,
    this.focusNode,
    this.autofocus = false,
    this.showFocusRing,
  });

  final LooviTab tab;

  /// Seed `variant`.
  final LooviTabItemVariant variant;

  /// Seed `platform` (both values paint mobile — see [LooviTabItemPlatform]).
  final LooviTabItemPlatform platform;

  /// Seed `appearance` (primary only).
  final LooviTabItemAppearance appearance;

  /// Seed `state=selected`.
  final bool selected;

  /// Activation (tap, Enter/Space). Null or [LooviTab.disabled] = disabled.
  final VoidCallback? onTap;

  final FocusNode? focusNode;
  final bool autofocus;

  /// Pins the keyboard focus ring (catalog / goldens). Null = runtime.
  final bool? showFocusRing;

  @override
  State<LooviTabItem> createState() => _LooviTabItemState();
}

class _LooviTabItemState extends State<LooviTabItem> {
  bool _focusHighlight = false;

  bool get _enabled => widget.onTap != null && !widget.tab.disabled;

  bool get _inverse =>
      widget.variant == LooviTabItemVariant.primary && widget.appearance == LooviTabItemAppearance.inverse;

  /// (fill, label, icon) of the current state.
  (Color?, Color, Color) _paint(LooviTokens t) {
    final disabled = widget.tab.disabled;
    final selected = widget.selected && !disabled;
    switch (widget.variant) {
      case LooviTabItemVariant.primary:
        if (_inverse) {
          if (disabled) return (t.color.backgroundSurfaceInverse2, t.text.placeholderInverse, t.text.placeholderInverse);
          if (selected) {
            return (
              looviPlusDarker(t.color.backgroundSurfaceInverse3, t.interactive.selected),
              t.color.actionsTertiary,
              t.color.actionsTertiary,
            );
          }
          return (t.color.backgroundSurfaceInverse2, t.text.onColor, t.text.onColorDisabled);
        }
        if (disabled) return (t.interactive.disabledSurface, t.text.placeholder, t.text.placeholder);
        if (selected) return (t.color.backgroundSurface2, t.text.primary, t.text.brand);
        return (t.color.backgroundSurface0, t.text.secondary, t.text.placeholder);
      case LooviTabItemVariant.secondary:
        if (disabled) return (null, t.text.placeholder, t.text.placeholder);
        if (selected) return (null, t.text.primary, t.text.brand);
        return (null, t.text.secondary, t.text.placeholder);
      case LooviTabItemVariant.segmented:
        if (disabled) return (null, t.text.placeholder, t.text.placeholder);
        if (selected) return (t.color.actionsPrimary, t.text.onColor, t.text.onColor);
        return (null, t.text.secondary, t.text.secondary);
    }
  }

  BorderRadius _radius(LooviTokens t) => switch (widget.variant) {
        LooviTabItemVariant.primary => BorderRadius.circular(t.radius.s200),
        LooviTabItemVariant.secondary => BorderRadius.circular(t.radius.s0),
        LooviTabItemVariant.segmented => BorderRadius.circular(t.radius.full),
      };

  String _semanticLabel() {
    final tab = widget.tab;
    if (tab.semanticLabel != null) return tab.semanticLabel!;
    return tab.showAttention ? '${tab.label}, ${tab.attentionSemanticLabel}' : tab.label;
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final tab = widget.tab;
    final (fill, labelInk, iconInk) = _paint(t);
    final iconSize = t.spacing.s200;

    final Color attentionInk = tab.disabled
        ? (_inverse ? t.text.placeholderInverse : t.text.placeholder)
        : t.feedback.danger;

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (tab.showIcon) ...[
          LooviIcon(tab.leadingIcon, size: iconSize, color: iconInk),
          SizedBox(width: t.spacing.s100),
        ],
        Flexible(
          child: Text(
            tab.label,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: t.typography.bodyMediumMedium.copyWith(color: labelInk),
          ),
        ),
        if (tab.showAttention) ...[
          SizedBox(width: t.spacing.s100),
          LooviIcon(tab.attentionIcon, size: iconSize, color: attentionInk),
        ],
      ],
    );

    final radius = _radius(t);
    Widget painted;
    switch (widget.variant) {
      case LooviTabItemVariant.primary:
        painted = DecoratedBox(
          decoration: BoxDecoration(color: fill, borderRadius: radius),
          child: Padding(padding: EdgeInsets.all(t.spacing.s150), child: content),
        );
      case LooviTabItemVariant.secondary:
        painted = Padding(
          padding: EdgeInsets.only(left: t.spacing.s150, right: t.spacing.s150, top: t.spacing.s150, bottom: t.spacing.s0),
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                content,
                SizedBox(height: t.spacing.s050),
                DecoratedBox(
                  key: const Key('loovi-tab-item-indicator'),
                  decoration: BoxDecoration(
                    color: widget.selected && !tab.disabled ? t.color.actionsPrimary : null,
                    borderRadius: BorderRadius.circular(t.radius.full),
                  ),
                  child: SizedBox(height: t.spacing.s025),
                ),
              ],
            ),
          ),
        );
      case LooviTabItemVariant.segmented:
        painted = DecoratedBox(
          decoration: BoxDecoration(color: fill, borderRadius: radius),
          child: Padding(
            padding: EdgeInsets.all(t.spacing.s050),
            child: Center(widthFactor: 1, heightFactor: 1, child: content),
          ),
        );
    }

    final ring = widget.showFocusRing ?? _focusHighlight;
    if (ring && _enabled) {
      painted = DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: t.interactive.focus, width: t.borderWidth.s025),
        ),
        child: painted,
      );
    }

    return Semantics(
      container: true,
      role: SemanticsRole.tab,
      selected: widget.selected,
      enabled: _enabled,
      focusable: _enabled,
      label: _semanticLabel(),
      onTap: _enabled ? widget.onTap : null,
      child: FocusableActionDetector(
        enabled: _enabled,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onShowFocusHighlight: (v) => setState(() => _focusHighlight = v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
            if (_enabled) widget.onTap!.call();
            return null;
          }),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          excludeFromSemantics: true,
          onTap: _enabled ? widget.onTap : null,
          child: ExcludeSemantics(child: painted),
        ),
      ),
    );
  }
}
