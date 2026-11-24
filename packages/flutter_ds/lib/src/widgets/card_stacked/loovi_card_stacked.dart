import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../../generated/loovi_icon_names.g.dart';
import '../avatar/loovi_avatar.dart';
import '../button/loovi_button.dart';
import '../card_item/loovi_card_item_surface.dart';

/// Seed `CardStacked.style` — maps the background to
/// CardOutlinedItem | CardElevatedItem | CardFilledItem.
enum LooviCardStackedStyle { outlined, elevated, filled }

/// Seed `CardStacked.layout`. `media-and-text` → [mediaAndText].
enum LooviCardStackedLayout { mediaAndText, slot }

/// CardStacked (Figma 4170:4433) — vertical Card with header row, media,
/// headline, supporting text and actions, or a custom [slot].
///
/// Paint (mode app-cliente):
/// - background: the Card*Item surface of [style] (see
///   [LooviCardOutlinedItem] & co.), radius `border/radius/300`; content
///   clipped to the radius.
/// - headerRow: padding `spacing/150` vertical, `spacing/200` left,
///   `spacing/050` right; leading gap `spacing/200`; [LooviAvatar]
///   initials/sm; text gap `spacing/050`; [headerText] heading/h3/regular
///   `text/primary`; [subheadText] body/medium/regular `text/secondary`;
///   menuAction = [LooviButton] text/sm icon-only `dots-vertical-outline`.
/// - media: full width, Figma ratio 360 × 188 (frame not tokenized), photo
///   cover over `color/background-surface/2`.
/// - body: padding `spacing/200`, gap `spacing/400`; headline gap
///   `spacing/050`; [titleText] heading/h3/regular `text/primary`;
///   [subtitleText] + [supportingText] body/medium/regular `text/secondary`;
///   actions end-aligned, gap `spacing/100`: secondary [LooviButton]
///   outline/sm ([showSecondaryAction]) + primary [LooviButton] solid/sm.
/// - layout=slot: padding `spacing/100` vertical / `spacing/200` horizontal
///   (the Figma slot gap `spacing/150` belongs to the product's own
///   composition — [slot] is a single child).
///
/// Width comes from the parent (Figma demo 360); height hugs the content.
class LooviCardStacked extends StatelessWidget {
  const LooviCardStacked({
    super.key,
    this.style = LooviCardStackedStyle.outlined,
    this.layout = LooviCardStackedLayout.mediaAndText,
    this.headerText = 'Header',
    this.subheadText = 'Subhead',
    this.titleText = 'Title',
    this.subtitleText = 'Subtitle',
    this.supportingText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
    this.avatarInitials,
    this.avatarImage,
    this.media,
    this.mediaSemanticLabel,
    this.showMenuAction = true,
    this.onMenuPressed,
    this.menuSemanticLabel = 'Mais opções',
    this.primaryActionLabel = 'Primary',
    this.onPrimaryPressed,
    this.showSecondaryAction = true,
    this.secondaryActionLabel = 'Secondary',
    this.onSecondaryPressed,
    this.slot,
    this.onPressed,
    this.dragged = false,
    this.showFocusIndicator = true,
    this.semanticLabel,
  });

  final LooviCardStackedStyle style;
  final LooviCardStackedLayout layout;

  /// Seed `headerText`.
  final String headerText;

  /// Seed `subheadText`.
  final String subheadText;

  /// Seed `titleText`.
  final String titleText;

  /// Seed `subtitleText`.
  final String subtitleText;

  /// Seed `supportingText`.
  final String supportingText;

  /// Exposed Avatar: initials (max 2). Null + null [avatarImage] = placeholder.
  final String? avatarInitials;

  /// Exposed Avatar: photo (wins over [avatarInitials]).
  final ImageProvider? avatarImage;

  /// Media photo supplied by the app. Null = `background-surface/2` placeholder.
  final ImageProvider? media;

  /// Alt text for [media]. Null = decorative.
  final String? mediaSemanticLabel;

  /// Exposed menuAction visibility (Figma always shows it).
  final bool showMenuAction;

  /// menuAction callback. Null = disabled button.
  final VoidCallback? onMenuPressed;

  /// Accessible name of the icon-only menuAction.
  final String menuSemanticLabel;

  /// Exposed primaryAction label (solid/sm).
  final String primaryActionLabel;
  final VoidCallback? onPrimaryPressed;

