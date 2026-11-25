import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../generated/loovi_icon_names.g.dart';
import '../table_mobile_cell/loovi_table_mobile_cell.dart';

/// Seed TableMobile (Figma 3452:2722) — one data row of a table on small
/// screens, composed of [LooviTableMobileCell]s. Stack rows in a `Column`
/// (each row draws its own bottom divider). Not a desktop Table/TableRow nor
/// a standalone Card.
///
/// Seed props → Dart:
/// - `columnCount` (2–6) = `values.length` + (tag ? 1 : 0); asserted.
/// - `showTag` = [tag] != null (the tag cell, seed slot; prefer a ChipTag).
/// - `interactive` = the expanded layout (second detailRow, chevron up). In
///   Figma it exists only for columnCount 4–6; the chevron toggle in the
///   first cell switches it at runtime ([initiallyExpanded],
///   [onExpandedChanged]).
/// - `state` = runtime: `pressed` while the row is touched ([onTap]); no
///   hover; focus/selected/disabled are not published.
///
/// Layout (Figma):
/// - columnCount 2–3 (compact, one row): values as primary cells; the last
///   cell is the tag, or — without tag — the last value as a secondary cell.
/// - columnCount 4–6: row = chevron toggle (action cell) + first 3 values
///   (primary) [+ plus-outline icon cell when [onAction] is set]; detailRow
///   (only while expanded) = the remaining values (secondary) + tag.
/// - [onAction] in the compact layout appends the icon cell too (Figma draws
///   it only on 4–6 with tag; kept available so the action is never lost).
///
/// Paint tokens (mode app-cliente):
/// - bottom divider `border/width/012` in `color/border/2`;
/// - cells: [LooviTableMobileCell] (`color/background-surface/0`, pressed
///   `interactive/pressed` on every visible cell); row cells min height
///   `spacing/800`; outer edges `spacing/200`, inner `spacing/100`;
/// - detailRow cells: min height `spacing/500`, padding bottom `spacing/200`,
///   first cell start `spacing/700` (aligned with the first primary text).
/// - data cells share the width equally (Figma mixes FIXED/HUG/FILL widths
///   per variant).
///
/// Semantics: the row is one container whose label lists the visible values
/// ("header: value" when [headers] is given) — values are truncated on screen
/// but complete here. With [onTap] it is a button. The chevron is a button
/// with the expanded state; the plus is a button named [actionLabel]; the tag
/// keeps its own semantics.
class LooviTableMobile extends StatefulWidget {
  const LooviTableMobile({
    super.key,
    required this.values,
    this.headers,
    this.tag,
    this.initiallyExpanded = false,
    this.onExpandedChanged,
    this.onTap,
    this.onAction,
    this.actionLabel = 'Adicionar',
    this.expandLabel = 'Mostrar detalhes',
    this.collapseLabel = 'Ocultar detalhes',
    this.semanticLabel,
  });

  /// Data values in reading order (primary first). With [tag], 1–5 values;
  /// without, 2–6.
  final List<String> values;

  /// Optional column names (same length as [values]) used only in the
  /// accessible label ("Placa: ABC1D23").
  final List<String>? headers;

  /// Seed `showTag` + slot of the tag cell. Null = no tag cell.
  final Widget? tag;

  /// Seed `interactive` at first build (columnCount 4–6).
  final bool initiallyExpanded;

  final ValueChanged<bool>? onExpandedChanged;

  /// Row tap (navigation / detail). Null = the row is static.
  final VoidCallback? onTap;

  /// plus-outline icon cell tap. Null = no icon cell.
  final VoidCallback? onAction;

  /// Accessible name of the plus-outline action.
  final String actionLabel;

  /// Accessible names of the chevron toggle (collapsed / expanded).
  final String expandLabel;
  final String collapseLabel;

  /// Overrides the row's accessible label.
  final String? semanticLabel;

  int get columnCount => values.length + (tag == null ? 0 : 1);

  /// True when the layout has the chevron + detailRow (columnCount 4–6).
  bool get isExpandable => columnCount >= 4;

  @override
  State<LooviTableMobile> createState() => _LooviTableMobileState();
}

class _LooviTableMobileState extends State<LooviTableMobile> {
  late bool _expanded = widget.initiallyExpanded;
  bool _pressed = false;

  void _setPressed(bool v) {
    if (_pressed != v) setState(() => _pressed = v);
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    widget.onExpandedChanged?.call(_expanded);
  }

