import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

/// SliderLeftRail (Figma 4073:2214) — filled (start) segment of a Slider track
/// with the endCap (thumb) at its end. Building block of [LooviSliderRail];
/// not a standalone control, ProgressBar or free-standing track.
///
/// Paint (mode app-cliente):
/// - rail: fill `color/actions/primary`, radius `border/radius/full`, height
///   `spacing/025`; width = parent constraint (the parent sizes it to the
///   value fraction).
/// - endCap: circle `color/actions/primary` (`border/radius/full`), centered
///   on the rail end and overflowing the 2 dp rail (seed circle-overflow).
///   Seed `active=false` → 14 × 14 (no token of that value: drawn as
///   `spacing/150` + `spacing/025`); `active=true` → 20 × 20 (`spacing/250`).
///   [active] is the only visual difference (same fill on both values).
/// - [skeleton]: rail + endCap in `color/border/2` (SliderSkeletonItem
///   nested override; seed: "no active primary appears in skeleton").
///
/// The widget is as tall as its endCap; the endCap paints half of its width
/// past the trailing edge (the track tip stays continuous in SliderRail).
///
/// Accessibility: decorative — excluded from semantics.
class LooviSliderLeftRail extends StatelessWidget {
  const LooviSliderLeftRail({super.key, this.active = false, this.skeleton = false});

  /// Seed `active` — endCap 14 (false) or 20 (true).
  final bool active;

  /// Paints in `color/border/2` (SliderSkeletonItem override). Not a seed
  /// prop of this component — it mirrors the nested override in Figma.
  final bool skeleton;

  /// endCap diameter for [active].
  static double endCapSizeFor(LooviTokens t, {required bool active}) =>
      active ? t.spacing.s250 : t.spacing.s150 + t.spacing.s025;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final color = skeleton ? t.color.border2 : t.color.actionsPrimary;
    final cap = endCapSizeFor(t, active: active);
    final radius = BorderRadius.circular(t.radius.full);
    return ExcludeSemantics(
      child: SizedBox(
        height: cap,
        width: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: AlignmentDirectional.centerStart,
          children: [
            SizedBox(
              key: const ValueKey('loovi-slider-left-rail-line'),
              height: t.spacing.s025,
              width: double.infinity,
              child: DecoratedBox(decoration: BoxDecoration(color: color, borderRadius: radius)),
            ),
            PositionedDirectional(
              end: -cap / 2,
              top: 0,
              width: cap,
              height: cap,
              child: DecoratedBox(
                key: const ValueKey('loovi-slider-end-cap'),
                decoration: BoxDecoration(color: color, borderRadius: radius),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
