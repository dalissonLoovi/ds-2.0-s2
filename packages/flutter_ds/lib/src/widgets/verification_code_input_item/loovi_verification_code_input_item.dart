import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

/// Seed `VerificationCodeInputItem.state`. `hover` is not used on the app
/// (mobile); `standard` = seed `default` (reserved word in Dart).
enum LooviVerificationCodeInputItemState { standard, focus, error, disabled }

/// VerificationCodeInputItem S2 (Figma `4028:773`, mode app-cliente) —
/// single-digit cell of [LooviVerificationCodeInput]. Paint only: no
/// gestures, no text input and no semantics (the parent field owns input
/// and announces the position).
///
/// Paint (mode app-cliente):
/// - fill `color/background-surface/0`; stroke `border/width/012`.
/// - stroke: standard|disabled `color/border/1` · focus `interactive/focus`
///   · error `color/border-feedback/danger`.
/// - focus ring: outer shadow `color/elevation/focus`, spread `spacing/050`,
///   blur/offset `spacing/0` ([focusRing] adds it on top of error too).
/// - radius `border/radius/300`; padding `spacing/050` (v) · `spacing/100` (h).
/// - digit `body/large/regular`, `text/primary` (disabled `text/placeholder`).
/// - size: Figma master 56 × 48 (`spacing/700` × `spacing/600`); inside the
///   parent the cells fill the row. Height grows with the text scaler.
class LooviVerificationCodeInputItem extends StatelessWidget {
  const LooviVerificationCodeInputItem({
    super.key,
    this.digit = '',
    this.state = LooviVerificationCodeInputItemState.standard,
    this.focusRing,
    this.width,
  });

  /// Seed `digit` — the displayed character (empty = no digit yet).
  final String digit;

  final LooviVerificationCodeInputItemState state;

  /// Draws the focus ring. Defaults to `state == focus`. The parent sets it
  /// on the active cell while in error (error stroke + focus ring).
  final bool? focusRing;

  /// Fixed width. Null = Figma master width (56). The parent passes
  /// `double.infinity` so cells share the row.
  final double? width;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final ring = focusRing ?? state == LooviVerificationCodeInputItemState.focus;
    final Color stroke;
    switch (state) {
      case LooviVerificationCodeInputItemState.standard:
      case LooviVerificationCodeInputItemState.disabled:
        stroke = t.color.border1;
      case LooviVerificationCodeInputItemState.focus:
        stroke = t.interactive.focus;
      case LooviVerificationCodeInputItemState.error:
        stroke = t.color.borderFeedbackDanger;
    }
    final textColor = state == LooviVerificationCodeInputItemState.disabled ? t.text.placeholder : t.text.primary;

    return Container(
      width: width ?? t.spacing.s700,
      constraints: BoxConstraints(minHeight: t.spacing.s600),
      padding: EdgeInsets.symmetric(vertical: t.spacing.s050, horizontal: t.spacing.s100),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: t.color.backgroundSurface0,
        borderRadius: BorderRadius.circular(t.radius.s300),
        border: Border.all(color: stroke, width: t.borderWidth.s012),
        boxShadow: ring
            ? [BoxShadow(color: t.color.elevationFocus, spreadRadius: t.spacing.s050, blurRadius: t.spacing.s0)]
            : null,
      ),
      child: Text(
        digit,
        maxLines: 1,
        textAlign: TextAlign.center,
        style: t.typography.bodyLargeRegular.copyWith(color: textColor),
      ),
    );
  }
}
