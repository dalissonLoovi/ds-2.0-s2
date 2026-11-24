import 'package:material_ui/material_ui.dart';

import '../list_item_leading_illustration/loovi_list_item_leading_illustration.dart';

/// Seed ListItemTrailingIllustration (Figma 5038:79) — wraps an
/// `illustration/*` asset in the 56 × 56 trailing slot of [LooviListItem]
/// (`trailing=illustration`). Same anatomy as
/// [LooviListItemLeadingIllustration].
///
/// Paint tokens (mode app-cliente):
/// - slot 56 × 56 (`spacing/700`), no fill, `border/radius/0`;
/// - artwork 52 × 52 centered (inset `spacing/025` per side), `BoxFit.contain`.
///
/// Not a trailing icon: use `LooviListItem.trailingIcon` for DS Icons.
/// Decorative by default (seed: the row headline names the entity).
class LooviListItemTrailingIllustration extends StatelessWidget {
  const LooviListItemTrailingIllustration({
    super.key,
    this.illustration = LooviListItemIllustration.sedan,
    this.artwork,
    this.semanticLabel,
  });

  /// Seed `illustration` (default `vehicle-icon/sedan`). Ignored when
  /// [artwork] is set.
  final LooviListItemIllustration illustration;

  /// Any other `illustration/*` supplied by the app (needs an intrinsic size).
  final Widget? artwork;

  /// Null = decorative.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) =>
      LooviListItemIllustrationBox(illustration: illustration, artwork: artwork, semanticLabel: semanticLabel);
}
