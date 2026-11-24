import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../step_progress_segment/loovi_step_progress_segment.dart';

/// StepProgressIndicator (Figma 3809:765) — compact, non-interactive,
/// segmented position indicator for a linear flow with a known, stable total
/// of 3–8 steps. Not a percentage bar (use ProgressBar), not labeled steps
/// (use StepperPrimary / VerticalStepper), not tabs or pagination.
///
/// Step-count policy (seed): no indicator for 1–2 steps; 3–5 directly; 6–8
/// with [showCounter]; above 8 group into chapters.
///
/// Paint (mode app-cliente):
/// - root: column, gap `spacing/100` (counter → segments), height hugs.
/// - counter (seed `showCounter`, default true — Figma + React, 2026-11-24): `body/small/medium`,
///   `text/secondary`; text "Etapa {current} de {total}" ([counterText]).
/// - segments: row of [LooviStepProgressSegment], equal widths, gap
///   `spacing/100`, height `spacing/050`, radius `border/radius/full`. Steps
///   before [currentStep] are `completed`, after are `pending`; the current one
///   is `current`, or `error` when [hasError].
///
/// Accessibility (seed): segments are decorative; the root announces
/// [semanticLabel] (default = the counter text). Not a progress bar role
/// (position in a flow, not quantity). No focus.
class LooviStepProgressIndicator extends StatelessWidget {
  const LooviStepProgressIndicator({
    super.key,
    required this.stepCount,
    required this.currentStep,
    this.showCounter = true,
    this.hasError = false,
    this.counterText,
    this.semanticLabel,
  })  : assert(stepCount >= minSteps && stepCount <= maxSteps, 'stepCount must be 3..8 (seed).'),
        assert(currentStep >= 1 && currentStep <= stepCount, 'currentStep must be 1..stepCount (sparse matrix).');

  static const int minSteps = 3;
  static const int maxSteps = 8;

  /// Seed `stepCount` (3..8).
  final int stepCount;

  /// Seed `currentStep` (1..stepCount).
  final int currentStep;

  /// Seed `showCounter` (Figma default false; recommended for 6–8 steps).
  final bool showCounter;

  /// Seed `hasError`: paints the current segment `feedback/danger`. Only with
  /// an explanatory message on screen.
  final bool hasError;

  /// Localized counter override. Default "Etapa {current} de {total}".
  final String? counterText;

  /// Accessible text, e.g. "Etapa 2 de 5: Dados do veículo". Defaults to the
  /// counter text.
  final String? semanticLabel;

  static String defaultCounter(int current, int total) => 'Etapa $current de $total';

  /// Status of the 1-based [step].
  static LooviStepProgressSegmentStatus statusFor(int step, int currentStep, {bool hasError = false}) {
    if (step < currentStep) return LooviStepProgressSegmentStatus.completed;
    if (step > currentStep) return LooviStepProgressSegmentStatus.pending;
    return hasError ? LooviStepProgressSegmentStatus.error : LooviStepProgressSegmentStatus.current;
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final counter = counterText ?? defaultCounter(currentStep, stepCount);
    final segments = Row(
      children: [
        for (var step = 1; step <= stepCount; step++) ...[
          if (step > 1) SizedBox(width: t.spacing.s100),
          Expanded(child: LooviStepProgressSegment(status: statusFor(step, currentStep, hasError: hasError))),
        ],
      ],
    );
    return Semantics(
      container: true,
      label: semanticLabel ?? counter,
      child: ExcludeSemantics(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showCounter) ...[
              Text(counter, style: t.typography.bodySmallMedium.copyWith(color: t.text.secondary)),
              SizedBox(height: t.spacing.s100),
            ],
            segments,
          ],
        ),
      ),
    );
  }
}
