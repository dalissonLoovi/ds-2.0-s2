import 'package:flutter/semantics.dart' show SemanticsValidationResult;
import 'package:flutter/services.dart';
import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../verification_code_input_item/loovi_verification_code_input_item.dart';

/// VerificationCodeInput S2 (Figma `4029:835`, mode app-cliente) — OTP / 2FA
/// / PIN field made of [length] [LooviVerificationCodeInputItem] cells.
///
/// Seed `state` is runtime: `focus` = the field has focus (the active cell —
/// next empty slot, or the last one when full — paints the focus ring);
/// `error` = [error]; `disabled` = [disabled]. `hover` is not used (mobile).
///
/// Input: one invisible [TextField] covers the cells, so the system handles
/// the numeric keyboard, SMS autofill ([AutofillHints.oneTimeCode]), paste
/// from the long-press menu, auto-advance (each digit fills the next cell)
/// and backspace (clears the previous cell). Non-digits are dropped; pasting
/// or autofilling a full code replaces the current value.
///
/// Paint (mode app-cliente):
/// - root gap `spacing/100`; codeRow gap `spacing/150`; cells share the row.
/// - label `body/medium/regular`, `text/secondary` (disabled `text/placeholder`).
/// - supporting text (error only) `caption/large/regular`, `text/danger` (AA).
/// - cells: see [LooviVerificationCodeInputItem]. In error every cell keeps
///   `color/border-feedback/danger`; the focused active cell adds the ring.
///
/// Semantics: one text field named [label] with hint "Dígito k de N" (the
/// active slot), the error text prepended to the hint, and `invalid`
/// validation while [error].
class LooviVerificationCodeInput extends StatefulWidget {
  const LooviVerificationCodeInput({
    super.key,
    this.length = 5,
    this.label = 'Digite o código',
    this.showLabel = true,
    this.error = false,
    this.supportingText = 'Código inválido. Tente novamente.',
    this.showSupportingText = true,
    this.disabled = false,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.onChanged,
    this.onCompleted,
    this.semanticLabel,
    this.forceFocusRing = false,
  }) : assert(length > 0);

  /// Number of digit cells. Seed rule `fixedLength5`: the DS field has 5;
  /// other lengths only when the backend code really differs.
  final int length;

  /// Seed `label` (also the accessible name of the field).
  final String label;

  /// Seed `showLabel`.
  final bool showLabel;

  /// Seed `state=error`: every cell paints the error stroke.
  final bool error;

  /// Seed `supportingText` — shown only while [error].
  final String? supportingText;

  /// Seed `showSupportingText`.
  final bool showSupportingText;

  /// Seed `state=disabled`.
  final bool disabled;

  /// Holds the digits typed so far (≤ [length] chars).
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;

  /// Called with the current digits on every change.
  final ValueChanged<String>? onChanged;

  /// Called once all [length] digits are filled.
  final ValueChanged<String>? onCompleted;

  /// Accessible name when [showLabel] is false. Defaults to [label].
  final String? semanticLabel;

  /// Paints the active cell focus ring without real focus (seed
  /// `state=focus`). For the catalog and goldens only.
  final bool forceFocusRing;

  @override
  State<LooviVerificationCodeInput> createState() => _LooviVerificationCodeInputState();
}

class _LooviVerificationCodeInputState extends State<LooviVerificationCodeInput> {
  TextEditingController? _ownController;
  FocusNode? _ownFocusNode;

