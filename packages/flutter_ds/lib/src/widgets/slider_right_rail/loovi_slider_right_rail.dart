import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

/// SliderRightRail (Figma 4073:2224) — residual (unfilled) segment of a Slider
/// track. Building block of [LooviSliderRail]; not a standalone control,
/// handle, ProgressBar or free-standing bar.
///
/// Paint (mode app-cliente):
/// - rail: fill `color/border/2`, radius `border/radius/full`, height
///   `spacing/025` (fixed). Width = parent constraint (fills the track).
///   The Figma spacers (railLeadSpacer / railTrailSpacer, gap `spacing/250`)
///   are 0.001 wide and paint nothing, so they are not rebuilt.
///
/// Accessibility: decorative — excluded from semantics (the parent Slider
/// owns value and interaction).
class LooviSliderRightRail extends StatelessWidget {
  const LooviSliderRightRail({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ExcludeSemantics(
      child: SizedBox(
        height: t.spacing.s025,
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: t.color.border2,
            borderRadius: BorderRadius.circular(t.radius.full),
          ),
        ),
      ),
    );
  }
}
