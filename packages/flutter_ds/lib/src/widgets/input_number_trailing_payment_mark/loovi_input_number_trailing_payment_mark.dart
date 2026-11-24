import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

/// Seed `InputNumberTrailingPaymentMark.paymentMethodMark` preferred values
/// (`payment-method/{brand}`, type=icon, showBackground=false).
enum LooviInputNumberTrailingPaymentMarkBrand { visa, mastercard, elo, amex }

/// Seed `InputNumberTrailingPaymentMark` (Figma 4995:38558) — internal
/// 40 × 40 (`spacing/500`) slot for the card brand mark of InputNumber
/// (`showPaymentMethodMark`, credit-card BIN feedback). Mode app-cliente.
///
/// [paymentMethodMark] is the `payment-method/*` artwork (type=icon,
/// showBackground=false), fitted into the slot. The `[DS] Payment Method
/// Marks` assets are not in the Flutter package yet, so when it is null the
/// slot paints a token placeholder: stroke `color/border/1`
/// (`border/width/012`), radius `border/radius/200`, brand name in
/// `caption/small/medium` `text/secondary`.
///
/// Decorative (excluded from semantics): the parent InputNumber label names
/// the card field. BIN / brand detection is product logic — hide the mark
/// when the brand is unknown.
class LooviInputNumberTrailingPaymentMark extends StatelessWidget {
  const LooviInputNumberTrailingPaymentMark({super.key, this.paymentMethodMark, this.brand});

  /// Seed `paymentMethodMark` (INSTANCE_SWAP → payment-method/*).
  final Widget? paymentMethodMark;

  /// Brand shown by the placeholder when [paymentMethodMark] is null.
  final LooviInputNumberTrailingPaymentMarkBrand? brand;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final Widget child;
    if (paymentMethodMark != null) {
      child = FittedBox(fit: BoxFit.contain, child: paymentMethodMark);
    } else {
      child = DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: t.color.border1, width: t.borderWidth.s012),
          borderRadius: BorderRadius.circular(t.radius.s200),
        ),
        child: Center(
          child: brand == null
              ? null
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: t.spacing.s050),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      brand!.name.toUpperCase(),
                      maxLines: 1,
                      style: t.typography.captionSmallMedium.copyWith(color: t.text.secondary),
                    ),
                  ),
                ),
        ),
      );
    }
    return ExcludeSemantics(
      child: SizedBox.square(dimension: t.spacing.s500, child: child),
    );
  }
}
