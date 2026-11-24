import 'package:material_ui/material_ui.dart';

import '../card_item/loovi_card_item_surface.dart';

/// CardElevatedItem (Figma 4170:4564) — elevated Card surface building block (state
/// shell). Content is composed by the parent Card over this surface; use it
/// standalone only for a custom card composition.
///
/// Paint (mode app-cliente):
/// - surface `color/background-surface/1`, radius `border/radius/300`, no
///   outline; resting shadow `effects/elevation/1` (`color/elevation/6`,
///   y `spacing/100`, blur `spacing/100` — Figma frame; the seed text says
///   `color/elevation/2`, reported).
/// - stateLayer padding `spacing/100` ([padding] overrides it).
/// - pressed (runtime touch, only with [onPressed]): `interactive/pressed`
///   composited Plus Darker over the surface (content stays on top).
/// - dragged ([dragged]): stateLayer `interactive/selected` + shadow
///   `effects/elevation/2` (`color/elevation/5`, y `spacing/200`, blur
///   `spacing/300`).
/// - focus (keyboard focus-visible, only with [onPressed]): outside ring
///   `color/actions/primary` at `border/width/025` when [showFocusIndicator].
/// - no hover (mobile app), no disabled (belongs to the parent Card/actions).
///
/// Semantics: a container; a button named [semanticLabel] when [onPressed]
/// is set.
class LooviCardElevatedItem extends StatelessWidget {
  const LooviCardElevatedItem({
    super.key,
    this.child,
    this.padding,
    this.onPressed,
    this.dragged = false,
    this.showFocusIndicator = true,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
  });

  /// Content composed over the surface (clipped to `border/radius/300`).
  final Widget? child;

  /// Null = stateLayer padding `spacing/100`.
  final EdgeInsetsGeometry? padding;

  /// Makes the surface pressable (pressed + focus states). Null = static.
  final VoidCallback? onPressed;

  /// Seed `state=dragged` — set by the product while the card is dragged.
  final bool dragged;

  /// Seed `showFocusIndicator` (default true).
  final bool showFocusIndicator;

  /// Accessible name when pressable.
  final String? semanticLabel;

  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) => LooviCardItemSurface(
        kind: LooviCardItemKind.elevated,
        padding: padding,
        onPressed: onPressed,
        dragged: dragged,
        showFocusIndicator: showFocusIndicator,
        semanticLabel: semanticLabel,
        focusNode: focusNode,
        autofocus: autofocus,
        child: child,
      );
}
