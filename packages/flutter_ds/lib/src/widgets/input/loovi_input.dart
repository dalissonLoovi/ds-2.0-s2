import 'package:flutter/semantics.dart' show SemanticsValidationResult;
import 'package:flutter/services.dart';
import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../foundation/loovi_tap_target.dart';
import '../../generated/loovi_icon_names.g.dart';

/// Seed `Input.appearance` (also used by InputPassword / InputTextArea).
///
/// The seed value `default` is a reserved word in Dart, so it maps to
/// [standard].
enum LooviInputAppearance {
  /// Seed `default` — light surfaces: fill `color/background-surface/0`,
  /// border `color/border/1`.
  standard,

  /// Seed `inverse` — dark / on-color surfaces: transparent field,
  /// border `color/border/2`, cutout `color/background-surface/inverse-3`.
  inverse,
}

/// Seed `Input.content` — derived at runtime, never passed in:
/// [value] when the field has text, [placeholder] when empty with a
/// placeholder, [label] when empty without placeholder (resting label).
/// A focused field always floats the label (Figma `state=focus, content=label`).
enum LooviInputContent { value, placeholder, label }

/// Paint of the outlined field family (Input, InputPassword, InputTextArea)
/// for one runtime state, resolved only from semantic tokens.
///
/// Shared by the three widgets of the family; not meant for product code.
@immutable
class LooviInputFieldColors {
  const LooviInputFieldColors._({
    required this.fill,
    required this.border,
    required this.borderWidth,
    required this.cutout,
    required this.label,
    required this.value,
    required this.placeholder,
    required this.leadingIcon,
    required this.trailingIcon,
    required this.errorIcon,
    required this.supporting,
    required this.caret,
  });

  /// Resolves the seed matrix `state × appearance` (hover does not exist on
  /// the app). Precedence: disabled > error > focus > default.
  factory LooviInputFieldColors.resolve(
    LooviTokens t, {
    required LooviInputAppearance appearance,
    required bool focused,
    required bool error,
    required bool enabled,
  }) {
    final inverse = appearance == LooviInputAppearance.inverse;
    final isError = enabled && error;
    final isFocus = enabled && !isError && focused;
    final transparent = t.color.backgroundSurface0.withValues(alpha: 0);

    final Color border;
    if (isError) {
      border = t.color.borderFeedbackDanger;
    } else if (isFocus) {
      border = t.interactive.focus;
    } else {
      border = inverse ? t.color.border2 : t.color.border1;
    }

    final Color label;
    final Color icon;
    if (!enabled) {
      label = inverse ? t.text.placeholderInverse : t.text.placeholder;
      icon = inverse ? t.text.onColorDisabled : t.text.placeholder;
    } else if (isError) {
      // Label text → text/danger (AA); leading icon sits next to it → feedback/danger.
      label = t.text.danger;
      icon = t.feedback.danger;
    } else if (isFocus) {
      label = t.text.brand;
      icon = t.text.brand;
    } else {
      label = inverse ? t.text.onColor : t.text.secondary;
      icon = inverse ? t.text.onColor : t.text.secondary;
    }

    return LooviInputFieldColors._(
      fill: (inverse || !enabled) ? transparent : t.color.backgroundSurface0,
      border: border,
      borderWidth: (isError || isFocus) ? t.borderWidth.s025 : t.borderWidth.s012,
      cutout: inverse ? t.color.backgroundSurfaceInverse3 : t.color.backgroundSurface0,
      label: label,
      value: enabled
          ? (inverse ? t.text.onColor : t.text.primary)
          : (inverse ? t.text.placeholderInverse : t.text.placeholder),
      placeholder: inverse
          ? (enabled ? t.text.onColorDisabled : t.text.placeholderInverse)
          : t.text.placeholder,
      leadingIcon: icon,
      // Figma binds trailingIcon (x-outline) to text/primary in every state of
      // appearance=default (3872:349, 3872:685, 3872:1021). Inverse keeps the
      // seed rule (text/on-color) because text/primary is invisible there.
      trailingIcon: inverse ? (enabled ? t.text.onColor : t.text.onColorDisabled) : t.text.primary,
      // Error icon always sits next to the supporting message → feedback/danger.
      errorIcon: t.feedback.danger,
      // Figma disabled supporting stays text/secondary (3872:1024).
      supporting: isError
          ? t.text.danger
          : inverse
              ? (enabled ? t.text.onColorDisabled : t.text.placeholderInverse)
              : t.text.secondary,
      caret: t.interactive.focus,
    );
  }

  final Color fill;
  final Color border;
  final double borderWidth;

  /// Floating-label cutout (paints over the stroke behind the label).
  final Color cutout;
  final Color label;
  final Color value;
  final Color placeholder;
  final Color leadingIcon;
  final Color trailingIcon;
  final Color errorIcon;
  final Color supporting;
  final Color caret;
}

