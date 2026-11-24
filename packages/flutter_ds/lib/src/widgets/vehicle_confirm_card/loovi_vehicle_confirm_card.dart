import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

/// VehicleConfirmCard (Figma 4360:444) — onboarding vehicle confirmation:
/// plate as the hero identifier + brand/model under a brand topo bar with a
/// centered (decorative) handle. No illustration (use
/// `LooviVehicleSummaryCard` when vehicle art is needed). The confirm CTA
/// lives on the screen, not in the card.
///
/// Paint (mode app-cliente):
/// - root `color/background-surface/1`, radius `border/radius/400`, clipped;
///   stroke `color/elevation/disabled` at `border/width/025`, inside. The
///   token already carries 32 % alpha; the Figma frame adds a second 32 %
///   paint opacity (≈ 10 % net) — the token wins (reported).
/// - padding bottom `spacing/200` (others `spacing/0`).
/// - topo: fill `color/background-surface/brand`, padding top `spacing/150`
///   / bottom `spacing/100`; handle `spacing/500` × `spacing/050` (Figma
///   43 × 4, width not tokenized), `color/elevation/inverse-4` (token alpha;
///   same double-opacity note), radius `border/radius/full`.
/// - text: horizontal padding `spacing/250`; [plate] heading/h1/semi-bold
///   `text/primary`; [brandModel] body/medium/regular `text/secondary`.
///
/// Width comes from the parent (Figma demo 342); height hugs.
///
/// Semantics: one static node "plate, brandModel" (React mapping has no
/// press handler; the confirm action is a separate control on the screen).
class LooviVehicleConfirmCard extends StatelessWidget {
  const LooviVehicleConfirmCard({
    super.key,
    this.plate = 'ABC1D23',
    this.brandModel = 'Brand Model',
    this.semanticLabel,
  });

  /// Seed `plate`.
  final String plate;

  /// Seed `brandModel`.
  final String brandModel;

  /// Overrides the accessible name (default "plate, brandModel").
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final radius = BorderRadius.circular(t.radius.s400);

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ColoredBox(
          color: t.color.backgroundSurfaceBrand,
          child: Padding(
            padding: EdgeInsets.only(top: t.spacing.s150, bottom: t.spacing.s100),
            child: Center(
              child: Container(
                width: t.spacing.s500,
                height: t.spacing.s050,
                decoration: BoxDecoration(
                  color: t.color.elevationInverse4,
                  borderRadius: BorderRadius.circular(t.radius.full),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: t.spacing.s250, right: t.spacing.s250, bottom: t.spacing.s200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(plate, style: t.typography.headingH1SemiBold.copyWith(color: t.text.primary)),
              Text(brandModel, style: t.typography.bodyMediumRegular.copyWith(color: t.text.secondary)),
            ],
          ),
        ),
      ],
    );

    final card = DecoratedBox(
      decoration: BoxDecoration(color: t.color.backgroundSurface1, borderRadius: radius),
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: t.color.elevationDisabled, width: t.borderWidth.s025),
        ),
        child: ClipRRect(borderRadius: radius, child: content),
      ),
    );

    return Semantics(
      container: true,
      label: semanticLabel ?? '$plate, $brandModel',
      child: ExcludeSemantics(child: card),
    );
  }
}
