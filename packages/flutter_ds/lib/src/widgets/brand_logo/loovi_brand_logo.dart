import 'package:flutter_svg/flutter_svg.dart';
import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

/// Seed `BrandLogo.type`. Seed `default` is a Dart keyword → [standard].
enum LooviBrandLogoType {
  /// Seed `default`: mark + Loovi wordmark (h = 40).
  standard,

  /// Mark + "Seguro inteligente" tagline lockup (h = 40).
  extended,

  /// Compact mark (h = 16).
  icon,

  /// 40 × 40 brand tile (palette/brand fill + on-color glyph).
  app,
}

/// Seed `BrandLogo` (Figma 56:6090) — Loovi brand lockup for product chrome,
/// marketing and app identity. Brand identity, not a DS icon: never use it as
/// a Button / Toast / Alert icon slot.
///
/// Artwork is the packaged Figma export (`assets/brand/brand-logo-*.svg`).
/// Fills are re-bound to tokens at parse time (seed `tokenRules`) so product
/// themes apply: `#5A78FF` → `color/palette/brand`, the white app glyph →
/// `text/on-color`.
///
/// Height: `spacing/500` (40) for standard / extended / app, `spacing/200`
/// (16) for icon; width follows the artwork aspect ratio.
///
/// Sparse matrix: `type=app × showTrademark=true` is not published — the app
/// tile ignores [showTrademark].
///
/// Accessibility: labelled [semanticLabel] (default `Loovi`); pass `null`
/// when an adjacent product/brand name is present (decorative).
class LooviBrandLogo extends StatelessWidget {
  const LooviBrandLogo({
    super.key,
    this.type = LooviBrandLogoType.standard,
    this.showTrademark = true,
    this.semanticLabel = 'Loovi',
  });

  /// Seed `type`.
  final LooviBrandLogoType type;

  /// Seed `showTrademark` (™). Ignored for [LooviBrandLogoType.app].
  final bool showTrademark;

  /// Accessible name; `null` excludes the logo from semantics.
  final String? semanticLabel;

  /// Artwork colours as exported from Figma: the app-cliente values of the
  /// bound variables (`color/palette/brand`, `text/on-color`).
  static Color get exportedBrandFill => LooviTokens.appCliente.color.paletteBrand;
  static Color get exportedOnColorFill => LooviTokens.appCliente.text.onColor;

  /// Whether `type × showTrademark` is a published Figma variant.
  static bool isPublished(LooviBrandLogoType type, bool showTrademark) =>
      !(type == LooviBrandLogoType.app && showTrademark);

  static String _slug(LooviBrandLogoType type) => type == LooviBrandLogoType.standard ? 'default' : type.name;

  /// Package asset path (`assets/brand/brand-logo-<type>[-tm].svg`).
  static String assetFor(LooviBrandLogoType type, bool showTrademark) {
    final tm = showTrademark && type != LooviBrandLogoType.app ? '-tm' : '';
    return 'assets/brand/brand-logo-${_slug(type)}$tm.svg';
  }

  /// Artwork width / height (SVG export viewBox).
  static double aspectRatioFor(LooviBrandLogoType type, bool showTrademark) {
    final tm = showTrademark && type != LooviBrandLogoType.app;
    return switch (type) {
      LooviBrandLogoType.standard => (tm ? 239 : 210) / 40,
      LooviBrandLogoType.extended => (tm ? 507 : 478) / 40,
      LooviBrandLogoType.icon => (tm ? 46 : 39) / 16,
      LooviBrandLogoType.app => 1,
    };
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final height = type == LooviBrandLogoType.icon ? t.spacing.s200 : t.spacing.s500;
    final svg = SvgPicture.asset(
      assetFor(type, showTrademark),
      package: 'loovi_ds',
      height: height,
      width: height * aspectRatioFor(type, showTrademark),
      colorMapper: LooviBrandLogoColorMapper(brand: t.color.paletteBrand, onColor: t.text.onColor),
      excludeFromSemantics: true,
    );
    final label = semanticLabel;
    if (label == null) return ExcludeSemantics(child: svg);
    return Semantics(label: label, image: true, child: svg);
  }
}

/// Re-binds the exported BrandLogo fills to the active tokens
/// (`color/palette/brand`, `text/on-color`). Value-equal so the SVG cache is
/// shared per theme.
@immutable
class LooviBrandLogoColorMapper extends ColorMapper {
  const LooviBrandLogoColorMapper({required this.brand, required this.onColor});

  final Color brand;
  final Color onColor;

  @override
  Color substitute(String? id, String elementName, String attributeName, Color color) {
    if (color.toARGB32() == LooviBrandLogo.exportedBrandFill.toARGB32()) return brand;
    if (color.toARGB32() == LooviBrandLogo.exportedOnColorFill.toARGB32()) return onColor;
    return color;
  }

  @override
  bool operator ==(Object other) => other is LooviBrandLogoColorMapper && other.brand == brand && other.onColor == onColor;

  @override
  int get hashCode => Object.hash(brand, onColor);
}
