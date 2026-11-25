import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../slider_left_rail/loovi_slider_left_rail.dart';
import '../slider_right_rail/loovi_slider_right_rail.dart';

/// SliderRail (Figma 4073:2228) — composed Slider track: [LooviSliderRightRail]
/// (residual, full width) under [LooviSliderLeftRail] (filled, from the start
/// to [fraction], endCap at the end). Not a standalone control, handle or
/// ProgressBar.
///
/// Paint (mode app-cliente):
/// - shell: no fill (`border/radius/full` only matters for the children);
///   colors come from the rails (`color/actions/primary` filled,
///   `color/border/2` residual).
/// - height: fixed at the active endCap (`spacing/250`, 20) so the layout does
///   not jump when [active] toggles; rails are centered vertically. Figma's
///   shell hugs the 2 dp rails and lets the endCap overflow — same paint.
/// - [fraction] 0–1 (clamped) = filled width; Figma's mock splits 50 / 50
///   (both rails `flex 1`), hence the default 0.5.
///
/// Accessibility: decorative — the parent Slider owns value semantics.
class LooviSliderRail extends StatelessWidget {
  const LooviSliderRail({super.key, this.active = false, this.fraction = 0.5, this.skeleton = false});

  /// Forwarded to the nested SliderLeftRail `active` (seed exposes it).
  final bool active;

  /// Filled share of the track, 0–1.
  final double fraction;

  /// SliderSkeletonItem override: every segment in `color/border/2`.
  final bool skeleton;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ExcludeSemantics(
      child: SizedBox(
        height: t.spacing.s250,
        width: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: AlignmentDirectional.centerStart,
          children: [
            const LooviSliderRightRail(),
            FractionallySizedBox(
              key: const ValueKey('loovi-slider-fill'),
              widthFactor: fraction.clamp(0.0, 1.0),
              child: LooviSliderLeftRail(active: active, skeleton: skeleton),
            ),
          ],
        ),
      ),
    );
  }
}
