import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import 'loovi_tooltip_anchor.dart';

export 'loovi_tooltip_anchor.dart' show LooviTooltipPlacement, LooviTooltipPlacementGeometry;

/// Tooltip (Figma 3566:10587) — simple contextual tooltip: short, purely
/// informational text tied to a trigger. No buttons, no internal focus. For
/// title/actions use [LooviTooltipRich]; long, critical or persistent content
/// belongs in a Banner, BottomSheet or Modal.
///
/// Two uses:
/// - with [child] (the trigger, e.g. an info icon): tap or long-press opens
///   the bubble in the Overlay pinned to the trigger; tap outside, Escape or a
///   second tap closes it (see [LooviTooltipAnchor]). An interactive trigger
///   keeps its own tap, so the tooltip opens on long-press.
/// - without [child]: renders only the bubble (catalog, static layouts); it
///   fills the given width like the Figma master.
///
/// Paint (mode app-cliente): [LooviTooltipSurface] (`color/background-surface/
/// inverse-3`, radius `border/radius/300`, shadow `color/elevation/6`, arrow
/// `spacing/200`×`spacing/150`) with padding `spacing/200`, gap `spacing/0`;
/// description `body/small/regular` + `text/on-color` (AA on inverse-3).
///
/// Accessibility (seed): the trigger carries the text as its semantic tooltip
/// (aria-describedby equivalent), available even when the bubble is closed;
/// the bubble and the arrow are excluded to avoid a double reading. Opening
/// never moves focus.
class LooviTooltip extends StatelessWidget {
  const LooviTooltip({
    super.key,
    required this.description,
    this.placement = LooviTooltipPlacement.topCenter,
    this.child,
    this.onOpenChange,
    this.initiallyOpen = false,
  });

  /// Seed `description` (TEXT).
  final String description;

  /// Seed `placement` (arrow edge/alignment; see [LooviTooltipPlacement]).
  final LooviTooltipPlacement placement;

  /// Trigger. Null = static bubble only.
  final Widget? child;

  final ValueChanged<bool>? onOpenChange;

  /// Shows the bubble right after the first frame (default false — mobile opens on tap).
  final bool initiallyOpen;

  @override
  Widget build(BuildContext context) {
    final trigger = child;
    if (trigger == null) return _LooviTooltipBubble(description: description, placement: placement);
    return Semantics(
      tooltip: description,
      child: LooviTooltipAnchor(
        placement: placement,
        onOpenChange: onOpenChange,
        initiallyOpen: initiallyOpen,
        overlayBuilder: (context, close) => ExcludeSemantics(
          child: _LooviTooltipBubble(description: description, placement: placement),
        ),
        child: trigger,
      ),
    );
  }
}

class _LooviTooltipBubble extends StatelessWidget {
  const _LooviTooltipBubble({required this.description, required this.placement});

  final String description;
  final LooviTooltipPlacement placement;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return LooviTooltipSurface(
      placement: placement,
      padding: EdgeInsets.all(t.spacing.s200),
      child: Text(description, style: t.typography.bodySmallRegular.copyWith(color: t.text.onColor)),
    );
  }
}
