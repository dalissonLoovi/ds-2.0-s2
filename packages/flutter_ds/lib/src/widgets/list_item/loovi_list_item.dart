import 'dart:ui' show SemanticsRole;

import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../generated/loovi_icon_names.g.dart';
import '../list_item_leading_monogram/loovi_list_item_leading_monogram.dart';
import '../list_item_state_layer/loovi_list_item_state_layer.dart';

// Leading building blocks now live in their own seed-named files; re-exported
// so imports of this file keep resolving them.
export '../list_item_image_thumbnail/loovi_list_item_image_thumbnail.dart';
export '../list_item_leading_monogram/loovi_list_item_leading_monogram.dart';

/// Seed `ListItem.condition` — vertical content density.
enum LooviListItemCondition {
  /// `1-line` — min 56, padding 8/16, headline (+ optional overline).
  oneLine,

  /// `2-line` — min 72, padding 8/16, supporting text on one line (ellipsis).
  twoLine,

  /// `3-line` — min 88, padding 12/16, supporting text wraps.
  threeLine,
}

/// Seed `ListItem` (Figma 3735:7716) — selectable or navigable row used
/// inside [LooviList] (or any list) with headline, optional overline,
/// supporting text, trailing supporting text and leading/trailing slots.
///
/// Slots (seed `leading` / `trailing` axes):
/// * `icon` → [leadingIcon] (default contract `user-outline`) /
///   [trailingIcon] (`chevron-right-outline`), 24 dp, `text/primary`.
/// * `monogram` → [LooviListItemLeadingMonogram] (alias [LooviListItemMonogram]).
/// * `image` → [LooviListItemImageThumbnail]; `video` →
///   `LooviListItemVideoThumbnail`.
/// * `illustration` → `LooviListItemLeadingIllustration` /
///   `LooviListItemTrailingIllustration` (56 × 56, DS assets), or
///   [LooviListItemIllustrationSlot] with an app-supplied illustration.
/// * `payment-mark`, `checkbox`, `radio`, `switch` → free [leading] /
///   [trailing] widget (building blocks/controls ship elsewhere).
///
/// Interaction states (seed ListItemStateLayer): pressed = `interactive/pressed`
/// wash, focus = 2 dp `interactive/focus` ring (keyboard only). No hover on
/// mobile. Rows without [onTap] are static (no button semantics, no wash).
class LooviListItem extends StatefulWidget {
  const LooviListItem({
    super.key,
    required this.headline,
    this.condition = LooviListItemCondition.threeLine,
    this.overline,
    this.supportingText,
    this.trailingSupportingText,
    this.leading,
    this.leadingIcon,
    this.trailing,
    this.trailingIcon,
    this.showDivider = false,
    this.onTap,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
  }) : assert(leading == null || leadingIcon == null, 'Use leading OU leadingIcon, não ambos.'),
       assert(trailing == null || trailingIcon == null, 'Use trailing OU trailingIcon, não ambos.');

  /// Primary row text (seed `headline`, body/large/medium, `text/primary`).
  final String headline;

  /// Seed `condition`. `oneLine` never shows [supportingText].
  final LooviListItemCondition condition;

  /// Seed `overline` (shown when non-null = `showOverline=true`).
  final String? overline;

  /// Seed `supportingText` (shown when non-null = `showSupportingText=true`).
  final String? supportingText;

  /// Seed `trailingSupportingText` (shown when non-null).
  final String? trailingSupportingText;

  /// Free leading slot widget (monogram, thumbnail, illustration, control…).
  final Widget? leading;

  /// Shortcut for `leading=icon`: DS contract name, e.g. [LooviIcons.userOutline].
  final String? leadingIcon;

  /// Free trailing slot widget (illustration, control…).
  final Widget? trailing;

  /// Shortcut for `trailing=icon`: e.g. [LooviIcons.chevronRightOutline].
  final String? trailingIcon;

  /// Seed `showDivider` — full-width DividerHorizontal under the row.
  final bool showDivider;

  /// Makes the row interactive (button semantics, pressed/focus layer).
  final VoidCallback? onTap;

  /// Accessible label. Defaults to overline, headline, supporting and
  /// trailing text joined.
  final String? semanticLabel;

  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<LooviListItem> createState() => _LooviListItemState();
}

class _LooviListItemState extends State<LooviListItem> {
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => widget.onTap != null;

  void _setPressed(bool v) {
    if (_pressed != v) setState(() => _pressed = v);
  }

