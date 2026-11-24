import 'dart:ui' show SemanticsRole;

import 'package:flutter/services.dart';
import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../foundation/loovi_tap_target.dart';
import '../../generated/loovi_icon_names.g.dart';
import '../divider_horizontal/loovi_divider_horizontal.dart';
import '../list_item/loovi_list_item.dart';

/// Seed `SearchViewFullscreen.content` — derived at runtime from the field
/// text: [value] when non-empty, else [placeholder].
enum LooviSearchViewFullscreenContent { value, placeholder }

/// Seed `SearchViewFullscreen` (Figma 3883:16492) — full-screen search
/// surface (Material search view remapped to S2), opened from
/// `LooviSearchBar`. Mode app-cliente.
///
/// Anatomy / paint:
/// - root + header + results fill `color/background-surface/0`.
/// - header: height 56 (`spacing/700`), Figma padding 8 vert × 12 horiz and
///   gap 8 (frame not tokenized → `spacing/100` / `spacing/150`).
///   backIcon / clearIcon 24 (`spacing/300`) `text/primary`, each a named
///   button whose 48 target takes the header padding / gap around the icon
///   (row = `spacing/050` + 48 + `spacing/050`), so the icons paint where
///   Figma puts them.
/// - field: `body/large/regular`; query `text/primary`; placeholder
///   `text/placeholder`; caret `interactive/focus` 2 × 16
///   (`border/width/025` × `spacing/200`).
/// - clearIcon only when content=value and [showClear].
/// - DividerHorizontal full-width, then the results ([items], ListItem
///   2-line + monogram preferred) as a scrollable list (role list, no shell —
///   rows paint their own `color/background-surface/0`) when [showResults].
///
/// Accessibility: the surface is a search container; the field is labelled
/// with [placeholder]; back / clear are named buttons; results are a list.
class LooviSearchViewFullscreen extends StatefulWidget {
  const LooviSearchViewFullscreen({
    super.key,
    this.placeholder = 'Pesquisar',
    this.showBack = true,
    this.showClear = true,
    this.backIcon = LooviIcons.arrowNarrowLeftOutline,
    this.clearIcon = LooviIcons.xOutline,
    this.showResults = true,
    this.items = const [],
    this.onBack,
    this.onClear,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = true,
    this.showCursor,
    this.inputFormatters,
    this.backSemanticLabel = 'Voltar',
    this.clearSemanticLabel = 'Limpar busca',
    this.useSafeArea = true,
  });

  /// Seed `placeholder` (content=placeholder) — also the field's label.
  final String placeholder;

  /// Seed `showBack`.
  final bool showBack;

  /// Seed `showClear` — visible only when content=value.
  final bool showClear;

  /// Seed `backIcon` (INSTANCE_SWAP, default `arrow-narrow-left-outline`).
  final String backIcon;

  /// Seed `clearIcon` (INSTANCE_SWAP, default `x-outline`).
  final String clearIcon;

  /// Seed `showResults`.
  final bool showResults;

  /// Seed `items` (SLOT → ListItem).
  final List<Widget> items;

  /// Back tap. Null = `Navigator.maybePop`.
  final VoidCallback? onBack;

  /// Called after the clear action empties the field.
  final VoidCallback? onClear;

  /// Seed `query` lives in the controller text.
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// Default true: the view opens ready to type.
  final bool autofocus;

  /// Forwarded to [TextField.showCursor] (goldens turn it off).
  final bool? showCursor;
  final List<TextInputFormatter>? inputFormatters;

  final String backSemanticLabel;
  final String clearSemanticLabel;

  /// Pads the header below the top system inset.
  final bool useSafeArea;

  @override
  State<LooviSearchViewFullscreen> createState() => _LooviSearchViewFullscreenState();
}

class _LooviSearchViewFullscreenState extends State<LooviSearchViewFullscreen> {
  TextEditingController? _ownController;
  TextEditingController get _controller => widget.controller ?? (_ownController ??= TextEditingController());

  @override
  void initState() {
    super.initState();
    _controller.addListener(_rebuild);
  }

  @override
  void didUpdateWidget(LooviSearchViewFullscreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _ownController)?.removeListener(_rebuild);
      _controller.addListener(_rebuild);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_rebuild);
    _ownController?.dispose();
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  LooviSearchViewFullscreenContent get _content => _controller.text.isNotEmpty
      ? LooviSearchViewFullscreenContent.value
      : LooviSearchViewFullscreenContent.placeholder;

  void _back() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else {
      Navigator.maybePop(context);
    }
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final scaler = MediaQuery.textScalerOf(context);
    final iconSize = t.spacing.s300;
    final tapInset = (LooviTapTarget.minSize(context) - iconSize) / 2;
    final hPad = t.spacing.s150;
    final gap = t.spacing.s100;
    final isValue = _content == LooviSearchViewFullscreenContent.value;
    final style = t.typography.bodyLargeRegular;

    Widget iconAction(String icon, String label, VoidCallback onTap) => Semantics(
      container: true,
      button: true,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: LooviTapTarget(
        onTap: onTap,
        child: LooviIcon(icon, size: iconSize, color: t.text.primary),
      ),
    );

    final field = Expanded(
      child: Semantics(
        label: widget.placeholder,
        child: TextField(
          controller: _controller,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          inputFormatters: widget.inputFormatters,
          textInputAction: TextInputAction.search,
          keyboardType: TextInputType.text,
          showCursor: widget.showCursor,
          style: style.copyWith(color: t.text.primary),
          cursorColor: t.interactive.focus,
          cursorWidth: t.borderWidth.s025,
          cursorHeight: scaler.scale(t.spacing.s200),
          cursorRadius: Radius.circular(t.borderWidth.s012),
          decoration: InputDecoration.collapsed(
            hintText: widget.placeholder,
            hintStyle: style.copyWith(color: t.text.placeholder),
          ),
        ),
      ),
    );

    final showBack = widget.showBack;
    final showClear = widget.showClear && isValue;
    // Icon actions grow their 48 target into the header padding / gap.
    final header = ConstrainedBox(
      constraints: BoxConstraints(minHeight: t.spacing.s700),
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: showBack ? (hPad - tapInset).clamp(0, hPad).toDouble() : hPad,
          end: showClear ? (hPad - tapInset).clamp(0, hPad).toDouble() : hPad,
          top: t.spacing.s050,
          bottom: t.spacing.s050,
        ),
        child: Row(
          children: [
            if (showBack) ...[
              iconAction(widget.backIcon, widget.backSemanticLabel, _back),
              SizedBox(width: (gap - tapInset).clamp(0, gap).toDouble()),
            ],
            field,
            if (showClear) ...[
              SizedBox(width: (gap - tapInset).clamp(0, gap).toDouble()),
              iconAction(widget.clearIcon, widget.clearSemanticLabel, _clear),
            ],
          ],
        ),
      ),
    );

    final showResults = widget.showResults && widget.items.isNotEmpty;
    final top = widget.useSafeArea ? MediaQuery.paddingOf(context).top : 0.0;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: ColoredBox(
        color: t.color.backgroundSurface0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(top: top),
              child: header,
            ),
            const LooviDividerHorizontal(),
            if (showResults)
              Expanded(
                child: SingleChildScrollView(
                  child: Semantics(
                    container: true,
                    role: SemanticsRole.list,
                    explicitChildNodes: true,
                    child: LooviListScope(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: widget.items),
                    ),
                  ),
                ),
              )
            else
              const Spacer(),
          ],
        ),
      ),
    );
  }
}
