import 'package:flutter/services.dart';
import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../generated/loovi_icon_names.g.dart';
import '../input/loovi_input.dart';
import '../input_number_trailing_payment_mark/loovi_input_number_trailing_payment_mark.dart';
import '../select_country/loovi_select_country.dart';

/// Seed `InputNumber` (Figma 3935:684) — outlined numeric / phone /
/// credit-card field. Mode app-cliente.
///
/// Composes [LooviInput] (same field frame, paint matrix
/// [LooviInputFieldColors], floating label, error icon; radius
/// `component/input/field/radius` → app-cliente `border/radius/full`) plus two
/// optional, mutually exclusive in-field blocks:
/// - `selectCountryBlock` ([showSelectCountry]) after the leading icon:
///   [LooviSelectCountry] size=sm + gap `spacing/100` + DividerVertical
///   (`border/width/012` × `spacing/300`, `color/border/2`). The floating
///   label stays at the content start, aligned with the block (Figma). Expand
///   icon: `text/primary` (default), `text/on-color` / focus `text/brand` /
///   disabled `text/on-color-disabled` (inverse). SelectCountry is disabled
///   only when the field is.
/// - `paymentMethodMarkBlock` ([showPaymentMethodMark]) before the trailing /
///   error icon: [LooviInputNumberTrailingPaymentMark] (40 × 40, decorative).
///
/// Keyboard and formatting (kept simple, product may override with
/// [keyboardType] / [inputFormatters]):
/// - [showSelectCountry] → phone keyboard, allows digits, space, `+ ( ) -`.
/// - [showPaymentMethodMark] → number keyboard, [LooviInputNumberCardFormatter]
///   (digits only, groups of 4, max 19 digits).
/// - otherwise → number keyboard, digits only.
///
/// The country list and BIN / brand detection are product logic: compose the
/// list externally on [onCountryPressed]; set [paymentMethodMark] only when
/// the brand is known.
class LooviInputNumber extends StatefulWidget {
  const LooviInputNumber({
    super.key,
    this.label = 'Número de telefone',
    this.placeholder,
    this.supportingText,
    this.showSupportingText = true,
    this.errorText,
    this.error = false,
    this.enabled = true,
    this.appearance = LooviInputAppearance.standard,
    this.leadingIcon = false,
    this.leading = LooviIcons.searchOutline,
    this.trailingIcon = false,
    this.trailing = LooviIcons.xOutline,
    this.onTrailingTap,
    this.trailingSemanticLabel,
    this.showSelectCountry = false,
    this.countryFlag,
    this.countryCode = 'BR',
    this.countryName = 'Brasil',
    this.countryExpanded = false,
    this.onCountryPressed,
    this.showPaymentMethodMark = false,
    this.paymentMethodMark,
    this.paymentMethodBrand,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.autofillHints,
    this.autofocus = false,
    this.showCursor,
  }) : assert(
         !(showSelectCountry && showPaymentMethodMark),
         'LooviInputNumber: showSelectCountry e showPaymentMethodMark são mutuamente exclusivos.',
       );

  /// Seed `label` (phone: "Número de telefone"; card: "Número do cartão").
  final String label;

  /// Seed `placeholder` (card: "0000 0000 0000 0000").
  final String? placeholder;
  final String? supportingText;
  final bool showSupportingText;

  /// Non-null = `state=error` with this message.
  final String? errorText;
  final bool error;

  /// `false` = `state=disabled`.
  final bool enabled;
  final LooviInputAppearance appearance;

  /// Seed `leadingIcon` (variant axis) + `leading` (INSTANCE_SWAP).
  final bool leadingIcon;
  final String leading;

  /// Seed `trailingIcon` (variant axis) + `trailing` (INSTANCE_SWAP,
  /// default `x-outline` = clear).
  final bool trailingIcon;
  final String trailing;
  final VoidCallback? onTrailingTap;
  final String? trailingSemanticLabel;

  /// Seed `showSelectCountry` (phone / DDI).
  final bool showSelectCountry;

  /// SelectCountry `countryFlag` (Flags asset). Null = placeholder.
  final Widget? countryFlag;
  final String countryCode;
  final String countryName;

  /// SelectCountry `expanded` (external country list open).
  final bool countryExpanded;

  /// Country trigger tap — open the external list.
  final VoidCallback? onCountryPressed;

  /// Seed `showPaymentMethodMark` (credit-card flows).
  final bool showPaymentMethodMark;