  @override
  void didUpdateWidget(LooviListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_enabled) {
      _pressed = false;
      _focused = false;
    }
  }

  String get _label =>
      widget.semanticLabel ??
      [
        widget.overline,
        widget.headline,
        if (widget.condition != LooviListItemCondition.oneLine) widget.supportingText,
        widget.trailingSupportingText,
      ].whereType<String>().join(', ');

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final c = widget.condition;

    final (double minHeight, double padV) = switch (c) {
      LooviListItemCondition.oneLine => (t.spacing.s700, t.spacing.s100),
      LooviListItemCondition.twoLine => (t.spacing.s900, t.spacing.s100),
      LooviListItemCondition.threeLine => (t.spacing.s1100, t.spacing.s150),
    };

    final metaStyle = t.typography.bodyMediumRegular.copyWith(color: t.text.secondary);
    final supporting = c == LooviListItemCondition.oneLine ? null : widget.supportingText;

    final content = ExcludeSemantics(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.overline != null) Text(widget.overline!, style: metaStyle),
          Text(widget.headline, style: t.typography.bodyLargeMedium.copyWith(color: t.text.primary)),
          if (supporting != null)
            Text(
              supporting,
              style: metaStyle,
              maxLines: c == LooviListItemCondition.twoLine ? 1 : null,
              overflow: c == LooviListItemCondition.twoLine ? TextOverflow.ellipsis : null,
            ),
        ],
      ),
    );

    final leading = widget.leading ??
        (widget.leadingIcon == null ? null : LooviIcon(widget.leadingIcon!, size: t.spacing.s300, color: t.text.primary));
    final trailingIcon = widget.trailingIcon == null
        ? null
        : LooviIcon(widget.trailingIcon!, size: t.spacing.s300, color: t.text.primary);
    final trailingSlotChildren = <Widget>[
      if (widget.trailingSupportingText != null)
        ExcludeSemantics(child: Text(widget.trailingSupportingText!, style: metaStyle, textAlign: TextAlign.right)),
      ?widget.trailing,
      ?trailingIcon,
    ];

    // Gap inside trailingSlot is 10 in the frame (not tokenized) → spacing/100.
    final trailingSlot = trailingSlotChildren.isEmpty
        ? null
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < trailingSlotChildren.length; i++) ...[
                if (i > 0) SizedBox(width: t.spacing.s100),
                trailingSlotChildren[i],
              ],
            ],
          );

    final contentRow = Padding(
      padding: EdgeInsets.symmetric(horizontal: t.spacing.s200, vertical: padV),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) ...[leading, SizedBox(width: t.spacing.s200)],
          Expanded(child: content),
          if (trailingSlot != null) ...[SizedBox(width: t.spacing.s200), trailingSlot],
        ],
      ),
    );

    // State layer behind the content row (Figma order); the row is centered
    // vertically inside the condition's min height.
    Widget row = Stack(
      children: [
        Positioned.fill(
          child: LooviListItemStateLayer(
            state: _pressed
                ? LooviListItemStateLayerState.pressed
                : _focused
                    ? LooviListItemStateLayerState.focus
                    : LooviListItemStateLayerState.standard,
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: minHeight),
          child: Align(alignment: AlignmentDirectional.centerStart, child: contentRow),
        ),
      ],
    );

    if (_enabled) {
      row = FocusableActionDetector(
        enabled: _enabled,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        mouseCursor: SystemMouseCursors.click,
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
            widget.onTap?.call();
            return null;
          }),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          onTap: widget.onTap,
          excludeFromSemantics: true,
          child: row,
        ),
      );
    }

    final inList = LooviListScope.maybeOf(context);
    return Semantics(
      container: true,
      role: inList ? SemanticsRole.listItem : null,
      button: _enabled,
      enabled: _enabled ? true : null,
      focusable: _enabled,
      focused: _enabled ? _focused : null,
      label: _label,
      onTap: widget.onTap,
      child: ColoredBox(
        color: t.color.backgroundSurface0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            row,
            if (widget.showDivider) const LooviListItemDivider(),
          ],
        ),
      ),
    );
  }
}

/// Divider used by `showDivider` (DividerHorizontal full-width, Figma
/// 3653:22922): 2 dp frame with a centered `border/width/012` line in
/// `color/border/2`.
class LooviListItemDivider extends StatelessWidget {
  const LooviListItemDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    return ExcludeSemantics(
      child: SizedBox(
        height: t.spacing.s025,
        child: Center(
          child: SizedBox(
            height: t.borderWidth.s012,
            width: double.infinity,
            child: ColoredBox(color: t.color.border2),
          ),
        ),
      ),
    );
  }
}

/// Earlier name of [LooviListItemLeadingMonogram] (seed ListItemLeadingMonogram,
/// Figma 3694:16194). Kept as an alias for backward compatibility.
typedef LooviListItemMonogram = LooviListItemLeadingMonogram;

/// Seed ListItemLeadingIllustration / ListItemTrailingIllustration slot
/// (Figma 5038:10): 56 × 56 box; the app passes the illustration asset.
class LooviListItemIllustrationSlot extends StatelessWidget {
  const LooviListItemIllustrationSlot({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = LooviTokens.of(context).spacing.s700;
    return ExcludeSemantics(
      child: SizedBox(width: size, height: size, child: FittedBox(fit: BoxFit.contain, child: child)),
    );
  }
}

/// Marks a subtree as the items slot of a list so [LooviListItem] can take
/// `SemanticsRole.listItem` (which Flutter only allows under a list node).
class LooviListScope extends InheritedWidget {
  const LooviListScope({super.key, required super.child});

  static bool maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LooviListScope>() != null;

  @override
  bool updateShouldNotify(LooviListScope oldWidget) => false;
}
