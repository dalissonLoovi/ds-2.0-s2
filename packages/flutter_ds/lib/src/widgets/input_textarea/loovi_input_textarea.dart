import 'package:flutter/semantics.dart' show SemanticsValidationResult;
import 'package:flutter/services.dart';
import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../generated/loovi_icon_names.g.dart';
import '../input/loovi_input.dart';

/// Seed `InputTextArea` (Figma 4052:21848) — multiline outlined text field.
///
/// Same identity as Input with a taller field (min 160), floating label in
/// `caption/large/regular`, an absolute `countRow` at the bottom-right and the
/// `InputTextAreaResizeHandle` affordance (visual only; the field grows with
/// its content). Radius `component/input-textarea/field/radius`
/// (app-cliente → `border/radius/500` = 20). Focus and error strokes use
/// `border/width/025`.
///
/// Appearance enum is shared with Input ([LooviInputAppearance]).
class LooviInputTextArea extends StatefulWidget {
  const LooviInputTextArea({
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
    this.trailing = LooviIcons.searchOutline,
    this.countText,
    this.showCount = true,
    this.maxLength,
    this.showResizeHandle = true,
    this.minLines,
    this.maxLines,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.inputFormatters,
    this.autofocus = false,
    this.showCursor,
  });

  /// Seed `label`.
  final String label;

  /// Seed `placeholder`.
  final String? placeholder;

  /// Seed `supportingText`.
  final String? supportingText;

  /// Seed `showSupportingText`.
  final bool showSupportingText;

  /// Error message; non-null = `state=error`, replaces [supportingText].
  final String? errorText;

  /// Seed `state=error` without a message.
  final bool error;

  /// `false` = seed `state=disabled`.
  final bool enabled;

  /// Seed `appearance`.
  final LooviInputAppearance appearance;

  /// Seed `leadingIcon` / `leading` (decorative). Figma binds both textarea
  /// icons to `text/primary` in every published state (4052:21698 error,
  /// 4052:21723 error, 4052:21658 focus); inverse uses `text/on-color`.
  final bool leadingIcon;
  final String leading;

  /// Seed `trailingIcon` / `trailing` (decorative; default `search-outline`
  /// as in the Figma samples).
  final bool trailingIcon;
  final String trailing;

  /// Seed `countText`. Null + [maxLength] = `length/maxLength`.
  final String? countText;

  /// Seed `showCount`.
  final bool showCount;

  /// Hard limit (enforced) used to build the default count.
  final int? maxLength;

  /// Seed `showResizeHandle` (nested InputTextAreaMinHeight).
  final bool showResizeHandle;

  /// Text lines; null [maxLines] = grows without limit.
  final int? minLines;
  final int? maxLines;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final bool? showCursor;

  @override
  State<LooviInputTextArea> createState() => _LooviInputTextAreaState();
}

