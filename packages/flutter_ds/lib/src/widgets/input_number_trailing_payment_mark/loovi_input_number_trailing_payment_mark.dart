import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../payment_method_mark/loovi_payment_method_mark.dart';

/// Seed `InputNumberTrailingPaymentMark.paymentMethodMark` preferred values
/// (`payment-method/{brand}`, type=icon, showBackground=false).
enum LooviInputNumberTrailingPaymentMarkBrand {
  visa(LooviPaymentMethodMarkBrand.visa),
  mastercard(LooviPaymentMethodMarkBrand.mastercard),
  elo(LooviPaymentMethodMarkBrand.elo),
  amex(LooviPaymentMethodMarkBrand.amex);

  const LooviInputNumberTrailingPaymentMarkBrand(this.paymentMethodMarkBrand);

  /// The full `payment-method/*` brand painted by [LooviPaymentMethodMark].
  final LooviPaymentMethodMarkBrand paymentMethodMarkBrand;
}

/// Seed `InputNumberTrailingPaymentMark` (Figma 4995:38558) — internal
/// 40 × 40 (`spacing/500`) slot for the card brand mark of InputNumber
/// (`showPaymentMethodMark`, credit-card BIN feedback). Mode app-cliente.
///
/// [brand] paints the `[DS] Payment Method Marks` artwork through
/// [LooviPaymentMethodMark] (type=icon, showBackground=false).
/// [paymentMethodMark] overrides it with any widget (fitted into the slot,
/// e.g. a [LooviPaymentMethodMark] of a brand outside the preferred values).
/// With neither, the slot paints an empty token placeholder: stroke
/// `color/border/1` (`border/width/012`), radius `border/radius/200`.
///
/// Decorative (excluded from semantics): the parent InputNumber label names
/// the card field. BIN / brand detection is product logic — hide the mark
/// when the brand is unknown.
class LooviInputNumberTrailingPaymentMark extends StatelessWidget {
  const LooviInputNumberTrailingPaymentMark({super.key, this.paymentMethodMark, this.brand});

  /// Seed `paymentMethodMark` (INSTANCE_SWAP → payment-method/*).
  final Widget? paymentMethodMark;

  /// Preferred brand painted when [paymentMethodMark] is null.
  final LooviInputNumberTrailingPaymentMarkBrand? brand;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final Widget child;
    if (paymentMethodMark != null) {
      child = FittedBox(fit: BoxFit.contain, child: paymentMethodMark);
    } else if (brand != null) {
      child = LooviPaymentMethodMark(brand: brand!.paymentMethodMarkBrand, decorative: true);
    } else {
      child = DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: t.color.border1, width: t.borderWidth.s012),
          borderRadius: BorderRadius.circular(t.radius.s200),
        ),
      );
    }
    return ExcludeSemantics(
      child: SizedBox.square(dimension: t.spacing.s500, child: child),
    );
  }
}
