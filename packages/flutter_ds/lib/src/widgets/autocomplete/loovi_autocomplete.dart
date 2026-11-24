import 'package:flutter/services.dart';
import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../foundation/loovi_tap_target.dart';
import '../../generated/loovi_icon_names.g.dart';
import '../input/loovi_input.dart';
import '../loading_spinner/loovi_loading_spinner.dart';

/// Seed `Autocomplete.content` — derived at runtime, never passed in:
/// [empty] (no text), [selected] (text equals `selectedValue`), [query]
/// (anything else typed).
enum LooviAutocompleteContent { empty, query, selected }

/// Seed `Autocomplete` (Figma 3918:573) — editable single-select combobox:
/// type a query, filter a known option set, confirm one option. Mode
/// app-cliente.
///
/// Composes [LooviInput] (field frame, paint matrix [LooviInputFieldColors],
/// floating / resting label, error `alert-circle-outline`; radius
/// `component/input/field/radius` → app-cliente full). Trailing anatomy, in
/// Figma order:
/// - statusAction: `loadingIndicator` (LoadingSpinner, 20 = `spacing/250`)
///   when [loading] (takes precedence over clear), else `clearAction`
///   (Button text sm: 40 = `spacing/500` box, `x-outline` 16 =
///   `spacing/200`, `text/primary` / inverse `text/on-color`) when
///   [showClearAction] and there is text (never when disabled — Figma), else
///   the error `validationIcon`.
/// - expandIcon 20 (`spacing/250`, same as the other field icons; Figma aligned 2026-11-24): `chevron-down-outline` /
///   `chevron-up-outline` ([expanded]); `text/secondary`, focus `text/brand`,
///   disabled `text/placeholder`; inverse `text/on-color` (focus
///   `text/brand`, disabled `text/on-color-disabled`). Error keeps the
///   neutral color (only leading + validation turn `feedback/danger`).
///
/// Placeholder shows only on focus + empty; unfocused empty shows the
/// resting label. Error label / message use `text/danger` (AA, seed
/// feedbackColorRule).
///
/// The option list (ListActionDropdown) is never nested: the screen composes
/// it below the field while [expanded] is true and calls
/// [onExpandedChange]. Disabled is never expanded (sparse matrix). Typing
/// asks to expand ([onExpandedChange] true).
///
/// Semantics: container with the expanded state around the labelled text
/// field; the expand icon is a named button ("Mostrar / Ocultar opções").
/// `SemanticsRole.comboBox` is not used: Flutter 3.50 asserts "Missing
/// checks for role SemanticsRole.comboBox" (role not implemented yet).
class LooviAutocomplete extends StatefulWidget {
  const LooviAutocomplete({
    super.key,
    this.label = 'Veículo',
    this.placeholder = 'Digite para buscar',
    this.selectedValue,
    this.supportingText,
    this.showSupportingText = true,
    this.errorText,
    this.error = false,
    this.enabled = true,
    this.appearance = LooviInputAppearance.standard,
    this.showLeadingIcon = true,
    this.leadingIcon = LooviIcons.searchOutline,
    this.showClearAction = true,
    this.loading = false,
    this.expanded = false,
    this.onExpandedChange,
    this.onClear,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.inputFormatters,
    this.autofocus = false,
    this.showCursor,
    this.clearSemanticLabel = 'Limpar',
    this.expandSemanticLabel = 'Mostrar opções',
    this.collapseSemanticLabel = 'Ocultar opções',
    this.loadingSemanticLabel = 'Carregando',
  });

  /// Seed `label`.
  final String label;

  /// Seed `placeholder` — visible on focus + empty.
  final String? placeholder;

  /// Seed `selectedValue` — the confirmed option. When it changes the field
  /// text is set to it (content=selected). Seed `query` is the controller
  /// text while it differs from this value.
  final String? selectedValue;

  final String? supportingText;
  final bool showSupportingText;
  final String? errorText;
  final bool error;
  final bool enabled;
  final LooviInputAppearance appearance;

  /// Seed `showLeadingIcon` + `leadingIcon` (INSTANCE_SWAP).
  final bool showLeadingIcon;
  final String leadingIcon;

  /// Seed `showClearAction`.
  final bool showClearAction;

  /// Seed `loading` — LoadingSpinner replaces the clear action.
  final bool loading;

  /// Seed `expanded` — external option list open.
  final bool expanded;
  final ValueChanged<bool>? onExpandedChange;

  /// Called after the clear action empties the field.
  final VoidCallback? onClear;

  final TextEditingController? controller;
  final FocusNode? focusNode;

  /// Query changes (seed `query`).
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final bool? showCursor;

  final String clearSemanticLabel;
  final String expandSemanticLabel;
  final String collapseSemanticLabel;
  final String loadingSemanticLabel;

  bool get _hasError => error || errorText != null;

  @override
  State<LooviAutocomplete> createState() => _LooviAutocompleteState();
}