class _LooviInputTextAreaState extends State<LooviInputTextArea> {
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
  void didUpdateWidget(LooviInputTextArea oldWidget) {
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

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final scaler = MediaQuery.textScalerOf(context);
    final hasError = widget.error || widget.errorText != null;
    final focused = widget.enabled && _focusNode.hasFocus;
    final c = LooviInputFieldColors.resolve(
      t,
      appearance: widget.appearance,
      focused: focused,
      error: hasError,
      enabled: widget.enabled,
    );
    final hasText = _controller.text.isNotEmpty;
    final floated = focused || hasText || (widget.placeholder ?? '').isNotEmpty;

    final valueStyle = t.typography.bodyLargeRegular;
    final captionStyle = t.typography.captionLargeRegular;
    final captionHeight = scaler.scale(captionStyle.fontSize!) * captionStyle.height!;
    final iconSize = t.spacing.s250;
    final gap = t.spacing.s100;

    final count = widget.countText ??
        (widget.maxLength != null ? '${_controller.text.characters.length}/${widget.maxLength}' : null);
    final showCount = widget.showCount && (count ?? '').isNotEmpty;

    final supporting = widget.errorText ?? widget.supportingText;
    final showSupporting = widget.showSupportingText && (supporting ?? '').isNotEmpty;
    final hint = [if (showSupporting) supporting!, if (showCount) count!].join(', ');

    // countRow / resize glyph: text/secondary (disabled text/placeholder) on
    // light fields; on inverse the same on-color pair as the supporting text
    // (text/secondary on inverse-3 would be ~1.5:1).
    final inverse = widget.appearance == LooviInputAppearance.inverse;
    final metaColor = inverse
        ? (widget.enabled ? t.text.onColorDisabled : t.text.placeholderInverse)
        : (widget.enabled ? t.text.secondary : t.text.placeholder);

    final textField = TextField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      onChanged: widget.onChanged,
      inputFormatters: [
        ...?widget.inputFormatters,
        if (widget.maxLength != null) LengthLimitingTextInputFormatter(widget.maxLength),
      ],
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
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

    // countRow sits in the bottom padding (bottom spacing/100, right
    // spacing/300); keep the text clear of it when the content grows.
    final bottomPadding = showCount
        ? (t.spacing.s100 + captionHeight).clamp(t.spacing.s200, double.infinity)
        : t.spacing.s200;

    final field = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.enabled ? _focusNode.requestFocus : null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.fill,
          border: Border.all(color: c.border, width: c.borderWidth),
          borderRadius: BorderRadius.circular(t.component.inputTextarea.fieldRadius),
        ),
        child: ConstrainedBox(
          // Field frame height 160 has no variable: spacing/1000 × 2.
          constraints: BoxConstraints(minHeight: t.spacing.s1000 * 2, minWidth: double.infinity),
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              start: t.spacing.s300,
              end: t.spacing.s300,
              top: t.spacing.s200,
              bottom: bottomPadding.toDouble(),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.leadingIcon) ...[
                  LooviIcon(widget.leading, size: iconSize, color: c.trailingIcon),
                  SizedBox(width: gap),
                ],
                Expanded(
                  child: Semantics(
                    label: widget.label,
                    hint: hint.isEmpty ? null : hint,
                    validationResult: hasError ? SemanticsValidationResult.invalid : SemanticsValidationResult.none,
                    child: textField,
                  ),
                ),
                if (widget.trailingIcon) ...[
                  SizedBox(width: gap),
                  LooviIcon(widget.trailing, size: iconSize, color: c.trailingIcon),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          // Root paddingTop spacing/150 hosts the floating label overflow.
          padding: EdgeInsets.only(top: t.spacing.s150),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              field,
              if (showCount)
                PositionedDirectional(
                  end: t.spacing.s300,
                  bottom: t.spacing.s100,
                  child: ExcludeSemantics(
                    child: Text(count!, maxLines: 1, style: captionStyle.copyWith(color: inverse ? metaColor : t.text.secondary)),
                  ),
                ),
              if (widget.showResizeHandle)
                PositionedDirectional(
                  end: t.spacing.s100,
                  bottom: t.spacing.s100,
                  child: _ResizeHandle(color: metaColor),
                ),
              if (floated && widget.label.isNotEmpty)
                PositionedDirectional(
                  top: c.borderWidth / 2 - captionHeight / 2,
                  start: t.spacing.s300 - t.spacing.s050,
                  end: t.spacing.s300,
                  child: LooviInputFloatingLabel(
                    text: widget.label,
                    style: captionStyle.copyWith(color: c.label),
                    cutout: c.cutout,
                  ),
                ),
            ],
          ),
        ),
        if (showSupporting)
          ExcludeSemantics(
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: t.spacing.s200, end: t.spacing.s200, top: t.spacing.s050),
              child: Text(supporting!, style: captionStyle.copyWith(color: c.supporting)),
            ),
          ),
      ],
    );
  }
}

/// `InputTextAreaResizeHandle` (4045:278): 8×8 root (`spacing/100`) with a
/// 7×7 two-stroke glyph, stroke `border/width/012`, `text/secondary`
/// (disabled `text/placeholder`). Visual affordance only.
class _ResizeHandle extends StatelessWidget {
  const _ResizeHandle({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final size = t.spacing.s100;
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size.square(size),
        painter: _ResizeGlyphPainter(color: color, stroke: t.borderWidth.s012),
      ),
    );
  }
}

class _ResizeGlyphPainter extends CustomPainter {
  _ResizeGlyphPainter({required this.color, required this.stroke});

  final Color color;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    // Glyph box = 7/8 of the root, anchored bottom-right.
    final g = size.width * 7 / 8;
    final o = Offset(size.width - g, size.height - g);
    canvas.drawLine(o + Offset(0, g), o + Offset(g, 0), paint);
    canvas.drawLine(o + Offset(g / 2, g), o + Offset(g, g / 2), paint);
  }

  @override
  bool shouldRepaint(_ResizeGlyphPainter old) => old.color != color || old.stroke != stroke;
}
