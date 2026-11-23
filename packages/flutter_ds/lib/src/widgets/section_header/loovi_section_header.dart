import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../generated/loovi_icon_names.g.dart';
import '../app_header/loovi_app_header.dart' show LooviHeaderIconAction, looviPlusDarker;

/// Seed `SectionHeader.emphasis`.
enum LooviSectionHeaderEmphasis { primary, secondary }

/// SectionHeader (Figma 4235:406) — section title row with an optional
/// trailing action. Body content is composed separately below.
///
/// Paint (mode app-cliente), published 4/4 (emphasis × showAction):
/// - root pad/gap `spacing/0`, SPACE_BETWEEN when [showAction].
/// - primary: title `body/large/semi-bold` + `text/primary`; secondary:
///   `body/medium/regular` + `text/secondary`.
/// - action: Button text/sm icon-only (default arrow-narrow-right-outline,
///   16), chip 32 (frame not tokenized → `spacing/400`), fill
///   `component/section-header/action/background` (surface/2), radius
///   `component/section-header/action/radius` (full). Icon `text/primary`;
///   secondary `text/secondary`. Pressed: `interactive/pressed` Plus Darker
///   over the fill.
///
/// The action keeps its 32 paint and gets a 48 (`spacing/600`) hit box, so a
/// row with the action is laid out 48 tall (Figma 32); see LooviTapTarget.
class LooviSectionHeader extends StatelessWidget {
  const LooviSectionHeader({
    super.key,
    required this.title,
    this.emphasis = LooviSectionHeaderEmphasis.primary,
    this.showAction = false,
    this.onActionPressed,
    this.actionIcon = LooviIcons.arrowNarrowRightOutline,
    this.actionLabel = 'Ver mais',
  });

  /// Seed `title` (TEXT). Exposed as a heading (primary level 2, secondary 3).
  final String title;

  final LooviSectionHeaderEmphasis emphasis;

  /// Seed `showAction`.
  final bool showAction;

  /// Action tap (seed React `onActionPress`). Null = action disabled.
  final VoidCallback? onActionPressed;

  /// Action icon (INSTANCE_SWAP, default arrow-narrow-right-outline).
  final String actionIcon;

  /// Accessible name of the icon-only action.
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final primary = emphasis == LooviSectionHeaderEmphasis.primary;
    final color = primary ? t.text.primary : t.text.secondary;
    final style = (primary ? t.typography.bodyLargeSemiBold : t.typography.bodyMediumRegular).copyWith(color: color);
    final fill = t.component.sectionHeader.actionBackground;

    final titleWidget = Semantics(
      header: true,
      headingLevel: primary ? 2 : 3,
      child: Text(title, maxLines: 1, softWrap: false, overflow: TextOverflow.ellipsis, style: style),
    );

    return Padding(
      padding: EdgeInsets.all(t.spacing.s0),
      child: Row(
        mainAxisAlignment: showAction ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
        children: [
          Expanded(child: titleWidget),
          if (showAction)
            LooviHeaderIconAction(
              icon: actionIcon,
              semanticLabel: actionLabel,
              onPressed: onActionPressed,
              size: t.spacing.s400,
              iconSize: t.spacing.s200,
              iconColor: color,
              background: fill,
              pressedBackground: looviPlusDarker(fill, t.interactive.pressed),
              radius: t.component.sectionHeader.actionRadius,
              // Paint flush right like the frame; the 48 hit box grows inward.
              alignment: AlignmentDirectional.centerEnd,
            ),
        ],
      ),
    );
  }
}
