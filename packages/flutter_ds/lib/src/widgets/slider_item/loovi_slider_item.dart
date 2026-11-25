import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../slider_rail/loovi_slider_rail.dart';

/// SliderItem (Figma 4073:2232) — Slider track cell: middle tick mark +
/// nested [LooviSliderRail]. Compose only inside Slider / SliderSkeletonItem;
/// not a standalone control, handle, ProgressBar or free-standing bar.
///
/// Paint (mode app-cliente):
/// - middleIndicator: `spacing/025` × `spacing/025` square, fill
///   `color/border/2`, horizontally centered, sitting above the rail with the
///   seed's 1 dp optical pad (`border/width/012`; frame not tokenized).
///   It paints under the rail / endCap (Figma layer order: tick first), so
///   the endCap hides it when the value sits at the middle.
/// - rail: [LooviSliderRail] (`active` → nested SliderLeftRail.active:
///   endCap 14 when false, 20 when true).
/// - shell: no fill; height = the rail (`spacing/250`).
///
/// Accessibility: decorative — the parent Slider owns value semantics.
class LooviSliderItem extends StatelessWidget {
  const LooviSliderItem({super.key, this.active = false, this.fraction = 0.5, this.skeleton = false});

  /// Seed `active` (false | true).
  final bool active;

  /// Filled share of the track, 0–1 (Figma mock: 0.5).
  final double fraction;

  /// SliderSkeletonItem override (rails + endCap in `color/border/2`).
  final bool skeleton;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final tick = t.spacing.s025;
    // Rail line top = (rail box − line) / 2; the tick ends 1 dp above it.
    final tickTop = (t.spacing.s250 - t.spacing.s025) / 2 - t.borderWidth.s012 - tick;
    return ExcludeSemantics(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Stack sizes to the rail (only non-positioned child); the tick is
          // listed first so the rail and endCap paint over it.
          Positioned(
            top: tickTop,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                key: const ValueKey('loovi-slider-middle-indicator'),
                width: tick,
                height: tick,
                child: ColoredBox(color: t.color.border2),
              ),
            ),
          ),
          LooviSliderRail(active: active, fraction: fraction, skeleton: skeleton),
        ],
      ),
    );
  }
}