/// Seed `Input` (Figma 3873:334) — single-line outlined text field.
///
/// Outlined container (min height 56 = `spacing/700`, radius
/// `component/input/field/radius` → app-cliente `border/radius/full`),
/// floating label cut into the stroke when the field has text, a placeholder
/// or focus; resting in-field label otherwise. `state=error` always shows
/// `alert-circle-outline` (replacing the trailing icon). Hover does not exist
/// on the app; focus is the real focus of the field.
///
/// The widget reserves half of the floating label height above the stroke so
/// the label never overlaps the widget above; the painted field is the Figma
/// frame.
class LooviInput extends StatefulWidget {
  const LooviInput({
    super.key,
    this.label = 'Label',
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
    this.trailingAction,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.autofillHints,
    this.autofocus = false,
    this.obscureText = false,
    this.showCursor,
  });

  /// Seed `label` — floating (value/placeholder/focus) or resting label.
  final String label;

  /// Seed `placeholder` — shown when empty; floats the label.
  final String? placeholder;

  /// Seed `supportingText` — helper message below the field.
  final String? supportingText;

  /// Seed `showSupportingText`.
  final bool showSupportingText;

  /// Error message. Non-null puts the field in `state=error` and replaces
  /// [supportingText].
  final String? errorText;

  /// Seed `state=error` without a message (uses [supportingText] if any).
  final bool error;

  /// `false` = seed `state=disabled` (not editable, not focusable).
  final bool enabled;

  /// Seed `appearance`.
  final LooviInputAppearance appearance;

  /// Seed `leadingIcon` (variant axis).
  final bool leadingIcon;

  /// Seed `leading` (INSTANCE_SWAP) — DS icon name, default `search-outline`.
  final String leading;

  /// Seed `trailingIcon` (variant axis).
  final bool trailingIcon;

  /// Seed `trailing` (INSTANCE_SWAP) — DS icon name, default `x-outline`.
  final String trailing;

  /// Tap on the trailing icon. Null + default `x-outline` = clear the text.
  final VoidCallback? onTrailingTap;

  /// Accessible name of the trailing action (default `Limpar` for clear).
  final String? trailingSemanticLabel;

  /// Extra trailing control after the error icon (InputPassword composes the
  /// `visibilityAction` here). Must provide its own semantics and tap target.
  final Widget? trailingAction;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final bool autofocus;

  /// Masks the value (used by InputPassword).
  final bool obscureText;

  /// Forwarded to [TextField.showCursor] (goldens turn it off).
  final bool? showCursor;

  bool get _hasError => error || errorText != null;

  @override
  State<LooviInput> createState() => _LooviInputState();
}

class _LooviInputState extends State<LooviInput> {
  TextEditingController? _ownController;
  FocusNode? _ownFocusNode;

