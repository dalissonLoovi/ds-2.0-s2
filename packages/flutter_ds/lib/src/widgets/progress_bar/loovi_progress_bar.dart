import 'dart:ui' show SemanticsRole;

import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

/// Seed `ProgressBar.size`: md (track 16) · sm (track 8).
enum LooviProgressBarSize { md, sm }

/// ProgressBar (Figma 3653:5393) — linear, determinate progress indicator
/// for a measurable process. Not a loading spinner, slider, stepper, chart,
/// timeline, badge or divider (use LoadingSpinner for indeterminate waits,
/// StepProgressIndicator / StepperPrimary for position in a flow).
///
/// Paint (mode app-cliente):
/// - root: row, gap `spacing/100`; min height md `spacing/250` (20) · sm
///   `spacing/200` (16).
/// - track: fill `color/background-surface/2`, radius `border/radius/150`,
///   height md `spacing/200` (16) · sm `spacing/100` (8); fills the row.
/// - indicator: fill `color/actions/primary`, radius `border/radius/150`,
///   width = [progress] % of the track (Figma mocks size it by layout; the
///   seed `value` is only the label there).
/// - value (seed `showValue`, default true): md `body/medium/medium` · sm
///   `body/small/medium`, `text/primary`.
///
/// No motion: the fill jumps to the new value (no motion token exists), so
/// there is nothing to disable under reduce-motion.
///
/// Accessibility (seed): `SemanticsRole.progressBar` with min 0, max 100 and
/// value "{progress}%"; label [semanticLabel] (required meaning when
/// [showValue] is false). The visible value text is excluded (announced once).
class LooviProgressBar extends StatelessWidget {
  const LooviProgressBar({
    super.key,
    required this.progress,
    this.value,
    this.showValue = true,
    this.size = LooviProgressBarSize.md,
    this.semanticLabel = 'Progresso',
  });

  /// Numeric progress 0–100 (clamped). Drives the fill and the semantics value.
  final double progress;

  /// Seed `value`: visible label. Defaults to "{progress}%".
  final String? value;

  /// Seed `showValue` (default true).
  final bool showValue;

  final LooviProgressBarSize size;

  /// Accessible name of the progress bar.
  final String semanticLabel;

  double get _clamped => progress.clamp(0, 100).toDouble();

  /// Text shown when [showValue] is true.
  String get displayValue => value ?? '${_clamped.round()}%';

  /// Track height of [size].
  static double trackHeightFor(LooviTokens t, LooviProgressBarSize size) => switch (size) {
        LooviProgressBarSize.md => t.spacing.s200,
        LooviProgressBarSize.sm => t.spacing.s100,
      };

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final trackHeight = trackHeightFor(t, size);
    final radius = BorderRadius.circular(t.radius.s150);
    final (minHeight, textStyle) = switch (size) {
      LooviProgressBarSize.md => (t.spacing.s250, t.typography.bodyMediumMedium),
      LooviProgressBarSize.sm => (t.spacing.s200, t.typography.bodySmallMedium),
    };

    final track = ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        height: trackHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(color: t.color.backgroundSurface2, borderRadius: radius),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: FractionallySizedBox(
              key: const ValueKey('loovi-progress-indicator'),
              widthFactor: _clamped / 100,
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: t.color.actionsPrimary, borderRadius: radius),
              ),
            ),
          ),
        ),
      ),
    );

    return Semantics(
      container: true,
      role: SemanticsRole.progressBar,
      label: semanticLabel,
      value: '${_clamped.round()}%',
      minValue: '0',
      maxValue: '100',
      child: ExcludeSemantics(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: minHeight),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: track),
              if (showValue) ...[
                SizedBox(width: t.spacing.s100),
                Text(displayValue, style: textStyle.copyWith(color: t.text.primary)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