  @override
  void didUpdateWidget(LooviTableMobile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onTap == null) _pressed = false;
  }

  String _labelFor(int i) {
    final h = widget.headers;
    final v = widget.values[i];
    return h != null && i < h.length ? '${h[i]}: $v' : v;
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final count = widget.columnCount;
    assert(count >= 2 && count <= 6, 'TableMobile columnCount (values + tag) must be 2–6 (seed); got $count');
    assert(widget.headers == null || widget.headers!.length == widget.values.length, 'headers must match values');

    final state = _pressed ? LooviTableMobileCellState.pressed : LooviTableMobileCellState.standard;
    final expandable = widget.isExpandable;
    final expanded = expandable && _expanded;
    final values = widget.values;
    final edge = t.spacing.s200;
    final inner = t.spacing.s100;

    LooviTableMobileCell textCell(int i, LooviTableMobileCellType type, EdgeInsetsGeometry padding, {double? minHeight}) =>
        LooviTableMobileCell(
          type: type,
          state: state,
          label: values[i],
          padding: padding,
          minHeight: minHeight,
          excludeTextSemantics: true,
        );

    final actionCell = widget.onAction == null
        ? null
        : LooviTableMobileCell(
            type: LooviTableMobileCellType.icon,
            state: state,
            icon: LooviIcons.plusOutline,
            label: widget.actionLabel,
            onPressed: widget.onAction,
            padding: EdgeInsetsDirectional.only(start: inner, end: edge),
          );

    final row = <Widget>[];
    final detail = <Widget>[];
    final announced = <int>[];

    if (!expandable) {
      final hasTag = widget.tag != null;
      final dataCells = values.length;
      for (var i = 0; i < dataCells; i++) {
        final first = i == 0;
        final lastOverall = !hasTag && i == dataCells - 1 && actionCell == null;
        final type = !hasTag && i == dataCells - 1 ? LooviTableMobileCellType.secondary : LooviTableMobileCellType.primary;
        row.add(
          Expanded(
            child: textCell(i, type, EdgeInsetsDirectional.only(start: first ? edge : inner, end: lastOverall ? edge : inner)),
          ),
        );
        announced.add(i);
      }
      if (hasTag) {
        row.add(
          Expanded(
            child: LooviTableMobileCell(
              type: LooviTableMobileCellType.tag,
              state: state,
              padding: EdgeInsetsDirectional.only(start: inner, end: actionCell == null ? edge : inner),
              child: widget.tag,
            ),
          ),
        );
      }
      if (actionCell != null) row.add(actionCell);
    } else {
      row.add(
        MergeSemantics(
          child: Semantics(
            expanded: expanded,
            child: LooviTableMobileCell(
              type: LooviTableMobileCellType.action,
              state: state,
              icon: expanded ? LooviIcons.chevronUpOutline : LooviIcons.chevronDownOutline,
              label: expanded ? widget.collapseLabel : widget.expandLabel,
              onPressed: _toggle,
              // Button keeps its 48 dp target, so the cell drops the Figma 8 start
              // padding to stay 48 wide (Figma: 8 + 40 painted).
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      );
      for (var i = 0; i < 3; i++) {
        final last = i == 2 && actionCell == null;
        row.add(
          Expanded(
            child: textCell(i, LooviTableMobileCellType.primary, EdgeInsetsDirectional.only(start: inner, end: last ? edge : inner)),
          ),
        );
        announced.add(i);
      }
      if (actionCell != null) row.add(actionCell);

      if (expanded) {
        final rest = values.length - 3;
        final cellsInDetail = rest + (widget.tag == null ? 0 : 1);
        for (var j = 0; j < rest; j++) {
          final i = 3 + j;
          final first = j == 0;
          final last = j == cellsInDetail - 1;
          detail.add(
            Expanded(
              child: textCell(
                i,
                LooviTableMobileCellType.secondary,
                EdgeInsetsDirectional.only(start: first ? t.spacing.s700 : inner, end: last ? edge : inner, bottom: edge),
                minHeight: t.spacing.s500,
              ),
            ),
          );
          announced.add(i);
        }
        if (widget.tag != null) {
          detail.add(
            Expanded(
              child: LooviTableMobileCell(
                type: LooviTableMobileCellType.tag,
                state: state,
                minHeight: t.spacing.s500,
                padding: EdgeInsetsDirectional.only(start: rest == 0 ? t.spacing.s700 : inner, end: edge, bottom: edge),
                child: widget.tag,
              ),
            ),
          );
        }
      }
    }

    final label = widget.semanticLabel ?? announced.map(_labelFor).join(', ');

    // The row paints the state fill too, so cells of different heights (tag,
    // large text) never leave gaps.
    // The divider is an inside stroke (Figma): painted over the cells, the
    // row stays spacing/800 tall.
    Widget block = DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: t.color.border2, width: t.borderWidth.s012),
        ),
      ),
      child: ColoredBox(
        color: state == LooviTableMobileCellState.pressed ? t.interactive.pressed : t.color.backgroundSurface0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: row),
            if (detail.isNotEmpty) Row(children: detail),
          ],
        ),
      ),
    );

    final onTap = widget.onTap;
    if (onTap != null) {
      block = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: onTap,
        excludeFromSemantics: true,
        child: block,
      );
    }

    return Semantics(container: true, button: onTap != null, label: label, onTap: onTap, child: block);
  }
}
