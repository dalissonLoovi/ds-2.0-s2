import 'package:flutter_svg/flutter_svg.dart';
import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

/// Seed `PaymentMethodMark.brand` — one value per `payment-method/{brand}`
/// component set of `[DS] Payment Method Marks` (file f7HDa2A0uqtcVEOJ1YhPx6,
/// frame 7:18). camelCase of the kebab-case slug; [slug] keeps the original.
enum LooviPaymentMethodMarkBrand {
  alelo('alelo', 'Alelo'),
  amazonPay('amazon-pay', 'Amazon Pay', hasLogo: true),
  amex('amex', 'American Express', hasLogo: true),
  applePay('apple-pay', 'Apple Pay'),
  ben('ben', 'Ben'),
  bitcoin('bitcoin', 'Bitcoin', hasLogo: true),
  bitcoinCash('bitcoin-cash', 'Bitcoin Cash', hasLogo: true),
  cartaoLuiza('cartao-luiza', 'Cartão Luiza'),
  dinersClub('diners-club', 'Diners Club', hasLogo: true),
  elo('elo', 'Elo'),
  googlePay('google-pay', 'Google Pay'),
  hiper('hiper', 'Hiper'),
  hipercard('hipercard', 'Hipercard'),
  ifoodBeneficios('ifood-beneficios', 'iFood Benefícios'),
  mastercard('mastercard', 'Mastercard', hasLogo: true),
  paypal('paypal', 'PayPal', hasLogo: true),
  pix('pix', 'Pix', hasLogo: true),
  pluxee('pluxee', 'Pluxee', hasLogo: true),
  samsungPay('samsung-pay', 'Samsung Pay', hasLogo: true),
  shopeePay('shopee-pay', 'ShopeePay', hasLogo: true),
  sodexo('sodexo', 'Sodexo'),
  ticket('ticket', 'Ticket'),
  verdeCard('verde-card', 'Verdecard'),
  visa('visa', 'Visa'),
  vr('vr', 'VR');

  const LooviPaymentMethodMarkBrand(this.slug, this.displayName, {this.hasLogo = false});

  /// Figma / seed slug (`payment-method/{slug}`), also the asset file prefix.
  final String slug;

  /// Accessible brand name (Semantics label when the mark is not decorative).
  final String displayName;

  /// Whether the brand publishes `type=logo` (always with showBackground=false).
  /// Every brand publishes `type=icon` × showBackground true/false.
  final bool hasLogo;
}

/// Seed `PaymentMethodMark.type`.
enum LooviPaymentMethodMarkType {
  /// Horizontal lockup, h = 40, proportional width (86 × 40 artwork).
  logo,

  /// 40 × 40 badge.
  icon,
}

/// Seed `PaymentMethodMark` (Figma `[DS] Payment Method Marks` 7:18) —
/// third-party payment network / wallet brand mark. Not a DS icon and not
/// `BrandLogo`: the artwork is the brand's trademark, so its fills are fixed
/// (packaged SVG, no token remap — seed `tokenRules: []`).
///
/// Canonical height `spacing/500` (40). [type] `icon` paints the 40 × 40
/// badge; `logo` the 86 × 40 lockup. [showBackground] = brand-coloured 40 × 40
/// badge fill on the root (icon only).
///
/// Sparse matrix (seed `rules.sparseMatrix`): `type=logo` exists only for
/// brands with [LooviPaymentMethodMarkBrand.hasLogo] and only with
/// showBackground=false. Unpublished combinations fall back to the icon:
/// * logo of a brand without logo → icon (same [showBackground]);
/// * logo + showBackground → icon with background (the badge form).
/// [resolvedType] tells what is painted.
///
/// Accessibility: labelled with [LooviPaymentMethodMarkBrand.displayName];
/// set [decorative] when an adjacent label already names the method.
class LooviPaymentMethodMark extends StatelessWidget {
  const LooviPaymentMethodMark({
    super.key,
    required this.brand,
    this.type = LooviPaymentMethodMarkType.icon,
    this.showBackground = false,
    this.decorative = false,
  });

  /// Seed `brand` (`payment-method/{brand}`).
  final LooviPaymentMethodMarkBrand brand;

  /// Seed `type` (logo | icon).
  final LooviPaymentMethodMarkType type;

  /// Seed `showBackground`.
  final bool showBackground;

  /// Excludes the mark from semantics (adjacent text names the method).
  final bool decorative;

  /// Logo artwork aspect ratio (published logo variants are 86 × 40).
  static const double logoAspectRatio = 86 / 40;

  /// Whether `brand × type × showBackground` is a published Figma variant.
  static bool isPublished(LooviPaymentMethodMarkBrand brand, LooviPaymentMethodMarkType type, bool showBackground) =>
      type == LooviPaymentMethodMarkType.icon || (brand.hasLogo && !showBackground);

  /// Type actually painted after the sparse-matrix fallback.
  LooviPaymentMethodMarkType get resolvedType =>
      isPublished(brand, type, showBackground) ? type : LooviPaymentMethodMarkType.icon;

  /// Package asset path (`assets/payment_marks/<slug>-<type>[-bg].svg`).
  static String assetFor(LooviPaymentMethodMarkBrand brand, LooviPaymentMethodMarkType type, bool showBackground) {
    final t = isPublished(brand, type, showBackground) ? type : LooviPaymentMethodMarkType.icon;
    final bg = t == LooviPaymentMethodMarkType.icon && showBackground ? '-bg' : '';
    return 'assets/payment_marks/${brand.slug}-${t.name}$bg.svg';
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final height = t.spacing.s500;
    final width = resolvedType == LooviPaymentMethodMarkType.logo ? height * logoAspectRatio : height;
    final svg = SvgPicture.asset(
      assetFor(brand, type, showBackground),
      package: 'loovi_ds',
      width: width,
      height: height,
      excludeFromSemantics: true,
    );
    if (decorative) return ExcludeSemantics(child: svg);
    return Semantics(label: brand.displayName, image: true, child: svg);
  }
}