class _LooviAutocompleteState extends State<LooviAutocomplete> {
  TextEditingController? _ownController;
  FocusNode? _ownFocusNode;

  TextEditingController get _controller => widget.controller ?? (_ownController ??= TextEditingController());
  FocusNode get _focusNode => widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    if (widget.selectedValue != null && _controller.text.isEmpty) _controller.text = widget.selectedValue!;
    _controller.addListener(_rebuild);
    _focusNode.addListener(_rebuild);
  }

  @override
  void didUpdateWidget(LooviAutocomplete oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _ownController)?.removeListener(_rebuild);
      _controller.addListener(_rebuild);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _ownFocusNode)?.removeListener(_rebuild);
      _focusNode.addListener(_rebuild);
    }
    if (widget.selectedValue != oldWidget.selectedValue && widget.selectedValue != null) {
      _controller.value = TextEditingValue(
        text: widget.selectedValue!,
        selection: TextSelection.collapsed(offset: widget.selectedValue!.length),
      );
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

  LooviAutocompleteContent get _content {
    final text = _controller.text;
    if (text.isEmpty) return LooviAutocompleteContent.empty;
    if (widget.selectedValue != null && text == widget.selectedValue) return LooviAutocompleteContent.selected;
    return LooviAutocompleteContent.query;
  }

  bool get _expanded => widget.enabled && widget.expanded;

  void _onChanged(String value) {
    widget.onChanged?.call(value);
    if (!_expanded && value.isNotEmpty) widget.onExpandedChange?.call(true);
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  void _toggle() => widget.onExpandedChange?.call(!_expanded);

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final inverse = widget.appearance == LooviInputAppearance.inverse;
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
    final tapInset = (LooviTapTarget.minSize(context) - t.spacing.s250) / 2;
    final rtl = Directionality.of(context) == TextDirection.rtl;

    Widget? status;
    if (widget.loading) {
      status = SizedBox.square(
        dimension: t.spacing.s250,
        child: LooviLoadingSpinner(
          size: LooviLoadingSpinnerSize.sm,
          dimension: t.spacing.s250,
          semanticLabel: widget.loadingSemanticLabel,
        ),
      );
    } else if (widget.enabled && widget.showClearAction && !hasError && content != LooviAutocompleteContent.empty) {
      final clearColor = inverse ? (widget.enabled ? t.text.onColor : t.text.onColorDisabled) : t.text.primary;
      status = Semantics(
        button: true,
        enabled: widget.enabled,
        label: widget.clearSemanticLabel,
        excludeSemantics: true,
        onTap: widget.enabled ? _clear : null,
        child: LooviTapTarget(
          enabled: widget.enabled,
          onTap: _clear,
          child: SizedBox.square(
            dimension: t.spacing.s500,
            child: Center(
              child: LooviIcon(LooviIcons.xOutline, size: t.spacing.s200, color: clearColor),
            ),
          ),
        ),
      );
    }

    final Color expandColor;
    if (hasError && widget.enabled) {
      expandColor = inverse ? t.text.onColor : t.text.secondary;
    } else {
      expandColor = c.leadingIcon;
    }
    // The 48 target grows inward; the translate keeps the 20 icon painted at
    // the Figma end padding (spacing/300).
    final expand = Transform.translate(
      offset: Offset(rtl ? -tapInset : tapInset, 0),
      child: Semantics(
        button: true,
        enabled: widget.enabled,
        expanded: _expanded,
        label: _expanded ? widget.collapseSemanticLabel : widget.expandSemanticLabel,
        excludeSemantics: true,
        onTap: widget.enabled ? _toggle : null,
        child: LooviTapTarget(
          enabled: widget.enabled,
          onTap: _toggle,
          child: LooviIcon(
            _expanded ? LooviIcons.chevronUpOutline : LooviIcons.chevronDownOutline,
            size: t.spacing.s250,
            color: expandColor,
          ),
        ),
      ),
    );

    return Semantics(
      container: true,
      expanded: _expanded,
      child: LooviInput(
        label: widget.label,
        placeholder: (focused && content == LooviAutocompleteContent.empty) ? widget.placeholder : null,
        supportingText: widget.supportingText,
        showSupportingText: widget.showSupportingText,
        errorText: widget.errorText,
        error: widget.error,
        enabled: widget.enabled,
        appearance: widget.appearance,
        leadingIcon: widget.showLeadingIcon,
        leading: widget.leadingIcon,
        trailingAccessory: status,
        trailingAction: expand,
        controller: _controller,
        focusNode: _focusNode,
        onChanged: _onChanged,
        onSubmitted: widget.onSubmitted,
        textInputAction: widget.textInputAction ?? TextInputAction.search,
        inputFormatters: widget.inputFormatters,
        autofocus: widget.autofocus,
        showCursor: widget.showCursor,
      ),
    );
  }
}
