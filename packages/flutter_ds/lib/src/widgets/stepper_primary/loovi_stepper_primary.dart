import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../generated/loovi_icon_names.g.dart';

/// Seed `StepperPrimary.status`.
enum LooviStepperPrimaryStatus { completed, current, pending }

/// Seed `StepperPrimary.trail` — which connector sides exist.
enum LooviStepperPrimaryTrail { both, left, right }

/// Seed `StepperPrimary.trailState` — which present sides are active.
enum LooviStepperPrimaryTrailState { none, both, left, right }

/// StepperPrimary (Figma 3653:4985) — one labeled step of a horizontal
/// stepper. Place several in a Row (each `Expanded`): first `trail: right`,
/// middle `both`, last `left`. Not a Button, PaginationItem, ProgressBar or
/// TimelineItem; non-interactive.
///
/// Paint (mode app-cliente):
/// - root: column, gap `spacing/050`, centered; fills the given width.
/// - trail row: height `spacing/300`, gap `spacing/100`; connectors expand on
///   both sides of the icon, thickness `border/width/025`, radius
///   `border/radius/full`. Active = `color/actions/primary`, inactive present =
///   `color/border/2`. An absent side keeps its space (icon stays centered),
///   unpainted — as in Figma.
/// - stepIcon 24 (`spacing/300`), structural by status: circle-check-filled |
///   circle-dot-filled (`color/actions/primary`) | circle-outline
///   (`text/primary`, Figma stroke).
/// - label: `body/medium/medium`, centered. completed `color/actions/primary`
///   (4.5:1) · current `text/primary` · pending `text/secondary` — Figma uses
///   `text/placeholder` (2.4:1, below AA), deviation reported.
///
/// Sparse matrix (seed): trailState ⊆ trail; current × both publishes only
/// none|left; pending publishes only none (asserted in debug).
///
/// Accessibility (seed): label + status word ("Concluída" | "Etapa atual" |
/// "Pendente") so status is not color-only; icon and connectors decorative.
/// Wrap the row in an ordered group; the current step says "Etapa atual".
class LooviStepperPrimary extends StatelessWidget {
  const LooviStepperPrimary({
    super.key,
    required this.label,
    this.status = LooviStepperPrimaryStatus.completed,
    this.trail = LooviStepperPrimaryTrail.both,
    this.trailState = LooviStepperPrimaryTrailState.none,
    this.statusSemanticLabel,
  })  : assert(
          trailState == LooviStepperPrimaryTrailState.none ||
              trail == LooviStepperPrimaryTrail.both ||
              (trailState == LooviStepperPrimaryTrailState.left && trail == LooviStepperPrimaryTrail.left) ||
              (trailState == LooviStepperPrimaryTrailState.right && trail == LooviStepperPrimaryTrail.right),
          'trailState must be a subset of trail (seed sparse matrix).',
        ),
        assert(
          status != LooviStepperPrimaryStatus.pending || trailState == LooviStepperPrimaryTrailState.none,
          'pending publishes trailState=none only (seed sparse matrix).',
        ),
        assert(
          status != LooviStepperPrimaryStatus.current ||
              trailState == LooviStepperPrimaryTrailState.none ||
              trailState == LooviStepperPrimaryTrailState.left ||
              trail != LooviStepperPrimaryTrail.both,
          'current × trail=both publishes trailState=none|left only (seed sparse matrix).',
        );

  /// Seed `label` (visible step text).
  final String label;
  final LooviStepperPrimaryStatus status;
  final LooviStepperPrimaryTrail trail;
  final LooviStepperPrimaryTrailState trailState;

  /// Overrides the announced status word.
  final String? statusSemanticLabel;

  static String defaultStatusLabel(LooviStepperPrimaryStatus s) => switch (s) {
        LooviStepperPrimaryStatus.completed => 'Concluída',
        LooviStepperPrimaryStatus.current => 'Etapa atual',
        LooviStepperPrimaryStatus.pending => 'Pendente',
      };

  static String iconFor(LooviStepperPrimaryStatus s) => switch (s) {
        LooviStepperPrimaryStatus.completed => LooviIcons.circleCheckFilled,
        LooviStepperPrimaryStatus.current => LooviIcons.circleDotFilled,
        LooviStepperPrimaryStatus.pending => LooviIcons.circleOutline,
      };

  static Color iconColorFor(LooviTokens t, LooviStepperPrimaryStatus s) => switch (s) {
        LooviStepperPrimaryStatus.completed || LooviStepperPrimaryStatus.current => t.color.actionsPrimary,
        // Figma + seed 2026-11-24: pending icon text/secondary (AA), same as VerticalStepperItem.
        LooviStepperPrimaryStatus.pending => t.text.secondary,
      };

  static Color labelColorFor(LooviTokens t, LooviStepperPrimaryStatus s) => switch (s) {
        LooviStepperPrimaryStatus.completed => t.color.actionsPrimary,
        LooviStepperPrimaryStatus.current => t.text.primary,
        LooviStepperPrimaryStatus.pending => t.text.secondary,
      };

  bool _present(LooviStepperPrimaryTrail side) => trail == LooviStepperPrimaryTrail.both || trail == side;

  bool _active(LooviStepperPrimaryTrailState side) =>
      trailState == LooviStepperPrimaryTrailState.both || trailState == side;

  /// Connector color of a side; null = side absent (space kept, unpainted).
  Color? trailColor(LooviTokens t, {required bool left}) {
    final present = _present(left ? LooviStepperPrimaryTrail.left : LooviStepperPrimaryTrail.right);
    if (!present) return null;
    final active = _active(left ? LooviStepperPrimaryTrailState.left : LooviStepperPrimaryTrailState.right);
    return active ? t.color.actionsPrimary : t.color.border2;
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);

    Widget connector(Color? color, Key key) => Expanded(
          child: SizedBox(
            key: key,
            height: t.borderWidth.s025,
            child: color == null
                ? null
                : DecoratedBox(
                    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(t.radius.full)),
                  ),
          ),
        );

    final trailRow = SizedBox(
      height: t.spacing.s300,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          connector(trailColor(t, left: true), const ValueKey('leftTrail')),
          SizedBox(width: t.spacing.s100),
          LooviIcon(iconFor(status), size: t.spacing.s300, color: iconColorFor(t, status)),
          SizedBox(width: t.spacing.s100),
          connector(trailColor(t, left: false), const ValueKey('rightTrail')),
        ],
      ),
    );

    return Semantics(
      container: true,
      label: '$label, ${statusSemanticLabel ?? defaultStatusLabel(status)}',
      child: ExcludeSemantics(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            trailRow,
            SizedBox(height: t.spacing.s050),
            Text(
              label,
              textAlign: TextAlign.center,
              style: t.typography.bodyMediumMedium.copyWith(color: labelColorFor(t, status)),
            ),
          ],
        ),
      ),
    );
  }
}
