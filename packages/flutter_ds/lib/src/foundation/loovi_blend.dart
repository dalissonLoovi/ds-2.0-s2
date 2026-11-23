import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

/// Internal color helpers shared by the widgets. NOT exported from
/// `lib/loovi_ds.dart` — consumers paint with tokens, not with these.

/// Plus Darker / LINEAR_BURN of two opaque colors: `dst + src - 1` per channel.
///
/// Figma composites `interactive/pressed|selected` over a base fill with
/// LINEAR_BURN (Plus Darker). Flutter has no LINEAR_BURN BlendMode; with
/// opaque token colors the result is exact, so it is resolved here instead of
/// via a compositing layer.
Color looviPlusDarker(Color dst, Color src) => Color.from(
      alpha: dst.a,
      red: (dst.r + src.r - 1).clamp(0, 1).toDouble(),
      green: (dst.g + src.g - 1).clamp(0, 1).toDouble(),
      blue: (dst.b + src.b - 1).clamp(0, 1).toDouble(),
    );

/// Interaction state layer of a saturated fill (Button solid), seed
/// `Button.tokenRules`: "darken toward interactive/overlay (hover 8% ·
/// selected 12% · pressed 16%)". There is no opacity token, so the alphas
/// live here, once.
enum LooviStateLayer {
  hover(0.08),
  selected(0.12),
  pressed(0.16);

  const LooviStateLayer(this.opacity);

  /// Alpha of `interactive/overlay` blended over the base fill.
  final double opacity;
}

/// [base] darkened toward `interactive/overlay` by the [layer] alpha.
Color looviStateLayer(LooviTokens t, Color base, LooviStateLayer layer) =>
    Color.alphaBlend(t.interactive.overlay.withValues(alpha: layer.opacity), base);