  /// Seed `paymentMethodMark` (INSTANCE_SWAP → payment-method/*).
  final Widget? paymentMethodMark;

  /// Brand for the placeholder mark while the artwork is missing.
  final LooviInputNumberTrailingPaymentMarkBrand? paymentMethodBrand;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final bool autofocus;
  final bool? showCursor;

  @override
  State<LooviInputNumber> createState() => _LooviInputNumberState();
}

class _LooviInputNumberState extends State<LooviInputNumber> {
  FocusNode? _ownFocusNode;
  FocusNode get _focusNode => widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_rebuild);
  }

  @override
  void didUpdateWidget(LooviInputNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _ownFocusNode)?.removeListener(_rebuild);
      _focusNode.addListener(_rebuild);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_rebuild);
    _ownFocusNode?.dispose();
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  TextInputType get _keyboard =>
      widget.keyboardType ?? (widget.showSelectCountry ? TextInputType.phone : TextInputType.number);

  List<TextInputFormatter> get _formatters {
    if (widget.inputFormatters != null) return widget.inputFormatters!;
    if (widget.showPaymentMethodMark) return [LooviInputNumberCardFormatter()];
    if (widget.showSelectCountry) return [FilteringTextInputFormatter.allow(RegExp(r'[0-9+() -]'))];
    return [FilteringTextInputFormatter.digitsOnly];
  }

  Iterable<String>? get _autofill =>
      widget.autofillHints ??
      (widget.showSelectCountry
          ? const [AutofillHints.telephoneNumber]
          : widget.showPaymentMethodMark
          ? const [AutofillHints.creditCardNumber]
          : null);

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final inverse = widget.appearance == LooviInputAppearance.inverse;
    final focused = widget.enabled && _focusNode.hasFocus;

    Widget? leadingAccessory;
    if (widget.showSelectCountry) {
      final Color? iconColor;
      if (!inverse) {
        iconColor = null; // SelectCountry default: text/primary | disabled text/placeholder.
      } else if (!widget.enabled) {
        iconColor = t.text.onColorDisabled;
      } else {
        iconColor = focused ? t.text.brand : t.text.onColor;
      }
      leadingAccessory = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LooviSelectCountry(
            size: LooviSelectCountrySize.sm,
            expanded: widget.countryExpanded,
            disabled: !widget.enabled,
            countryFlag: widget.countryFlag,
            countryCode: widget.countryCode,
            countryName: widget.countryName,
            onPressed: widget.onCountryPressed,
            iconColor: iconColor,
          ),
          SizedBox(width: t.spacing.s100),
          SizedBox(
            width: t.borderWidth.s012,
            height: t.spacing.s300,
            child: ColoredBox(color: t.color.border2),
          ),
        ],
      );
    }

    final Widget? trailingAccessory = widget.showPaymentMethodMark
        ? LooviInputNumberTrailingPaymentMark(
            paymentMethodMark: widget.paymentMethodMark,
            brand: widget.paymentMethodBrand,
          )
        : null;

    return LooviInput(
      label: widget.label,
      placeholder: widget.placeholder,
      supportingText: widget.supportingText,
      showSupportingText: widget.showSupportingText,
      errorText: widget.errorText,
      error: widget.error,
      enabled: widget.enabled,
      appearance: widget.appearance,
      leadingIcon: widget.leadingIcon,
      leading: widget.leading,
      trailingIcon: widget.trailingIcon,
      trailing: widget.trailing,
      onTrailingTap: widget.onTrailingTap,
      trailingSemanticLabel: widget.trailingSemanticLabel,
      leadingAccessory: leadingAccessory,
      trailingAccessory: trailingAccessory,
      controller: widget.controller,
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      keyboardType: _keyboard,
      textInputAction: widget.textInputAction,
      inputFormatters: _formatters,
      autofillHints: _autofill,
      autofocus: widget.autofocus,
      showCursor: widget.showCursor,
    );
  }
}

/// Credit-card number formatter: keeps digits only, groups them by 4 with a
/// space ("4111 1111 1111 1111") and caps at [maxDigits] (19 = longest PAN).
/// The caret is placed at the end of the formatted text.
class LooviInputNumberCardFormatter extends TextInputFormatter {
  LooviInputNumberCardFormatter({this.maxDigits = 19});

  final int maxDigits;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > maxDigits) digits = digits.substring(0, maxDigits);
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
