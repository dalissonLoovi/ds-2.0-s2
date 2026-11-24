import '../../foundation/loovi_blend.dart';
import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

/// Seed `StepProgressSegment.status`.
enum LooviStepProgressSegmentStatus { completed, current, pending, error }

/// StepProgressSegment (Figma 3807:31) — INTERNAL segment of
/// [LooviStepProgressIndicator]; not a standalone product component.
///
/// Paint (mode app-cliente): `segmentSurface` fills the box with radius
/// `border/radius/full`, height `spacing/050` (4, set by the parent track).
/// - completed: `color/actions/primary` + `interactive/selected` Plus Darker (darker blue)
/// - current: `color/actions/primary` (most prominent)
/// - pending: `color/background-surface/2` (not "disabled")
/// - error: `feedback/danger` (only with a real validation message nearby)
///
/// Accessibility (seed): decorative, non-interactive, no focus; the parent
/// owns the step text.
class LooviStepProgressSegment extends StatelessWidget {
  const LooviStepProgressSegment({super.key, this.status = LooviStepProgressSegmentStatus.completed});

  /// Seed `status` (Figma default `completed`).
  final LooviStepProgressSegmentStatus status;

  static Color colorFor(LooviTokens t, LooviStepProgressSegmentStatus s) => switch (s) {
        // Figma: actions/primary + interactive/selected with LINEAR_BURN (Plus Darker) → darker blue.
        LooviStepProgressSegmentStatus.completed => looviPlusDarker(t.color.actionsPrimary, t.interactive.selected),
        LooviStepProgressSegmentStatus.current => t.color.actionsPrimary,
        LooviStepProgressSegmentStatus.pending => t.color.backgroundSurface2,
        LooviStepProgressSegmentStatus.error => t.feedback.danger,
      };

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ExcludeSemantics(
      child: SizedBox(
        height: t.spacing.s050,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorFor(t, status),
            borderRadius: BorderRadius.circular(t.radius.full),
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}
