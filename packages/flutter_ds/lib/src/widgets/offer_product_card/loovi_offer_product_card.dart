import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../generated/loovi_icon_names.g.dart';
import '../button/loovi_button.dart';

/// OfferProductCard (Figma 4227:418) — add-on product offer card for
/// Home/Painel carousels. The horizontal carousel is a screen pattern: the
/// parent sets the card width (Figma demo frame 232).
///
/// Paint (mode app-cliente, seed tokenRules):
/// - root `color/background-surface/2`, radius `border/radius/500`, padding
///   `spacing/250`, gap `spacing/150`.
/// - iconContainer: `spacing/400` (32) circle (`border/radius/full`) in
///   `color/background-surface/3`; [icon] 20 (`spacing/250`) stroke
///   `text/brand`. The Figma frame has unbound padding 3.2 / radius 7999.2;
///   the container is a fixed 32 box with the 20 icon centered, so the
///   padding does not change layout and is not emitted.
/// - text (gap `spacing/100`): [title] body/medium/semi-bold `text/primary`;
///   [description] body/small/regular `text/secondary`.
/// - priceRow (bottom-aligned): [price] heading/h3/semi-bold + [pricePeriod]
///   body/small/regular, both `text/primary`.
/// - cta: [LooviButton] solid/sm/primary, full width.
///
/// Accessibility: title + description + price are one semantics node (title
/// first = offer name); the CTA is the primary action and its own button.
class LooviOfferProductCard extends StatelessWidget {
  const LooviOfferProductCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    this.pricePeriod = '/mês',
    this.icon = LooviIcons.packageOutline,
    required this.ctaLabel,
    required this.onCtaPressed,
    this.ctaSemanticLabel,
  });

  /// Seed `title`.
  final String title;

  /// Seed `description`.
  final String description;

  /// Seed `price` (already formatted by the product, e.g. "R$ 0,00").
  final String price;

  /// Seed `pricePeriod` (default "/mês").
  final String pricePeriod;

  /// Seed `icon` (INSTANCE_SWAP) — DS contract name, default
  /// [LooviIcons.packageOutline].
  final String icon;

  /// Seed `cta` label (nested Button).
  final String ctaLabel;

  /// CTA callback (React `onAdd`). Null = CTA disabled.
  final VoidCallback? onCtaPressed;

  /// Accessible name for the CTA (e.g. "Contratar <title>"). Defaults to
  /// [ctaLabel].
  final String? ctaSemanticLabel;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);

    final iconContainer = ExcludeSemantics(
      child: Container(
        width: t.spacing.s400,
        height: t.spacing.s400,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: t.color.backgroundSurface3, borderRadius: BorderRadius.circular(t.radius.full)),
        child: LooviIcon(icon, size: t.spacing.s250, color: t.text.brand),
      ),
    );

    final info = MergeSemantics(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: t.typography.bodyMediumSemiBold.copyWith(color: t.text.primary)),
          SizedBox(height: t.spacing.s100),
          Text(description, style: t.typography.bodySmallRegular.copyWith(color: t.text.secondary)),
          SizedBox(height: t.spacing.s150),
          Text.rich(
            TextSpan(children: [
              TextSpan(text: price, style: t.typography.headingH3SemiBold.copyWith(color: t.text.primary)),
              TextSpan(text: pricePeriod, style: t.typography.bodySmallRegular.copyWith(color: t.text.primary)),
            ]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    return Semantics(
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(color: t.color.backgroundSurface2, borderRadius: BorderRadius.circular(t.radius.s500)),
        child: Padding(
          padding: EdgeInsets.all(t.spacing.s250),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              iconContainer,
              SizedBox(height: t.spacing.s150),
              info,
              SizedBox(height: t.spacing.s150),
              LooviButton(
                label: ctaLabel,
                onPressed: onCtaPressed,
                size: LooviButtonSize.sm,
                fullWidth: true,
                semanticLabel: ctaSemanticLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
