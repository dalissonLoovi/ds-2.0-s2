import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../foundation/loovi_tap_target.dart';
import '../../generated/loovi_icon_names.g.dart';
import '../button/loovi_button.dart';
import '../tooltip/loovi_tooltip.dart';

/// Seed `TableMobileCell.type`.
enum LooviTableMobileCellType {
  /// Main value: `body/medium/medium` + `text/primary`.
  primary,

  /// Supporting value: `body/small/medium` + `text/secondary`.
  secondary,

  /// Compact status/tag content via [LooviTableMobileCell.child] (prefer a
  /// ChipTag).
  tag,

  /// Inline Button (variant=text, size=sm, icon-only). Default icon
  /// `info-circle-outline`.
  action,

  /// Icon-only affordance. Default icon `plus-outline`.
  icon,
}

/// Seed `TableMobileCell.state`. `default` is a reserved word in Dart, so the
/// seed value `default` maps to [standard]. `hover` is not mapped (mobile, no
/// hover). The cell is a visual building block: the owning row
/// ([LooviTableMobile]) drives [pressed] from touch; [selected] is a prop of
/// the product list (announce it on the row, not on the cell).
enum LooviTableMobileCellState {
  /// Seed `default` — `color/background-surface/0`.
  standard,

  /// Seed `pressed` — `interactive/pressed`.
  pressed,

  /// Seed `selected` — `interactive/selected`.
  selected,
}

/// Seed TableMobileCell (Figma 3452:2656) — one cell of a mobile table row
/// ([LooviTableMobile]). Not a Table, TableRow, Card, Button, Chip or layout
/// container.
///
/// Paint tokens (mode app-cliente):
/// - surface: `color/background-surface/0` | `interactive/pressed` |
///   `interactive/selected` ([state]); corners `border/radius/0`;
/// - min height `spacing/800` (64), padding `spacing/100` horizontal,
///   `spacing/0` vertical (the row overrides edge padding via [padding]);
/// - primary: `body/medium/medium` + `text/primary`; secondary:
///   `body/small/medium` + `text/secondary` (one line, ellipsis — the full
///   value stays in semantics);
/// - action: [LooviButton] variant=text, size=sm, icon-only (`text/primary`
///   icon, 40 dp painted, 48 dp touch target);
/// - icon: [LooviIcon] `spacing/300` (24) in `text/primary`.
///
/// Interaction:
/// - action with [tooltip]: tap toggles a [LooviTooltip] with that text (info
///   icon); with [onPressed]: tap calls it. One of the two is expected.
/// - icon with [onPressed]: the whole cell (≥ 48 dp) is a button.
///
/// Semantics: primary/secondary/tag cells carry their own text; action/icon
/// cells are buttons named [label] (icon-only needs it); a non-interactive
/// icon is decorative.
class LooviTableMobileCell extends StatelessWidget {
  const LooviTableMobileCell({
    super.key,
    this.type = LooviTableMobileCellType.primary,
    this.state = LooviTableMobileCellState.standard,
    this.label = '',
    this.child,
    this.icon,
    this.onPressed,
    this.tooltip,
    this.padding,
    this.minHeight,
    this.excludeTextSemantics = false,
  });

  /// Seed `type`.
  final LooviTableMobileCellType type;

  /// Seed `state` (visual; see [LooviTableMobileCellState]).
  final LooviTableMobileCellState state;

  /// Seed `label`: visible text on primary/secondary; accessible name of
  /// action/icon cells.
  final String label;

  /// Seed `slot` (type=tag).
  final Widget? child;

  /// Seed `icon` (INSTANCE_SWAP) — DS contract name for action/icon. Null =
  /// `info-circle-outline` (action) / `plus-outline` (icon).
  final String? icon;

  /// Action/icon tap.
  final VoidCallback? onPressed;

  /// Action only: text of the [LooviTooltip] opened by the icon.
  final String? tooltip;

  /// Overrides the cell padding (the row uses it for edge cells). Null =
  /// `spacing/100` horizontal.
  final EdgeInsetsGeometry? padding;

  /// Overrides the min height. Null = `spacing/800`.
  final double? minHeight;

  /// Excludes the visible primary/secondary text from semantics (the row
  /// announces the values in its own label).
  final bool excludeTextSemantics;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final fill = switch (state) {
      LooviTableMobileCellState.standard => t.color.backgroundSurface0,
      LooviTableMobileCellState.pressed => t.interactive.pressed,
      LooviTableMobileCellState.selected => t.interactive.selected,
    };

    Widget content = switch (type) {
      LooviTableMobileCellType.primary => _text(t.typography.bodyMediumMedium.copyWith(color: t.text.primary)),
      LooviTableMobileCellType.secondary => _text(t.typography.bodySmallMedium.copyWith(color: t.text.secondary)),
      LooviTableMobileCellType.tag => child ?? const SizedBox.shrink(),
      LooviTableMobileCellType.action => _action(t),
      LooviTableMobileCellType.icon => LooviIcon(icon ?? LooviIcons.plusOutline, size: t.spacing.s300, color: t.text.primary),
    };

    Widget cell = ColoredBox(
      color: fill,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight ?? t.spacing.s800),
        child: Padding(
          padding: padding ?? EdgeInsets.symmetric(horizontal: t.spacing.s100),
          child: Align(alignment: AlignmentDirectional.centerStart, widthFactor: 1, heightFactor: 1, child: content),
        ),
      ),
    );

    if (type == LooviTableMobileCellType.icon && onPressed != null) {
      cell = Semantics(
        container: true,
        button: true,
        label: label,
        onTap: onPressed,
        child: LooviTapTarget(
          onTap: onPressed,
          child: ExcludeSemantics(child: cell),
        ),
      );
    }
    return cell;
  }

  Widget _text(TextStyle style) {
    final text = Text(label, style: style, maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: false);
    return excludeTextSemantics ? ExcludeSemantics(child: text) : text;
  }

  Widget _action(LooviTokens t) {
    final name = icon ?? LooviIcons.infoCircleOutline;
    final description = tooltip;
    if (description == null) {
      return LooviButton(
        label: label,
        onPressed: onPressed,
        variant: LooviButtonVariant.text,
        size: LooviButtonSize.sm,
        showLabel: false,
        showIcon: true,
        leadingIcon: name,
      );
    }
    // Info icon: the tooltip anchor owns the tap (toggle); the Button is
    // paint only, so its own gesture and semantics are switched off.
    return Semantics(
      container: true,
      button: true,
      label: label,
      child: LooviTooltip(
        description: description,
        child: LooviTapTarget(
          child: IgnorePointer(
            child: ExcludeSemantics(
              child: LooviButton(
                label: label,
                onPressed: () {},
                variant: LooviButtonVariant.text,
                size: LooviButtonSize.sm,
                showLabel: false,
                showIcon: true,
                leadingIcon: name,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