  /// Seed `showSecondaryAction` (default true).
  final bool showSecondaryAction;

  /// Exposed secondaryAction label (outline/sm).
  final String secondaryActionLabel;
  final VoidCallback? onSecondaryPressed;

  /// Seed `slot` (layout=slot).
  final Widget? slot;

  /// Makes the whole card pressable (Card*Item pressed/focus). Inner buttons
  /// keep their own actions.
  final VoidCallback? onPressed;

  /// Seed background `state=dragged`.
  final bool dragged;

  /// Seed background `showFocusIndicator`.
  final bool showFocusIndicator;

  /// Accessible name of the card node when pressable.
  final String? semanticLabel;

  /// Figma media frame 360 × 188 (no size token) — kept as a ratio so the
  /// card follows the parent width.
  static const double mediaAspectRatio = 360 / 188;

  LooviCardItemKind get _kind => switch (style) {
        LooviCardStackedStyle.outlined => LooviCardItemKind.outlined,
        LooviCardStackedStyle.elevated => LooviCardItemKind.elevated,
        LooviCardStackedStyle.filled => LooviCardItemKind.filled,
      };

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final Widget content;
    if (layout == LooviCardStackedLayout.slot) {
      content = Padding(
        padding: EdgeInsets.symmetric(horizontal: t.spacing.s200, vertical: t.spacing.s100),
        child: slot ?? const SizedBox.shrink(),
      );
    } else {
      final primary = t.typography.headingH3Regular.copyWith(color: t.text.primary);
      final secondary = t.typography.bodyMediumRegular.copyWith(color: t.text.secondary);
      final avatar = LooviAvatar(
        size: LooviAvatarSize.sm,
        content: avatarImage != null
            ? LooviAvatarContent.image
            : avatarInitials != null
                ? LooviAvatarContent.initials
                : LooviAvatarContent.placeholder,
        image: avatarImage,
        initials: avatarInitials,
      );

      final headerRow = Padding(
        padding: EdgeInsets.only(
          left: t.spacing.s200,
          top: t.spacing.s150,
          bottom: t.spacing.s150,
          right: t.spacing.s050,
        ),
        child: Row(
          children: [
            ExcludeSemantics(child: avatar),
            SizedBox(width: t.spacing.s200),
            Expanded(
              child: Semantics(
                container: true,
                header: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(headerText, maxLines: 1, overflow: TextOverflow.ellipsis, style: primary),
                    SizedBox(height: t.spacing.s050),
                    Text(subheadText, maxLines: 2, overflow: TextOverflow.ellipsis, style: secondary),
                  ],
                ),
              ),
            ),
            if (showMenuAction)
              LooviButton(
                label: menuSemanticLabel,
                showLabel: false,
                showIcon: true,
                leadingIcon: LooviIcons.dotsVerticalOutline,
                variant: LooviButtonVariant.text,
                size: LooviButtonSize.sm,
                semanticLabel: menuSemanticLabel,
                onPressed: onMenuPressed,
              ),
          ],
        ),
      );

      final body = Padding(
        padding: EdgeInsets.all(t.spacing.s200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              container: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titleText, style: primary),
                  SizedBox(height: t.spacing.s050),
                  Text(subtitleText, style: secondary),
                ],
              ),
            ),
            SizedBox(height: t.spacing.s400),
            Text(supportingText, style: secondary),
            SizedBox(height: t.spacing.s400),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: t.spacing.s100,
              runSpacing: t.spacing.s100,
              children: [
                if (showSecondaryAction)
                  LooviButton(
                    label: secondaryActionLabel,
                    variant: LooviButtonVariant.outline,
                    size: LooviButtonSize.sm,
                    onPressed: onSecondaryPressed,
                  ),
                LooviButton(
                  label: primaryActionLabel,
                  size: LooviButtonSize.sm,
                  onPressed: onPrimaryPressed,
                ),
              ],
            ),
          ],
        ),
      );

      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerRow,
          AspectRatio(
            aspectRatio: mediaAspectRatio,
            child: LooviCardMedia(image: media, semanticLabel: mediaSemanticLabel),
          ),
          body,
        ],
      );
    }

    return LooviCardItemSurface(
      kind: _kind,
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      dragged: dragged,
      showFocusIndicator: showFocusIndicator,
      semanticLabel: semanticLabel,
      child: content,
    );
  }
}
