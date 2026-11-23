import 'dart:ui' show SemanticsRole;

import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../list_item/loovi_list_item.dart';

/// Seed `List.type`.
enum LooviListType {
  /// `plain` — embedded page list surface (no shadow, no vertical padding).
  plain,

  /// `dropdown` — elevated panel surface (elevation/2 shadow, 8 dp padding).
  /// The external trigger owns open state / expanded semantics.
  dropdown,
}

/// Seed `List` (Figma 3745:10921) — vertical container for [LooviListItem]
/// rows (items slot; DividerHorizontal may separate groups).
///
/// Shell corners use the product-theme token
/// `component/list-action/container/radius` (app-cliente → radius/500 = 20),
/// shared with ListActionDropdown. Fill `color/background-surface/0`.
/// `dropdown` adds the `elevation/2` effect (DROP_SHADOW `color/elevation/5`,
/// 0/16/24) and 8 dp vertical padding. [showScroll] paints the visual-only
/// right-edge thumb (`color/palette/graph`, radius full).
///
/// Semantics: role list; rows inside take role listItem. For menu/listbox
/// patterns the product wraps this panel with its own semantics.
class LooviList extends StatelessWidget {
  const LooviList({
    super.key,
    required this.children,
    this.type = LooviListType.dropdown,
    this.showScroll = false,
    this.semanticLabel,
  });

  /// Items slot — [LooviListItem] rows (or [LooviListItemDivider]).
  final List<Widget> children;

  /// Seed `type` (default `dropdown`, as in the component set).
  final LooviListType type;

  /// Seed `showScroll` — visual scroll affordance only.
  final bool showScroll;

  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final dropdown = type == LooviListType.dropdown;
    final radius = BorderRadius.circular(t.component.listAction.containerRadius);

    Widget items = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );

    if (showScroll) {
      items = Stack(
        children: [
          items,
          PositionedDirectional(
            top: t.spacing.s100,
            end: t.spacing.s100,
            child: ExcludeSemantics(
              child: Container(
                width: t.spacing.s050,
                height: t.spacing.s800,
                decoration: BoxDecoration(
                  color: t.color.paletteGraph,
                  borderRadius: BorderRadius.circular(t.radius.full),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Semantics(
      container: true,
      role: SemanticsRole.list,
      label: semanticLabel,
      explicitChildNodes: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: t.color.backgroundSurface0,
          borderRadius: radius,
          boxShadow: dropdown ? LooviEffects.box(t.effects.elevation2) : null,
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: dropdown ? t.spacing.s100 : t.spacing.s0),
            child: LooviListScope(child: items),
          ),
        ),
      ),
    );
  }
}
