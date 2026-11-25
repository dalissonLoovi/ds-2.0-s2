import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../slider_item/loovi_slider_item.dart';

/// SliderSkeletonItem (Figma 4092:4005) — loading placeholder of Slider
/// (seed `status=skeleton`). Not interactive; not the live Slider, SliderItem,
/// SliderRail or a ProgressBar.
///
/// Paint (mode app-cliente):
/// - root: column, gap `spacing/100`.
/// - labelBone: 40 × 8 (`spacing/500` × `spacing/100`).
/// - sliderRow: row, gap `spacing/100`, vertical padding `spacing/200`:
///   minValueBone 9 × 8 (frame not tokenized → `spacing/100` × `spacing/100`)
///   + [LooviSliderItem] (`active=false`, fraction 0.5, skeleton override:
///   rails + endCap `color/border/2`) + maxValueBone 16 × 8 (`spacing/200` ×
///   `spacing/100`).
/// - bones: fill `color/border/2`, radius `border/radius/100`.
///
/// Static: Figma has no shimmer and there is no motion token, so nothing
/// animates (nothing to disable under reduce-motion).
///
/// Accessibility: decorative — excluded from semantics. The parent Slider
/// announces the loading state.
class LooviSliderSkeletonItem extends StatelessWidget {
  const LooviSliderSkeletonItem({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    Widget bone(double width, String key) => SizedBox(
          key: ValueKey('loovi-slider-bone-$key'),
          width: width,
          height: t.spacing.s100,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: t.color.border2,
              borderRadius: BorderRadius.circular(t.radius.s100),
            ),
          ),
        );

    return ExcludeSemantics(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bone(t.spacing.s500, 'label'),
          SizedBox(height: t.spacing.s100),
          Padding(
            padding: EdgeInsets.symmetric(vertical: t.spacing.s200),
            child: Row(
              children: [
                bone(t.spacing.s100, 'min'),
                SizedBox(width: t.spacing.s100),
                const Expanded(child: LooviSliderItem(skeleton: true)),
                SizedBox(width: t.spacing.s100),
                bone(t.spacing.s200, 'max'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
