import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

/// Seed ListItemImageThumbnail (Figma 3694:16209) — compact photo thumbnail
/// for [LooviListItem.leading].
///
/// Paint tokens (mode app-cliente):
/// - 56 × 56 `imageSurface` (`spacing/700`), corners `border/radius/100`;
/// - `color/background-surface/2` placeholder under the app image
///   ([image], `BoxFit.cover` = Figma IMAGE scaleMode FILL).
///
/// No bundled photos: the app passes [image]. Null paints the placeholder.
/// Decorative unless [semanticLabel] is given (seed: alt from the parent row
/// when informative).
class LooviListItemImageThumbnail extends StatelessWidget {
  const LooviListItemImageThumbnail({super.key, this.image, this.semanticLabel});

  /// App-supplied image (network, asset, memory…). Null = placeholder only.
  final ImageProvider? image;

  /// Alt text when the image is informative. Null = decorative.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final size = t.spacing.s700;
    final box = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: t.color.backgroundSurface2,
        borderRadius: BorderRadius.circular(t.radius.s100),
        image: image == null ? null : DecorationImage(image: image!, fit: BoxFit.cover),
      ),
    );
    if (semanticLabel == null) return ExcludeSemantics(child: box);
    return Semantics(label: semanticLabel, image: true, child: box);
  }
}
