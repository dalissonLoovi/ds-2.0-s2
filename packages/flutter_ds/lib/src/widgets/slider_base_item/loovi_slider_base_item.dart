import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

/// SliderBaseItem (Figma 3950:7416) — INTERNAL labeled row that composes
/// [LooviSlider]: label + sliderRow (railRow: minValue + SliderItem +
/// maxValue, then the numeric Input). Not a standalone page control: it only
/// lays out the slots; value, gestures and semantics belong to the parent
/// Slider, which passes the interactive track as [sliderItem] and the
/// numeric `LooviInput` as [input] (seed: both exposed as nested overrides).
///
/// Paint (mode app-cliente):
/// - root: column, gap `spacing/100`.
/// - label: `caption/large/regular` (Figma text style; React uses 12 px),
///   `text/secondary`.
/// - sliderRow: row, gap `spacing/200`; railRow and Input share the width
///   1:1 (Figma: both `flex 1`), centered on the Input field (the railRow is
///   pushed down by the half floating label the Input reserves above its
///   stroke, see [inputLabelReserve]).
/// - railRow: gap `spacing/100`; minValue / maxValue `body/medium/regular`,
///   `text/primary`.
/// - [disabled]: label and min/max in `text/placeholder` (Figma's disabled
///   frame uses a legacy `text/text-disabled` + IBM Plex style; mapped to the
///   S2 disabled text token used by Input).
///
/// Accessibility: label / min / max texts are excluded from semantics — the
/// parent Slider exposes them as its label and value range.
class LooviSliderBaseItem extends StatelessWidget {
  const LooviSliderBaseItem({
    super.key,
    this.label = 'Label',
    this.minValue = '0',
    this.maxValue = '100',
    required this.sliderItem,
    this.input,
    this.disabled = false,
  });

  /// Seed `label` — field label above the track.
  final String label;

  /// Seed `minValue` — label at the rail start.
  final String minValue;

  /// Seed `maxValue` — label at the rail end.
  final String maxValue;

  /// Seed exposed nested `sliderItem` — the track cell (a [LooviSliderItem],
  /// wrapped by the Slider in its gesture / semantics layer).
  final Widget sliderItem;

  /// Seed exposed nested `input` — numeric `LooviInput` (content=value, no
  /// icons, appearance=default). Null hides the Input column.
  final Widget? input;

  /// Disabled text colors (state mapped by the parent Slider).
  final bool disabled;

  /// Space a `LooviInput` reserves above its stroke for the floating label
  /// (half of the `body/small/regular` line, scaled by the textScaler).
  static double inputLabelReserve(BuildContext context) {
    final t = LooviTokens.of(context);
    final style = t.typography.bodySmallRegular;
    return MediaQuery.textScalerOf(context).scale(style.fontSize!) * style.height! / 2;
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final labelColor = disabled ? t.text.placeholder : t.text.secondary;
    final boundColor = disabled ? t.text.placeholder : t.text.primary;
    final boundStyle = t.typography.bodyMediumRegular.copyWith(color: boundColor);

    final railRow = Row(
      children: [
        ExcludeSemantics(child: Text(minValue, style: boundStyle)),
        SizedBox(width: t.spacing.s100),
        Expanded(child: sliderItem),
        SizedBox(width: t.spacing.s100),
        ExcludeSemantics(child: Text(maxValue, style: boundStyle, textAlign: TextAlign.end)),
      ],
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExcludeSemantics(
          child: Text(label, style: t.typography.captionLargeRegular.copyWith(color: labelColor)),
        ),
        SizedBox(height: t.spacing.s100),
        if (input == null)
          railRow
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: inputLabelReserve(context)),
                  child: railRow,
                ),
              ),
              SizedBox(width: t.spacing.s200),
              Expanded(child: input!),
            ],
          ),
      ],
    );
  }
}
