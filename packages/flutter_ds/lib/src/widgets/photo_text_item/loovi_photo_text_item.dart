import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

/// Scrim alphas of `interactive/overlay` (#474747). There is no opacity
/// token, so they live here, once (same approach as `LooviStateLayer`).
///
/// - [ramp]: full-bleed Figma ramp — transparent from the top to 40 %, then
///   up to this alpha at the bottom (Figma draws rgba(0,0,0,0.5); the seed
///   names `interactive/overlay`).
/// - [backing]: band behind the text. White text needs ≥ 73 % of
///   `interactive/overlay` over a white photo to reach 4.5:1, so the band
///   guarantees AA whatever the photo is (the ramp alone does not: white on
///   the ramp over the `background-surface/1` placeholder is ≈ 2.6:1).
abstract final class LooviPhotoTextScrim {
  static const double ramp = 0.5;
  static const double backing = 0.75;
}

/// Seed PhotoTextItem (Figma 4149:479) — INTERNAL full-bleed text scrim
/// overlay used inside [LooviImageItem] (and photo compositions). Not a
/// standalone card.
///
/// Fills its parent (STRETCH/STRETCH): put it in a `Stack` with
/// `Positioned.fill`, or let [LooviImageItem] do it (`showPhotoTextItem`).
///
/// Paint tokens (mode app-cliente):
/// - scrim: `interactive/overlay` alpha ramp, bottom-weighted (stops 0 / 40 %
///   / 100 %), plus a backing band (`spacing/400` fade + solid) behind the
///   text so `text/on-color` stays AA on any photo (see [LooviPhotoTextScrim]);
/// - content: bottom-aligned column, padding `spacing/200`, gap `spacing/050`;
/// - [label]: `body/medium/medium` + `text/on-color`;
/// - [supportingText]: `body/small/regular` + `text/on-color`.
///
/// Seed `showSupportingText` = [supportingText] != null.
///
/// Semantics: the texts are content and are read as plain text; the scrim is
/// decorative.
class LooviPhotoTextItem extends StatelessWidget {
  const LooviPhotoTextItem({super.key, required this.label, this.supportingText});

  /// Seed `label` (TEXT).
  final String label;

  /// Seed `supportingText` (TEXT). Null = seed `showSupportingText=false`.
  final String? supportingText;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final overlay = t.interactive.overlay;
    final band = overlay.withValues(alpha: LooviPhotoTextScrim.backing);

    final content = Padding(
      padding: EdgeInsets.all(t.spacing.s200),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label, style: t.typography.bodyMediumMedium.copyWith(color: t.text.onColor)),
          if (supportingText != null) ...[
            SizedBox(height: t.spacing.s050),
            Text(supportingText!, style: t.typography.bodySmallRegular.copyWith(color: t.text.onColor)),
          ],
        ],
      ),
    );

    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          ExcludeSemantics(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0, 0.4, 1],
                  colors: [
                    overlay.withValues(alpha: 0),
                    overlay.withValues(alpha: 0),
                    overlay.withValues(alpha: LooviPhotoTextScrim.ramp),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: t.spacing.s400,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [band.withValues(alpha: 0), band],
                      ),
                    ),
                  ),
                ),
                ColoredBox(color: band, child: content),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
