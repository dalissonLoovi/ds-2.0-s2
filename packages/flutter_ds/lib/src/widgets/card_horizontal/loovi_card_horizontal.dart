import 'package:loovi_tokens/loovi_tokens.dart';
import 'package:material_ui/material_ui.dart';

import '../avatar/loovi_avatar.dart';
import '../card_item/loovi_card_item_surface.dart';

/// Seed `CardHorizontal.style` — maps the background to
/// CardOutlinedItem | CardElevatedItem | CardFilledItem.
enum LooviCardHorizontalStyle { outlined, elevated, filled }

/// Seed `CardHorizontal.layout`. `media-and-text` → [mediaAndText].
enum LooviCardHorizontalLayout { mediaAndText, slot }

/// CardHorizontal (Figma 4170:4506) — horizontal Card with avatar + text +
/// media, or a custom [slot].
///
/// Paint (mode app-cliente):
/// - background: the Card*Item surface of [style] (surface, outline, shadow,
///   pressed / dragged / focus — see [LooviCardOutlinedItem] & co.), radius
///   `border/radius/300`; content clipped to the radius.
/// - layout=media-and-text: body padding + gap `spacing/200`; [LooviAvatar]
///   initials/sm (48); text gap `spacing/050`; [headerText]
///   heading/h3/regular `text/primary`; [subheadText] body/medium/regular
///   `text/secondary`; media `spacing/1000` (80) wide, full height, photo
///   cover over `color/background-surface/2`.
/// - layout=slot: padding `spacing/200` horizontal / `spacing/100` vertical.
///
/// Width comes from the parent (Figma demo 360); height hugs the content
/// (minimum `spacing/1000`) so the system text scale never clips.
class LooviCardHorizontal extends StatelessWidget {
  const LooviCardHorizontal({
    super.key,
    this.style = LooviCardHorizontalStyle.outlined,
    this.layout = LooviCardHorizontalLayout.mediaAndText,
    this.headerText = 'Header',
    this.subheadText = 'Subhead',
    this.avatarInitials,
    this.avatarImage,
    this.media,
    this.mediaSemanticLabel,
    this.slot,
    this.onPressed,
    this.dragged = false,
    this.showFocusIndicator = true,
    this.semanticLabel,
  });

  final LooviCardHorizontalStyle style;
  final LooviCardHorizontalLayout layout;

  /// Seed `headerText` (media-and-text).
  final String headerText;

  /// Seed `subheadText` (media-and-text).
  final String subheadText;

  /// Exposed Avatar: initials (max 2). Null + null [avatarImage] = placeholder.
  final String? avatarInitials;

  /// Exposed Avatar: photo (wins over [avatarInitials]).
  final ImageProvider? avatarImage;

  /// Media photo supplied by the app. Null = `background-surface/2` placeholder.
  final ImageProvider? media;

  /// Alt text for [media]. Null = decorative.
  final String? mediaSemanticLabel;

  /// Seed `slot` (layout=slot).
  final Widget? slot;

  /// Makes the whole card pressable (Card*Item pressed/focus).
  final VoidCallback? onPressed;

  /// Seed background `state=dragged`.
  final bool dragged;

  /// Seed background `showFocusIndicator`.
  final bool showFocusIndicator;

  /// Overrides the accessible name. Default: the visible texts (header first),
  /// merged into the card node.
  final String? semanticLabel;

  LooviCardItemKind get _kind => switch (style) {
        LooviCardHorizontalStyle.outlined => LooviCardItemKind.outlined,
        LooviCardHorizontalStyle.elevated => LooviCardItemKind.elevated,
        LooviCardHorizontalStyle.filled => LooviCardItemKind.filled,
      };

  @override
  Widget build(BuildContext context) {
    final t = LooviTokens.of(context);
    final Widget content;
    if (layout == LooviCardHorizontalLayout.slot) {
      content = Padding(
        padding: EdgeInsets.symmetric(horizontal: t.spacing.s200, vertical: t.spacing.s100),
        child: slot ?? const SizedBox.shrink(),
      );
    } else {
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
      content = ConstrainedBox(
        constraints: BoxConstraints(minHeight: t.spacing.s1000),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(t.spacing.s200),
                  child: Row(
                    children: [
                      ExcludeSemantics(child: avatar),
                      SizedBox(width: t.spacing.s200),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(headerText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: t.typography.headingH3Regular.copyWith(color: t.text.primary)),
                            SizedBox(height: t.spacing.s050),
                            Text(subheadText,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: t.typography.bodyMediumRegular.copyWith(color: t.text.secondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: t.spacing.s1000, child: LooviCardMedia(image: media, semanticLabel: mediaSemanticLabel)),
            ],
          ),
        ),
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
