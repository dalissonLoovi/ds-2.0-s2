import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../payment_method_mark/loovi_payment_method_mark.dart';

/// Seed `ListItemLeadingPaymentMark` (Figma 4990:38559) — internal leading
/// slot of ListItem `leading=payment-mark`: a `payment-method/*` mark at the
/// canonical height `spacing/500` (40). Pass it as `LooviListItem.leading`.
///
/// The seed prop `paymentMethodMark` (INSTANCE_SWAP among payment-method/*)
/// maps to [brand] / [type] / [showBackground] (React:
/// `ListItemLeadingPaymentMark(brand, type, showBackground)`). Defaults follow
/// the Figma instance: visa, type=icon, showBackground=false. `type=icon` is
/// the recommendation for list rows (40 × 40); `type=logo` keeps h = 40 and
/// widens the slot to the lockup.
///
/// Decorative (excluded from semantics): the ListItem headline names the
/// payment method and owns the accessible label.
class LooviListItemLeadingPaymentMark extends StatelessWidget {
  const LooviListItemLeadingPaymentMark({
    super.key,
    this.brand = LooviPaymentMethodMarkBrand.visa,
    this.type = LooviPaymentMethodMarkType.icon,
    this.showBackground = false,
  });

  /// `payment-method/{brand}`.
  final LooviPaymentMethodMarkBrand brand;

  /// Mark type (icon recommended in lists).
  final LooviPaymentMethodMarkType type;

  /// Brand-coloured badge background.
  final bool showBackground;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: t.spacing.s500, minHeight: t.spacing.s500),
      child: Center(
        widthFactor: 1,
        heightFactor: 1,
        child: LooviPaymentMethodMark(brand: brand, type: type, showBackground: showBackground, decorative: true),
      ),
    );
  }
}