  TextEditingController get _controller => widget.controller ?? (_ownController ??= TextEditingController());
  FocusNode get _focusNode => widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onText);
    _focusNode.addListener(_onFocus);
  }

  @override
  void didUpdateWidget(LooviVerificationCodeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _ownController)?.removeListener(_onText);
      _controller.addListener(_onText);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _ownFocusNode)?.removeListener(_onFocus);
      _focusNode.addListener(_onFocus);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onText);
    _focusNode.removeListener(_onFocus);
    _ownController?.dispose();
    _ownFocusNode?.dispose();
    super.dispose();
  }

  void _onFocus() {
    if (mounted) setState(() {});
  }

  void _onText() {
    // The caret always sits after the last digit: cells fill left to right.
    final v = _controller.value;
    final end = TextSelection.collapsed(offset: v.text.length);
    if (v.selection != end) {
      _controller.value = v.copyWith(selection: end, composing: TextRange.empty);
    }
    if (mounted) setState(() {});
  }

  void _handleChanged(String value) {
    widget.onChanged?.call(value);
    if (value.length == widget.length) widget.onCompleted?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final digits = _controller.text;
    final enabled = !widget.disabled;
    final focused = enabled && (_focusNode.hasFocus || widget.forceFocusRing);
    final active = digits.length.clamp(0, widget.length - 1);
    final showSupporting =
        widget.error && widget.showSupportingText && (widget.supportingText?.isNotEmpty ?? false);

    final cells = <Widget>[];
    for (var i = 0; i < widget.length; i++) {
      if (i > 0) cells.add(SizedBox(width: t.spacing.s150));
      final LooviVerificationCodeInputItemState state;
      if (!enabled) {
        state = LooviVerificationCodeInputItemState.disabled;
      } else if (widget.error) {
        state = LooviVerificationCodeInputItemState.error;
      } else if (focused && i == active) {
        state = LooviVerificationCodeInputItemState.focus;
      } else {
        state = LooviVerificationCodeInputItemState.standard;
      }
      cells.add(Expanded(
        child: LooviVerificationCodeInputItem(
          digit: i < digits.length ? digits[i] : '',
          state: state,
          focusRing: focused && i == active,
          width: double.infinity,
        ),
      ));
    }

    // Invisible input on top of the cells: same tap / long-press (paste)
    // area as the row, no visible text, caret or selection.
    final invisible = t.color.backgroundSurface0.withValues(alpha: 0);
    final position = 'Dígito ${active + 1} de ${widget.length}';
    final field = TextSelectionTheme(
      data: TextSelectionThemeData(selectionColor: invisible, selectionHandleColor: invisible, cursorColor: invisible),
      child: Semantics(
        label: widget.semanticLabel ?? widget.label,
        hint: showSupporting ? '${widget.supportingText}. $position' : position,
        validationResult: widget.error ? SemanticsValidationResult.invalid : SemanticsValidationResult.none,
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: enabled,
          autofocus: widget.autofocus,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.oneTimeCode],
          inputFormatters: [_CodeFormatter(widget.length)],
          onChanged: _handleChanged,
          showCursor: false,
          autocorrect: false,
          enableSuggestions: false,
          expands: true,
          maxLines: null,
          style: t.typography.bodyLargeRegular.copyWith(color: invisible),
          decoration: const InputDecoration.collapsed(hintText: null),
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showLabel) ...[
          ExcludeSemantics(
            child: Text(
              widget.label,
              style: t.typography.bodyMediumRegular.copyWith(color: enabled ? t.text.secondary : t.text.placeholder),
            ),
          ),
          SizedBox(height: t.spacing.s100),
        ],
        Stack(
          children: [
            ExcludeSemantics(child: Row(children: cells)),
            Positioned.fill(child: field),
          ],
        ),
        if (showSupporting) ...[
          SizedBox(height: t.spacing.s100),
          ExcludeSemantics(
            child: Text(
              widget.supportingText!,
              style: t.typography.captionLargeRegular.copyWith(color: t.text.danger),
            ),
          ),
        ],
      ],
    );
  }
}

/// Digits only, at most [length]. A multi-character insertion (paste or SMS
/// autofill) that already holds a full code replaces the current value.
class _CodeFormatter extends TextInputFormatter {
  _CodeFormatter(this.length);

  final int length;
  static final _nonDigit = RegExp(r'\D');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final old = oldValue.text;
    var next = newValue.text.replaceAll(_nonDigit, '');
    if (newValue.text.length - old.length > 1 && newValue.text.startsWith(old)) {
      final inserted = newValue.text.substring(old.length).replaceAll(_nonDigit, '');
      if (inserted.length >= length) next = inserted;
    }
    if (next.length > length) next = next.substring(0, length);
    return TextEditingValue(text: next, selection: TextSelection.collapsed(offset: next.length));
  }
}
