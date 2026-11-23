import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundation/loovi_icon.dart';
import '../../generated/loovi_icon_names.g.dart';

/// Seed `ChipTag.size`.
enum LooviChipTagSize { sm, md }

/// Seed `ChipTag.intent`. Feedback vocabulary + `outline` + `brand`.
enum LooviChipTagIntent { info, system, success, warning, danger, outline, brand }

/// Seed `ChipTag.width`.
enum LooviChipTagWidth { hug, fill }

/// Seed `ChipTag.emphasis`.
enum LooviChipTagEmphasis { strong, soft }

/// ChipTag (Figma 3653:23220) — compact, NON-interactive label for category,
/// status or metadata. Never focusable, never tappable: use
/// `LooviChipClickable` for interaction.
///
/// Paint (mode app-cliente):
/// - strong: `color/background-feedback-primary/{intent}` + `text/primary`.
/// - soft: `color/background-feedback-secondary/{intent}` (published for
///   success; warning/danger use the token of the same family; info/system
///   have no secondary token and fall back to strong).
/// - outline: no fill + `color/border/2` stroke (`border/width/012`).
/// - brand: `color/background-surface/brand` + `text/on-color`.
/// - disabled (`state=disabled`): fill `color/border/2`, label `text/secondary`.
class LooviChipTag extends StatelessWidget {
  const LooviChipTag({
    super.key,
    required this.label,
    this.size = LooviChipTagSize.md,
    this.intent = LooviChipTagIntent.info,
    this.width = LooviChipTagWidth.hug,
    this.emphasis = LooviChipTagEmphasis.strong,
    this.disabled = false,
    this.showLeadingIcon = false,
    this.leadingIcon = LooviIcons.circleCheckFilled,
    this.avatar,
    this.decorative = false,
  });

  /// Visible label (seed `label`).
  final String label;
  final LooviChipTagSize size;
  final LooviChipTagIntent intent;
  final LooviChipTagWidth width;
  final LooviChipTagEmphasis emphasis;

  /// Seed `state=disabled`.
  final bool disabled;

  /// Seed `showLeadingIcon`.
  final bool showLeadingIcon;

  /// Seed `leadingIcon` (DS contract name, e.g. [LooviIcons.circleCheckFilled]).
  final String leadingIcon;

  /// Seed `showAvatar` slot: any image widget, clipped to a circle at the
  /// Figma avatar size (sm 20, md 24). Null = hidden.
  final Widget? avatar;

  /// When true the tag is hidden from assistive technologies (seed:
  /// "If decorative, it may be aria-hidden").
  final bool decorative;

  bool get _isSm => size == LooviChipTagSize.sm;

  Color? _fill(LooviTokens t) {
    if (disabled) return t.color.border2;
    final soft = emphasis == LooviChipTagEmphasis.soft;
    switch (intent) {
      case LooviChipTagIntent.info:
        return t.color.backgroundFeedbackPrimaryInfo;
      case LooviChipTagIntent.system:
        return t.color.backgroundFeedbackPrimarySystem;
      case LooviChipTagIntent.success:
        return soft ? t.color.backgroundFeedbackSecondarySuccess : t.color.backgroundFeedbackPrimarySuccess;
      case LooviChipTagIntent.warning:
        return soft ? t.color.backgroundFeedbackSecondaryWarning : t.color.backgroundFeedbackPrimaryWarning;
      case LooviChipTagIntent.danger:
        return soft ? t.color.backgroundFeedbackSecondaryDanger : t.color.backgroundFeedbackPrimaryDanger;
      case LooviChipTagIntent.outline:
        return null;
      case LooviChipTagIntent.brand:
        return t.color.backgroundSurfaceBrand;
    }
  }

  Color _content(LooviTokens t) {
    if (disabled) return t.text.secondary;
    if (intent == LooviChipTagIntent.brand) return t.text.onColor;
    return t.text.primary;
  }

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final content = _content(t);
    final fill = width == LooviChipTagWidth.fill;
    final outlined = intent == LooviChipTagIntent.outline && !disabled;

    final labelText = Text(
      label,
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      style: (_isSm ? t.typography.bodySmallMedium : t.typography.bodyMediumMedium).copyWith(color: content),
    );

    // content frame: pl spacing/100; md fixed 32 (spacing/400) tall.
    Widget contentFrame = Padding(
      padding: EdgeInsets.only(left: t.spacing.s100),
      child: labelText,
    );
    if (!_isSm) {
      contentFrame = ConstrainedBox(
        constraints: BoxConstraints(minHeight: t.spacing.s400),
        child: Align(widthFactor: 1, heightFactor: 1, alignment: Alignment.centerLeft, child: contentFrame),
      );
    }

    final avatarSize = _isSm ? t.spacing.s250 : t.spacing.s300;
    final row = Row(
      mainAxisSize: fill ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showLeadingIcon)
          // Figma leadingIcon frame: sm 20 (spacing/250), md 32 (spacing/400).
          LooviIcon(leadingIcon, size: _isSm ? t.spacing.s250 : t.spacing.s400, color: content),
        if (avatar != null)
          ClipOval(child: SizedBox.square(dimension: avatarSize, child: FittedBox(fit: BoxFit.cover, child: avatar))),
        if (fill) Flexible(child: contentFrame) else contentFrame,
      ],
    );

    // Root: sm = fixed 24 (spacing/300), pl 2 / pr 12; md = py 4, pl 8 / pr 16.
    final padding = _isSm
        ? EdgeInsets.only(left: t.spacing.s025, right: t.spacing.s150)
        : EdgeInsets.fromLTRB(t.spacing.s100, t.spacing.s050, t.spacing.s200, t.spacing.s050);

    Widget chip = DecoratedBox(
      decoration: BoxDecoration(
        color: _fill(t),
        borderRadius: BorderRadius.circular(t.radius.full),
        border: outlined ? Border.all(color: t.color.border2, width: t.borderWidth.s012) : null,
      ),
      child: Padding(
        padding: padding,
        child: _isSm ? SizedBox(height: t.spacing.s300, child: row) : row,
      ),
    );

    if (decorative) return ExcludeSemantics(child: chip);
    return Semantics(
      container: true,
      label: label,
      enabled: disabled ? false : null,
      child: ExcludeSemantics(child: chip),
    );
  }
}
