import 'package:flutter_svg/flutter_svg.dart';
import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

/// DS illustrations shipped for the ListItem illustration slots (seed
/// `illustration` INSTANCE_SWAP → `illustration/*`, Figma page
/// "Ilustrações e animações" 4326:1764).
///
/// The vehicle icons reuse `assets/illustrations/vehicle/`; the others were
/// exported from Figma into `assets/illustrations/list/`. Any other catalog
/// illustration can be passed by the app through `artwork`.
enum LooviListItemIllustration {
  /// `illustration / vehicle-icon / sedan` (4468:121) — seed default.
  sedan('assets/illustrations/vehicle/sedan.svg'),

  /// `illustration / vehicle-icon / van` (4468:122).
  van('assets/illustrations/vehicle/van.svg'),

  /// `illustration / vehicle-icon / suv` (4468:123).
  suv('assets/illustrations/vehicle/suv.svg'),

  /// `illustration / object / protected-vehicle` (5191:3440).
  protectedVehicle('assets/illustrations/list/protected-vehicle.svg'),

  /// `illustration / object / unprotected-vehicle` (5125:168).
  unprotectedVehicle('assets/illustrations/list/unprotected-vehicle.svg'),

  /// `illustration / claim-reason / door-damage` (5128:174).
  doorDamage('assets/illustrations/list/door-damage.svg'),

  /// `illustration / claim-reason / theft` (5128:175).
  theft('assets/illustrations/list/theft.svg');

  const LooviListItemIllustration(this.asset);

  /// Asset path inside package `loovi_ds`.
  final String asset;
}

/// Seed ListItemLeadingIllustration (Figma 5038:10) — wraps an
/// `illustration/*` asset in the 56 × 56 leading slot of [LooviListItem]
/// (`leading=illustration`).
///
/// Paint tokens (mode app-cliente):
/// - slot 56 × 56 (`spacing/700`), no fill, `border/radius/0`;
/// - artwork 52 × 52 centered (inset `spacing/025` per side), `BoxFit.contain`.
///
/// The illustration palette is hardcoded in the asset on purpose (dedicated
/// illustration palette — not remapped to semantic tokens).
///
/// Decorative by default (seed: the row headline names the entity).
class LooviListItemLeadingIllustration extends StatelessWidget {
  const LooviListItemLeadingIllustration({
    super.key,
    this.illustration = LooviListItemIllustration.sedan,
    this.artwork,
    this.semanticLabel,
  });

  /// Seed `illustration` (default `vehicle-icon/sedan`). Ignored when
  /// [artwork] is set.
  final LooviListItemIllustration illustration;

  /// Any other `illustration/*` from the catalog, supplied by the app
  /// (e.g. an `SvgPicture` with explicit size). Scaled with `BoxFit.contain`
  /// into the 52 dp artwork box, so it needs an intrinsic size.
  final Widget? artwork;

  /// Null = decorative.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) =>
      LooviListItemIllustrationBox(illustration: illustration, artwork: artwork, semanticLabel: semanticLabel);
}

/// Shared 56 × 56 slot painting for the leading/trailing illustration parts.
/// Public so [LooviListItemTrailingIllustration] can reuse it; prefer the
/// seed-named widgets.
class LooviListItemIllustrationBox extends StatelessWidget {
  const LooviListItemIllustrationBox({super.key, required this.illustration, this.artwork, this.semanticLabel});

  final LooviListItemIllustration illustration;
  final Widget? artwork;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final art = artwork == null
        ? SvgPicture.asset(illustration.asset, package: 'loovi_ds', fit: BoxFit.contain, excludeFromSemantics: true)
        : FittedBox(fit: BoxFit.contain, child: artwork);
    final box = SizedBox(
      width: t.spacing.s700,
      height: t.spacing.s700,
      child: Padding(padding: EdgeInsets.all(t.spacing.s025), child: art),
    );
    if (semanticLabel == null) return ExcludeSemantics(child: box);
    return Semantics(label: semanticLabel, image: true, child: ExcludeSemantics(child: box));
  }
}
