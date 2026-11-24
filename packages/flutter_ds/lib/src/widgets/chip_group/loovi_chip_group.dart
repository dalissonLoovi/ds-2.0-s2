import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../generated/loovi_icon_names.g.dart';
import '../chip_clickable/loovi_chip_clickable.dart';

/// Seed `ChipGroup.type`. Only changes the chip semantics: `filter` chips are
/// selectable toggles; `input` chips may carry a delete action.
enum LooviChipGroupType { input, assistive, filter, suggestion }

/// Seed `ChipGroup.layout` (`single-row-scrollable` | `multi-row-wrap`).
enum LooviChipGroupLayout { singleRowScrollable, multiRowWrap }

/// One chip of a [LooviChipGroup]. The group builds it as a
/// [LooviChipClickable] with the seed mapping (outline, sm, hug).
@immutable
class LooviChipGroupEntry {
  const LooviChipGroupEntry({
    required this.label,
    required this.onPressed,
    this.selected = false,
    this.disabled = false,
    this.leadingIcon,
    this.onDelete,
    this.deleteSemanticLabel,
  });

  final String label;

  /// Null = disabled.
  final VoidCallback? onPressed;

  /// Seed `state=selected` — exposed as selected; meaningful for `filter`.
  final bool selected;
  final bool disabled;

  /// Optional leading icon (`LooviIcons.*`). Null = hidden (seed default).
  final String? leadingIcon;

  /// Shows the delete action (`x-outline`) when set. Seed: only when the
  /// pattern requires it (typically `input`).
  final VoidCallback? onDelete;
  final String? deleteSemanticLabel;
}

/// ChipGroup S2 (Figma `3667:2570`, mode app-cliente) — layout of
/// ChipClickable chips for input, assistive, filter or suggestion patterns.
///
/// Every chip is a [LooviChipClickable] with `intent=outline`, `size=sm`,
/// `width=hug` (seed rule `chipMapping`); avatar and delete are off unless an
/// entry asks for them. Chip paint comes from ChipClickable tokens.
///
/// Layout (mode app-cliente):
/// - gap between chips `spacing/100`; horizontal padding `spacing/050`.
/// - singleRowScrollable: one horizontally scrolling row.
/// - multiRowWrap: wrapping rows. Each chip already occupies its 48 dp touch
///   box (25 painted), which separates the rows by more than the Figma
///   row gap (16, unbound) and replaces the vertical padding `spacing/100`,
///   so no extra run spacing / vertical padding is added.
///
/// Semantics: a container named [semanticLabel] (seed: accessible group
/// label); each chip is a button, selected filters expose `selected`.
class LooviChipGroup extends StatelessWidget {
  const LooviChipGroup({
    super.key,
    required this.entries,
    required this.semanticLabel,
    this.type = LooviChipGroupType.input,
    this.layout = LooviChipGroupLayout.singleRowScrollable,
  });

  final List<LooviChipGroupEntry> entries;

  /// Accessible group name (e.g. "Filtros").
  final String semanticLabel;

  final LooviChipGroupType type;
  final LooviChipGroupLayout layout;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final chips = [
      for (final e in entries)
        LooviChipClickable(
          label: e.label,
          onPressed: e.onPressed,
          size: LooviChipClickableSize.sm,
          intent: LooviChipClickableIntent.outline,
          width: LooviChipClickableWidth.hug,
          selected: e.selected,
          disabled: e.disabled,
          showLeadingIcon: e.leadingIcon != null,
          leadingIcon: e.leadingIcon ?? LooviIcons.plusOutline,
          showDeleteAction: e.onDelete != null,
          onDelete: e.onDelete,
          deleteSemanticLabel: e.deleteSemanticLabel,
        ),
    ];

    final Widget body;
    switch (layout) {
      case LooviChipGroupLayout.singleRowScrollable:
        body = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: t.spacing.s050),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < chips.length; i++) ...[
                if (i > 0) SizedBox(width: t.spacing.s100),
                chips[i],
              ],
            ],
          ),
        );
      case LooviChipGroupLayout.multiRowWrap:
        body = Padding(
          padding: EdgeInsets.symmetric(horizontal: t.spacing.s050),
          child: Wrap(spacing: t.spacing.s100, crossAxisAlignment: WrapCrossAlignment.center, children: chips),
        );
    }

    return Semantics(container: true, explicitChildNodes: true, label: semanticLabel, child: body);
  }
}