  TextEditingController get _controller => widget.controller ?? (_ownController ??= TextEditingController());
  FocusNode get _focusNode => widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _controller.addListener(_rebuild);
    _focusNode.addListener(_rebuild);
  }

  @override
  void didUpdateWidget(LooviInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _ownController)?.removeListener(_rebuild);
      _controller.addListener(_rebuild);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _ownFocusNode)?.removeListener(_rebuild);
      _focusNode.addListener(_rebuild);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_rebuild);
    _focusNode.removeListener(_rebuild);
    _ownController?.dispose();
    _ownFocusNode?.dispose();
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  bool get _isClear => widget.onTrailingTap == null && widget.trailing == LooviIcons.xOutline;

  void _onTrailingTap() {
    if (widget.onTrailingTap != null) {
      widget.onTrailingTap!();
      return;
    }
    if (_isClear) {
      _controller.clear();
      widget.onChanged?.call('');
    }
  }

  LooviInputContent get _content {
    if (_controller.text.isNotEmpty) return LooviInputContent.value;
    if ((widget.placeholder ?? '').isNotEmpty) return LooviInputContent.placeholder;
    return LooviInputContent.label;
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final scaler = MediaQuery.textScalerOf(context);
    final focused = widget.enabled && _focusNode.hasFocus;
    final hasError = widget._hasError;
    final c = LooviInputFieldColors.resolve(
      t,
      appearance: widget.appearance,
      focused: focused,
      error: hasError,
      enabled: widget.enabled,
    );
    final content = _content;
    final floated = focused || content != LooviInputContent.label;

    final valueStyle = t.typography.bodyLargeRegular;
    final labelStyle = t.typography.bodySmallRegular.copyWith(color: c.label);
    final labelHalf = scaler.scale(labelStyle.fontSize!) * labelStyle.height! / 2;

    final iconSize = t.spacing.s250;
    final gap = t.spacing.s100;
    // Interactive 20 dp icons get a 48 dp target; the extra area is taken from
    // the field padding / gap so the icon paints exactly where Figma puts it.
    final tapInset = (LooviTapTarget.minSize(context) - iconSize) / 2;

    final trailingTappable = !hasError && widget.trailingIcon && (widget.onTrailingTap != null || _isClear);

    final textField = TextField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      autofillHints: widget.autofillHints,
      obscureText: widget.obscureText,
      obscuringCharacter: '•',
      showCursor: widget.showCursor,
      style: valueStyle.copyWith(color: c.value),
      cursorColor: c.caret,
      cursorWidth: t.borderWidth.s025,
      cursorHeight: scaler.scale(t.spacing.s200),
      cursorRadius: Radius.circular(t.borderWidth.s012),
      decoration: InputDecoration.collapsed(
        hintText: floated ? widget.placeholder : widget.label,
        hintStyle: valueStyle.copyWith(color: floated ? c.placeholder : c.label),
      ),
    );

    final supporting = widget.errorText ?? widget.supportingText;
    final showSupporting = widget.showSupportingText && (supporting ?? '').isNotEmpty;

    final row = <Widget>[
      if (widget.leadingIcon) ...[
        LooviIcon(widget.leading, size: iconSize, color: c.leadingIcon),
        SizedBox(width: gap),
      ],
      Expanded(
        child: Semantics(
          label: widget.label,
          hint: showSupporting ? supporting : null,
          validationResult: hasError ? SemanticsValidationResult.invalid : SemanticsValidationResult.none,
          child: textField,
        ),
      ),
      if (hasError) ...[
        SizedBox(width: gap),
        LooviIcon(LooviIcons.alertCircleOutline, size: iconSize, color: c.errorIcon),
      ] else if (widget.trailingIcon) ...[
        if (trailingTappable) ...[
          SizedBox(width: (gap - tapInset).clamp(0, gap)),
          Semantics(
            button: true,
            enabled: widget.enabled,
            label: widget.trailingSemanticLabel ?? (_isClear ? 'Limpar' : null),
            excludeSemantics: true,
            onTap: widget.enabled ? _onTrailingTap : null,
            child: LooviTapTarget(
              enabled: widget.enabled,
              onTap: _onTrailingTap,
              child: LooviIcon(widget.trailing, size: iconSize, color: c.trailingIcon),
            ),
          ),
        ] else ...[
          SizedBox(width: gap),
          LooviIcon(widget.trailing, size: iconSize, color: c.trailingIcon),
        ],
      ],
      if (widget.trailingAction != null) ...[
        SizedBox(width: gap),
        widget.trailingAction!,
      ],
    ];

    final endPadding = (trailingTappable && widget.trailingAction == null)
        ? (t.spacing.s300 - tapInset).clamp(0.0, t.spacing.s300)
        : t.spacing.s300;

    final field = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.enabled ? _focusNode.requestFocus : null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.fill,
          border: Border.all(color: c.border, width: c.borderWidth),
          borderRadius: BorderRadius.circular(t.component.input.fieldRadius),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: t.spacing.s700, minWidth: double.infinity),
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              start: t.spacing.s300,
              end: endPadding.toDouble(),
              top: t.spacing.s050,
              bottom: t.spacing.s050,
            ),
            child: Row(children: row),
          ),
        ),
      ),
    );

    // Floating label sits on the content column (after leadingIcon + gap),
    // padded by spacing/050 on the cutout (Figma floatingLabel left -4).
    final labelStart = t.spacing.s300 + (widget.leadingIcon ? iconSize + gap : 0) - t.spacing.s050;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(padding: EdgeInsets.only(top: labelHalf), child: field),
            if (floated && widget.label.isNotEmpty)
              PositionedDirectional(
                top: c.borderWidth / 2,
                start: labelStart,
                end: t.spacing.s300,
                child: LooviInputFloatingLabel(text: widget.label, style: labelStyle, cutout: c.cutout),
              ),
          ],
        ),
        if (showSupporting)
          ExcludeSemantics(
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: t.spacing.s200, end: t.spacing.s200, top: t.spacing.s050),
              child: Text(supporting!, style: t.typography.bodySmallRegular.copyWith(color: c.supporting)),
            ),
          ),
      ],
    );
  }
}

/// Floating label with its cutout over the stroke (`floatingLabel` layer:
/// horizontal padding `spacing/050`, fill = field cutout color). Shared by the
/// outlined field family; decorative for semantics (the field carries the
/// label).
class LooviInputFloatingLabel extends StatelessWidget {
  const LooviInputFloatingLabel({super.key, required this.text, required this.style, required this.cutout});

  final String text;
  final TextStyle style;
  final Color cutout;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return IgnorePointer(
      child: ExcludeSemantics(
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: DecoratedBox(
            decoration: BoxDecoration(color: cutout),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: t.spacing.s050),
              child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: style),
            ),
          ),
        ),
      ),
    );
  }
}
