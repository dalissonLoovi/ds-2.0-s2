import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

/// Seed ListItemLeadingMonogram (Figma 3694:16194) — initials-style leading
/// block for [LooviListItem.leading]. Prefer `LooviAvatar` for a real user
/// identity.
///
/// Paint tokens (mode app-cliente):
/// - 40 × 40 circle (`spacing/500`, `border/radius/full`),
///   `color/background-surface/2`;
/// - [initial] in `body/large/medium`, `text/primary` (16.6:1 on surface/2).
///
/// The initial follows the system textScaler; when a large scale no longer
/// fits the 40 dp circle it is scaled down to fit instead of clipping.
///
/// Decorative (excluded from semantics): the parent row label names the
/// entity (seed accessibility).
class LooviListItemLeadingMonogram extends StatelessWidget {
  const LooviListItemLeadingMonogram(this.initial, {super.key});

  /// Seed `initial` — visible monogram character.
  final String initial;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final size = t.spacing.s500;
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: t.color.backgroundSurface2,
          borderRadius: BorderRadius.circular(t.radius.full),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            initial,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: t.typography.bodyLargeMedium.copyWith(color: t.text.primary),
          ),
        ),
      ),
    );
  }
}
