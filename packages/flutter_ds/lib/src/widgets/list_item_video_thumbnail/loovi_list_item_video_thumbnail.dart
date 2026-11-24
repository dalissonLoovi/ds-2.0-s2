import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../generated/loovi_icon_names.g.dart';

/// Seed ListItemVideoThumbnail (Figma 3694:16211) — compact video poster for
/// [LooviListItem.leading] with a centered play affordance.
///
/// Paint tokens (mode app-cliente):
/// - `imageSurface` height `spacing/800` (64) at 16:9 (Figma frame 114 × 64 —
///   width not tokenized, derived from the ratio), corners
///   `border/radius/100`, `color/background-surface/2` placeholder under the
///   app poster ([poster], `BoxFit.cover` = IMAGE scaleMode FILL);
/// - `playIcon` = `LooviIcon(player-play-outline)` 20 dp (`spacing/250`),
///   `text/on-color`, centered.
///
/// No bundled photos: the app passes [poster]. Not a video player — playback
/// belongs to the app.
///
/// Semantics: decorative by default (the parent row label conveys the video).
/// With [onPlay] the thumbnail becomes its own button named [semanticLabel]
/// (default "Reproduzir vídeo"); it is ≥ 48 dp in both axes (64 tall).
class LooviListItemVideoThumbnail extends StatelessWidget {
  const LooviListItemVideoThumbnail({super.key, this.poster, this.onPlay, this.semanticLabel});

  /// App-supplied poster frame. Null = placeholder only.
  final ImageProvider? poster;

  /// Optional playback action (seed React mapping `onPlay`).
  final VoidCallback? onPlay;

  /// Accessible name. Used as the button label with [onPlay]; without it,
  /// a non-null value exposes the thumbnail as an image.
  final String? semanticLabel;

  /// Poster aspect ratio (Figma 114 × 64 ≈ 16:9).
  static const double aspectRatio = 16 / 9;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final height = t.spacing.s800;
    final box = Container(
      width: height * aspectRatio,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: t.color.backgroundSurface2,
        borderRadius: BorderRadius.circular(t.radius.s100),
        image: poster == null ? null : DecorationImage(image: poster!, fit: BoxFit.cover),
      ),
      child: LooviIcon(LooviIcons.playerPlayOutline, size: t.spacing.s250, color: t.text.onColor),
    );

    if (onPlay == null) {
      if (semanticLabel == null) return ExcludeSemantics(child: box);
      return Semantics(label: semanticLabel, image: true, child: ExcludeSemantics(child: box));
    }
    return Semantics(
      button: true,
      label: semanticLabel ?? 'Reproduzir vídeo',
      onTap: onPlay,
      child: ExcludeSemantics(
        child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: onPlay, child: box),
      ),
    );
  }
}
