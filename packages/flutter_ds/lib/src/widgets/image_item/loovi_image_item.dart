import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../photo_text_item/loovi_photo_text_item.dart';

/// Seed `ImageItem.aspectRatio` (`1-1 | 4-3 | 3-2 | 16-9 | 2-1`). The seed
/// values are not Dart identifiers, so `W-H` maps to `ratioWxH`. The ratio is
/// written for [LooviImageItemOrientation.landscape]; portrait swaps it.
enum LooviImageItemAspectRatio {
  ratio1x1(1, 1),
  ratio4x3(4, 3),
  ratio3x2(3, 2),
  ratio16x9(16, 9),
  ratio2x1(2, 1);

  const LooviImageItemAspectRatio(this.w, this.h);

  final int w;
  final int h;
}

/// Seed `ImageItem.orientation`.
enum LooviImageItemOrientation { portrait, landscape }

/// Seed ImageItem (Figma 3671:2329) — fixed aspect-ratio image surface with
/// optional orientation and photo-text overlays. Preferred slide content for
/// [LooviCarousel]. Not a radio, checkbox, button, tab, avatar or gallery tile
/// (no tap of its own; wrap it when the product needs one).
///
/// Sizing (seed `verticalResize`):
/// - false (default): width follows the parent (must be bounded), height =
///   width ÷ ratio;
/// - true: height follows the parent (must be bounded), width = height × ratio.
///
/// Paint tokens (mode app-cliente):
/// - root + imageSurface placeholder: `color/background-surface/1`, corners
///   `border/radius/200` (Figma; the seed does not name the radius), clipped;
/// - imageSurface: the app [image], `BoxFit.cover` (Figma scaleMode FILL);
/// - photoTextOverlay: [LooviPhotoTextItem] full-bleed ([showPhotoTextItem]);
/// - orientationOverlay (ImageOrientationItem, Figma 3671:2318 — not in the
///   seed, so it is drawn here and not published as a widget): centered,
///   padding `spacing/050`, gap `spacing/050`, corners `border/radius/200`,
///   fill `color/background-surface/0`; preview shape `spacing/250` ×
///   `spacing/200` (swapped in portrait) in `text/secondary`, corners
///   `border/radius/050`; ratio `caption/medium/medium` + `text/primary`;
///   orientation label `caption/medium/regular` + `text/secondary`.
///
/// No bundled photos: the app passes [image]; null paints the placeholder.
///
/// Semantics: an image named [semanticLabel] (alt from product content).
/// Without a label and without photo text it is decorative. The photo-text
/// label/supporting text are content and are read; the orientation overlay is
/// decorative.
class LooviImageItem extends StatelessWidget {
  const LooviImageItem({
    super.key,
    this.image,
    this.semanticLabel,
    this.aspectRatio = LooviImageItemAspectRatio.ratio1x1,
    this.orientation = LooviImageItemOrientation.landscape,
    this.verticalResize = false,
    this.showOrientationItem = false,
    this.showPhotoTextItem = false,
    this.photoTextLabel = '',
    this.photoTextSupportingText,
    this.orientationLabel,
  });

  /// App-supplied image (network, asset, memory…). Null = placeholder only.
  final ImageProvider? image;

  /// Alt text of the image. Null = decorative.
  final String? semanticLabel;

  /// Seed `aspectRatio`.
  final LooviImageItemAspectRatio aspectRatio;

  /// Seed `orientation`.
  final LooviImageItemOrientation orientation;

  /// Seed `verticalResize`: false locks width / hugs height; true locks
  /// height / hugs width.
  final bool verticalResize;

  /// Seed `showOrientationItem` (orientationOverlay).
  final bool showOrientationItem;

  /// Seed `showPhotoTextItem` (photoTextOverlay, default false).
  final bool showPhotoTextItem;

  /// photoTextOverlay `label`.
  final String photoTextLabel;

  /// photoTextOverlay `supportingText`; null = `showSupportingText=false`.
  final String? photoTextSupportingText;

  /// Orientation overlay text. Null = "Vertical" / "Horizontal" (pt-BR, Figma).
  final String? orientationLabel;

  /// Width ÷ height after applying [orientation].
  double get ratio {
    final portrait = orientation == LooviImageItemOrientation.portrait;
    final w = portrait ? aspectRatio.h : aspectRatio.w;
    final h = portrait ? aspectRatio.w : aspectRatio.h;
    return w / h;
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final radius = BorderRadius.circular(t.radius.s200);

    final surface = DecoratedBox(
      decoration: BoxDecoration(
        color: t.color.backgroundSurface1,
        image: image == null ? null : DecorationImage(image: image!, fit: BoxFit.cover),
      ),
    );

    final clipped = ClipRRect(
      borderRadius: radius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ExcludeSemantics(child: surface),
          if (showPhotoTextItem) LooviPhotoTextItem(label: photoTextLabel, supportingText: photoTextSupportingText),
          if (showOrientationItem)
            Center(
              child: ExcludeSemantics(child: _OrientationOverlay(item: this)),
            ),
        ],
      ),
    );

    final Widget item = LayoutBuilder(
      builder: (context, constraints) {
        if (verticalResize) {
          assert(constraints.hasBoundedHeight, 'ImageItem verticalResize=true needs a bounded height');
          final h = constraints.maxHeight;
          return SizedBox(width: h * ratio, height: h, child: clipped);
        }
        assert(constraints.hasBoundedWidth, 'ImageItem verticalResize=false needs a bounded width');
        final w = constraints.maxWidth;
        return SizedBox(width: w, height: w / ratio, child: clipped);
      },
    );

    if (semanticLabel == null && !showPhotoTextItem) return ExcludeSemantics(child: item);
    return Semantics(container: true, image: semanticLabel != null, label: semanticLabel, child: item);
  }
}

/// ImageOrientationItem as drawn inside ImageItem (decorative).
class _OrientationOverlay extends StatelessWidget {
  const _OrientationOverlay({required this.item});

  final LooviImageItem item;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final portrait = item.orientation == LooviImageItemOrientation.portrait;
    final ar = item.aspectRatio;
    final ratioText = portrait ? '${ar.h}:${ar.w}' : '${ar.w}:${ar.h}';
    final label = item.orientationLabel ?? (portrait ? 'Vertical' : 'Horizontal');
    final long = t.spacing.s250;
    final short = t.spacing.s200;

    return DecoratedBox(
      decoration: BoxDecoration(color: t.color.backgroundSurface0, borderRadius: BorderRadius.circular(t.radius.s200)),
      child: Padding(
        padding: EdgeInsets.all(t.spacing.s050),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: t.spacing.s400,
              child: Center(
                child: Container(
                  width: portrait ? short : long,
                  height: portrait ? long : short,
                  decoration: BoxDecoration(color: t.text.secondary, borderRadius: BorderRadius.circular(t.radius.s050)),
                ),
              ),
            ),
            SizedBox(height: t.spacing.s050),
            Padding(
              padding: EdgeInsets.all(t.spacing.s050),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(ratioText, style: t.typography.captionMediumMedium.copyWith(color: t.text.primary)),
                  SizedBox(height: t.spacing.s050),
                  Text(label, style: t.typography.captionMediumRegular.copyWith(color: t.text.secondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
